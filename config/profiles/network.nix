{ config, lib, pkgs, sources, ... }: with lib;

{
  options.network = with lib; {
    routeDefault = mkOption {
      default = true;
      type = types.bool;
    };
  };

  config = {
    network.yggdrasil.extern = let
      hexchen = (import sources.hexchen) { };
      hexYgg = filterAttrs (_: c: c.enable)
        (mapAttrs (_: host: host.config.network.yggdrasil) hexchen.hosts);
    in {
      endpoints = flatten (map (c: c.listen.endpoints) (filter
        (c:
          c.listen.enable && (c.pubkey
          != "0000000000000000000000000000000000000000000000000000000000000000"))
          (attrValues hexYgg)));
      pubkeys = {
        satorin =
          "53d99a74a648ff7bd5bc9ba68ef4f472fb4fb8b2e26dfecea33c781f0d5c9525";
        shanghai =
          "0cc3c26366cbfddfb1534b25c5655733d8f429edc941bcce674c46566fc87027";
        grimoire =
          "2a1567a2848540070328c9e938c58d40f2b1a3f08982c15c7edc5dcabfde3330";
        boline =
          "89684441745467da0d1bf7f47dc74ec3ca65e05c72f752298ef3c22a22024d43";
      } // (mapAttrs (_: c: c.pubkey) hexYgg);
    };

    networking.firewall.extraCommands = "ip6tables -A INPUT -p 89 -i wgmesh-+ -j ACCEPT";
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