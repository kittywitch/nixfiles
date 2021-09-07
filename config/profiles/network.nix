{ config, lib, pkgs, ... }:

{
  options.network = with lib; {
    routeDefault = mkOption {
      default = true;
      type = types.bool;
    };
  };

  config = {
    networking.firewall.extraCommands = "ip6tables -A INPUT -p 89 -i wgmesh-+ -j ACCEPT";
    networking.nftables.extraInput = ''
      meta l4proto 89 iifname wgmesh-* accept
    '';

    networking.policyrouting = {
      enable = true;
      rules = [
        { rule = "lookup main suppress_prefixlength 0"; prio = 7000; }
        { rule = "lookup 89 suppress_prefixlength 0"; prio = 8000; }
        { rule = "from all fwmark 51820 lookup main"; prio = 9000; }
      ] ++ (lib.optional config.network.routeDefault { rule = "not from all fwmark 51820 lookup 89"; prio = 9000; });
    };

    network.wireguard = {
      enable = true;
      tf.enable = true;
      fwmark = 51820;
    };

    network.bird =
      let
        mkKernel = version: ''
          ipv${toString version} {
            import all;
            export filter {
              if source = RTS_STATIC then reject;
              accept;
            };
          };
          kernel table 89;
          scan time 15;
        '';
        mkIgp = version: {
          version = 3;
          extra = "ipv${toString version} { import all; export all; };";
          areas."0".interfaces."wgmesh-*".cost = 100;
        };
      in
      {
        routerId = "${config.network.wireguard.prefixV4}.${toString config.network.wireguard.magicNumber}";
        kernel4Config = mkKernel 4;
        kernel6Config = mkKernel 6;
        ospf = {
          enable = true;
          protocols.igp4 = mkIgp 4;
          protocols.igp6 = mkIgp 6;
        };
      };
  };
}
