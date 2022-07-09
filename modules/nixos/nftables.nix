{ pkgs, lib, config, modulesPath, ... }:

let
  fwcfg = config.networking.firewall;
  cfg = config.networking.nftables;

  doDocker = config.virtualisation.docker.enable && cfg.generateDockerRules;

  mkPorts = cond: ports: ranges: action: let
    portStrings = (map (range: "${toString range.from}-${toString range.to}") ranges)
               ++ (map toString ports);
  in lib.optionalString (portStrings != []) ''
    ${cond} dport { ${lib.concatStringsSep ", " portStrings} } ${action}
  '';

  ruleset = ''
    table inet filter {
      chain input {
        type filter hook input priority filter
        policy ${cfg.inputPolicy}

        icmpv6 type { echo-request, echo-reply, mld-listener-query, mld-listener-report, mld-listener-done, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert, packet-too-big } accept
        icmp type echo-request accept

        ct state invalid drop
        ct state established,related accept

        iifname { ${
          lib.concatStringsSep "," (["lo"] ++ fwcfg.trustedInterfaces)
        } } accept

        ${mkPorts "tcp" fwcfg.allowedTCPPorts fwcfg.allowedTCPPortRanges "accept"}
        ${mkPorts "udp" fwcfg.allowedUDPPorts fwcfg.allowedUDPPortRanges "accept"}

        ${
          lib.concatStringsSep "\n" (lib.mapAttrsToList (name: ifcfg:
              mkPorts "iifname ${name} tcp" ifcfg.allowedTCPPorts ifcfg.allowedTCPPortRanges "accept"
            + mkPorts "iifname ${name} udp" ifcfg.allowedUDPPorts ifcfg.allowedUDPPortRanges "accept"
          ) fwcfg.interfaces)
        }

        # DHCPv6
        ip6 daddr fe80::/64 udp dport 546 accept

        ${cfg.extraInput}

        counter
      }
      chain output {
        type filter hook output priority filter
        policy ${cfg.outputPolicy}

        ${cfg.extraOutput}

        counter
      }
      chain forward {
        type filter hook forward priority filter
        policy ${cfg.forwardPolicy}

        ${lib.optionalString doDocker ''
          oifname docker0 ct state invalid drop
          oifname docker0 ct state established,related accept
          iifname docker0 accept
        ''}

        ${cfg.extraForward}

        counter
      }
    }
    ${lib.optionalString doDocker ''
      table ip nat {
        chain docker-postrouting {
          type nat hook postrouting priority 10
          iifname docker0 masquerade
        }
      }
    ''}
    ${cfg.extraConfig}
  '';

in {
  options = with lib; {
    networking.nftables = {
      extraConfig = mkOption {
        type = types.lines;
        default = "";
      };
      extraInput = mkOption {
        type = types.lines;
        default = "";
      };
      extraOutput = mkOption {
        type = types.lines;
        default = "";
      };
      extraForward = mkOption {
        type = types.lines;
        default = "";
      };
      inputPolicy = mkOption {
        type = types.str;
        default = "drop";
      };
      outputPolicy = mkOption {
        type = types.str;
        default = "accept";
      };
      forwardPolicy = mkOption {
        type = types.str;
        default = "accept";
      };
      generateDockerRules = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.enable = false;
    networking.nftables = {
      inherit ruleset;
    };

    virtualisation.docker = lib.mkIf doDocker {
      extraOptions = "--iptables=false";
    };
  };
}
