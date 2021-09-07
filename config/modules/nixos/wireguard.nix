{ config, lib, pkgs, nodes, name, ... }:

with lib;

let
  cfg = config.network.wireguard;
  hcfg = _: h: h.network.wireguard;
  netHostsSelf = mapAttrs hcfg (filterAttrs (_: x: x.network.wireguard.enable or false) nodes);
  netHosts = filterAttrs (n: x: n != name) netHostsSelf;
in
{
  options.network.wireguard = {
    enable = mkEnableOption "semi-automatic wireguard mesh";
    magicNumber = mkOption { type = types.ints.u8; };
    prefixV4 = mkOption {
      type = types.str;
      default = "10.42.69";
    };
    prefixV6 = mkOption {
      type = types.str;
      default = "fe80:";
    };
    keyPath = mkOption {
      type = types.str;
      default = "/etc/wireguard/mesh";
    };
    pubkey = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    publicAddress4 = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    publicAddress6 = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    fwmark = mkOption {
      type = with types; nullOr ints.u16;
      default = null;
    };
    mtu = mkOption {
      type = types.ints.u16;
      default = 1500;
    };
  };

  config = mkIf cfg.enable {
    networking.wireguard.interfaces = mapAttrs'
      (hname: hconf:
        let
          magicPort = 51820 + hconf.magicNumber + cfg.magicNumber;
          iname = "wgmesh-${substring 0 8 hname}";
        in
        nameValuePair iname {
          allowedIPsAsRoutes = false;
          privateKeyFile = cfg.keyPath;
          ips = [
            "${cfg.prefixV4}.${toString cfg.magicNumber}/24"
            "${cfg.prefixV6}:${toString cfg.magicNumber}/64"
          ];
          listenPort = magicPort;
          peers = optional (hconf.pubkey != null) {
            publicKey = hconf.pubkey;
            allowedIPs = [ "0.0.0.0/0" "::0/0" ];
            endpoint = with hconf; mkIf (publicAddress4 != null || publicAddress6 != null) (
              if (publicAddress4 != null)
              then "${publicAddress4}:${toString magicPort}"
              else "[${publicAddress6}]:${toString magicPort}"
            );
            persistentKeepalive = with hconf; mkIf (publicAddress4 == null && publicAddress6 == null) 25;
          };
          postSetup = ''
            ip route add ${cfg.prefixV4}.${toString hconf.magicNumber}/32 dev ${iname}
            ${optionalString (cfg.fwmark != null) "wg set ${iname} fwmark ${toString cfg.fwmark}"}
            ip link set ${iname} mtu ${toString cfg.mtu}
          '';
        }
      )
      netHosts;
    networking.firewall.allowedUDPPorts =
      mapAttrsToList (_: hconf: 51820 + hconf.magicNumber + cfg.magicNumber) netHosts;
  };
}
