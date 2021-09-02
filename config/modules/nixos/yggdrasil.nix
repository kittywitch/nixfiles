{ config, meta, lib, pkgs, ... }:

with lib;

let
  cfg = config.network.yggdrasil;
  calcAddr = pubkey: lib.readFile (pkgs.runCommandNoCC "calcaddr-${pubkey}" { } ''
    echo '{ EncryptionPublicKey: "${pubkey}" }' | ${config.services.yggdrasil.package}/bin/yggdrasil -useconf -address | tr -d '\n' > $out
  '').outPath;
in
{
  options.network.yggdrasil = {
    enable = mkEnableOption "Enable the yggdrasil-based private hexnet";
    pubkey = mkOption {
      type = types.str;
      description = "Public key of this node";
    };
    address = mkOption {
      type = types.str;
      description = "Main Yggdrasil address. Set automatically";
      default = calcAddr cfg.pubkey;
    };
    trust = mkOption {
      type = types.bool;
      description = "Open Firewall completely for the network";
      default = false;
    };
    listen.enable = mkOption {
      type = types.bool;
      description = "Allow other hosts in the network to connect directly";
      default = false;
    };
    listen.endpoints = mkOption {
      type = types.listOf types.str;
      description = "Endpoints to listen on";
      default = [ ];
    };
    dns.enable = mkOption {
      type = types.bool;
      description = "enable automatic dns record generation";
      default = false;
    };
    dns.zone = mkOption {
      type = types.str;
      description = "Main zone to insert DNS records into";
      default = "lilwit.ch";
    };
    dns.subdomain = mkOption {
      type = types.str;
      description = "subdomain to put the records into";
      default = "net";
    };
    tunnel.localV6 = mkOption {
      type = types.listOf types.str;
      description = "v6 subnets to expose";
      default = [ ];
    };
    tunnel.localV4 = mkOption {
      type = types.listOf types.str;
      description = "v4 subnets to expose";
      default = [ ];
    };
    tunnel.remoteV6 = mkOption {
      type = types.attrsOf types.str;
      description = "Extra v6 subnets to route";
      default = { };
    };
    tunnel.remoteV4 = mkOption {
      type = types.attrsOf types.str;
      description = "Extra v4 subnets to route";
      default = { };
    };
    extra.pubkeys = mkOption {
      type = types.attrsOf types.str;
      description = "Additional hosts to allow into the network. Keys won't be added to definition host.";
      default = { };
      example = { host = "0000000000000000000000000000000000000000000000000000000000000000"; };
    };
    extra.addresses = mkOption {
      type = types.attrsOf types.str;
      internal = true;
      default = mapAttrs (_: c: calcAddr c) cfg.extra.pubkeys;
    };
    extra.localV6 = mkOption {
      type = types.listOf types.str;
      description = "v6 subnets to expose, but not route";
      default = [ ];
    };
    extra.localV4 = mkOption {
      type = types.listOf types.str;
      description = "v4 subnets to expose, but not route";
      default = [ ];
    };
  };

  config = mkIf cfg.enable (
    let
      yggConfigs = filter
        (
          c: c.enable && (cfg.pubkey != c.pubkey)
        )
        (
          mapAttrsToList (_: node: node.network.yggdrasil or { enable = false; pubkey = null; }) meta.network.nodes
        );
      pubkeys = flatten (map (c: [ c.pubkey ] ++ (attrValues c.extra.pubkeys)) yggConfigs);
    in
    {
      assertions = [
        {
          assertion = !(cfg.listen.enable && (cfg.listen.endpoints == [ ]));
          message = "Specify network.yggdrasil.listen.endpoints";
        }
      ];

      networking.firewall.trustedInterfaces = mkIf cfg.trust [ "yggdrasil" ];

      services.yggdrasil = {
        enable = true;
        persistentKeys = true;
        config = {
          AllowedEncryptionPublicKeys = pubkeys;
          IfName = "yggdrasil";
          Listen = cfg.listen.endpoints;
          Peers = lib.flatten (map (c: c.listen.endpoints) (filter (c: c.listen.enable) yggConfigs));
          SessionFirewall = {
            Enable = true;
            AllowFromRemote = false;
            WhitelistEncryptionPublicKeys = pubkeys;
          };
          TunnelRouting =
            let
              subnets = v: (
                listToAttrs (flatten (map (c: map (net: nameValuePair net c.pubkey) c.tunnel."localV${toString v}") yggConfigs))
              ) // cfg.tunnel."remoteV${toString v}";
            in
            {
              Enable = true;
              IPv4LocalSubnets = cfg.tunnel.localV4 ++ cfg.extra.localV4;
              IPv6LocalSubnets = cfg.tunnel.localV6 ++ cfg.extra.localV6;
              IPv4RemoteSubnets = subnets 4;
              IPv6RemoteSubnets = subnets 6;
            };
        };
      };

      systemd.services.yggdrasil.postStart =
        let
          yggTun = config.services.yggdrasil.config.TunnelRouting;
          addNets = v: nets: concatMapStringsSep "\n" (net: "${pkgs.iproute}/bin/ip -${toString v} route add ${net} dev yggdrasil") (attrNames nets);
        in
        "sleep 1\n" + (concatMapStringsSep "\n" (v: addNets v yggTun."IPv${toString v}RemoteSubnets") [ 4 6 ]);

      system.build.yggdrasilTemplate =
        let
          json = builtins.toJSON {
            inherit (config.services.yggdrasil.config) Peers SessionFirewall TunnelRouting;
            EncryptionPublicKey = "";
            EncryptionPrivateKey = "";
            SigningPublicKey = "";
            SigningPrivateKey = "";
          };
        in
        pkgs.runCommandNoCC "yggdrasil-template.json" { }
          "echo '${json}' | ${config.services.yggdrasil.package}/bin/yggdrasil -useconf -normaliseconf > $out";
    }
  );
}
