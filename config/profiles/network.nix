{ config, lib, tf, pkgs, meta, ... }: with lib;

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
        amaterasu =
          "ab9a4a78df124a8413c3a6576332d7739a44c036e14b7b0b4ea4558373ddda97";
        duck-powerduck =
          "9475274dcd43f0f3f397d56168efd436b0db58e58f4c068f75ab93ba3f51e405";
        duck-nagoya =
          "0000001a24b38f4341e356e7efc98dd31e259669242e0a82ba86971317b94954";
      };
    };

  kw.secrets.variables.tailscale-authkey = {
    path = "secrets/tailscale";
    field = "password";
  };

  deploy.tf.variables.tailscale-authkey.export = true;

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedTCPPorts = [ 5200 ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  services.tailscale.enable = true;

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey ${tf.variables.tailscale-authkey.get}
    '';
  };
};
}

#    networking.firewall.extraCommands = ''
#    ip6tables -A INPUT -p 89 -i wgmesh-+ -j ACCEPT
#    ${if config.networking.hostName != "marisa" then "ip route replace to 10.42.68.0/24 via ${meta.network.nodes.marisa.network.addresses.wireguard.nixos.ipv4.address}" else ""}
#    '';
#    networking.nftables.extraInput = ''
#      meta l4proto 89 iifname wgmesh-* accept
#    '';
#
#    network.firewall.private.interfaces = singleton "wgmesh-*";
#
#    networking.policyrouting = {
#      enable = true;
#      rules = [
#        { rule = "lookup main suppress_prefixlength 0"; prio = 7000; }
#        { rule = "lookup 89 suppress_prefixlength 0"; prio = 8000; }
#        { rule = "from all fwmark 51820 lookup main"; prio = 9000; }
#      ] ++ (lib.optional config.network.routeDefault { rule = "not from all fwmark 51820 lookup 89"; prio = 9000; });
#    };
#
#    network.wireguard = {
#      enable = true;
#      tf.enable = true;
#      fwmark = 51820;
#    };
#
#    network.bird =
#      let
#        mkKernel = version: ''
#          ipv${toString version} {
#            import all;
#            export filter {
#              if source = RTS_STATIC then reject;
#              accept;
#            };
#          };
#          kernel table 89;
#          scan time 15;
#        '';
#        mkIgp = version: {
#          version = 3;
#          extra = "ipv${toString version} { import all; export all; };";
#          areas."0".interfaces."wgmesh-*".cost = 100;
#        };
#      in
#      {
#        routerId = "${config.network.wireguard.prefixV4}.${toString config.network.wireguard.magicNumber}";
#        kernel4Config = mkKernel 4;
#        kernel6Config = mkKernel 6;
#        ospf = {
#          enable = true;
#          protocols.igp4 = mkIgp 4;
#          protocols.igp6 = mkIgp 6;
#        };
#      };
