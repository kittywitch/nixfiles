{ config, lib, tf, pkgs, meta, ... }: with lib; let
in {
  options = with lib; {
    network = {
      routeDefault = mkOption {
        default = true;
        type = types.bool;
      };
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

  deploy.tf = {
  variables.tailscale-apikey = {
    value.shellCommand = "${meta.kw.secrets.command} secrets/tailscale -f api_key";
    sensitive = true;
    export = true;
  };
    providers.tailscale = {
      inputs = {
        api_key = tf.variables.tailscale-apikey.ref;
        tailnet = "inskip.me";
      };
    };
    variables.tailscale-authkey.export = true;
    resources.tailnet_key = {
      provider = "tailscale";
      type = "tailnet_key";
      inputs = {
        reusable = false;
        ephemeral = false;
        preauthorized = true;
      };
    };
  };

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedTCPPorts = [ 5200 ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  services.tailscale.enable = true;

  systemd.services.tailscale-autoconnect = mkIf (builtins.getEnv "TF_IN_AUTOMATION" != "" || tf.state.enable) {
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
      ${tailscale}/bin/tailscale up -authkey ${tf.resources.tailnet_key.getAttr "key"}
    '';
  };
};
}
