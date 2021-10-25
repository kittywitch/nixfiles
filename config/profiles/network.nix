{ config, lib, pkgs, sources, meta, ... }: with lib;

{
  options.network = with lib; {
    routeDefault = mkOption {
      default = true;
      type = types.bool;
    };
  };

  config = {
    network.yggdrasil.extern = let
    in {
      pubkeys = {
        satorin =
          "cbadeaa973b051cf66e23dcb014ab5be59e55a1c98ef541345520868e3bcf9f7";
        shanghai =
          "5aba9ba2ac7a54ffef19dea9e39881bd977f76032db81a2c82c4674ed475c95b";
        grimoire =
          "2a1567a2848540070328c9e938c58d40f2b1a3f08982c15c7edc5dcabfde3330";
        boline =
          "89684441745467da0d1bf7f47dc74ec3ca65e05c72f752298ef3c22a22024d43";
        okami =
          "f8fd12c6ed924048e93a7bd7dd63c2464813c9edddfef7415c4574518ecd4757";
      };
    };

    networking.firewall.extraCommands = ''
    ip6tables -A INPUT -p 89 -i wgmesh-+ -j ACCEPT
    ${if config.networking.hostName != "marisa" then "ip route replace to 10.42.68.0/24 via ${meta.network.nodes.marisa.network.addresses.wireguard.nixos.ipv4.address}" else ""}
    '';
    networking.nftables.extraInput = ''
      meta l4proto 89 iifname wgmesh-* accept
    '';

    network.firewall.private.interfaces = singleton "wgmesh-*";

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
