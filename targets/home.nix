{ config, lib, ... }: with lib;

{
  deploy.targets.home = let meta = config; in {
    tf = { config, ... }: {
      imports = optional (builtins.pathExists ../services/irlmail.nix) ../services/irlmail.nix;

  variables.tailscale-apikey = {
    value.shellCommand = "${meta.kw.secrets.command} secrets/tailscale -f api_key";
    sensitive = true;
    export = true;
  };

    providers.tailscale = {
      inputs = {
        api_key = config.variables.tailscale-apikey.ref;
        tailnet = "inskip.me";
      };
    };
    resources = {
      tailnet_devices = {
        type = "devices";
        provider = "tailscale";
        dataSource = true;
      };
      tailnet_nr = {
        provider = "null";
        type = "resource";
        inputs.triggers = {
          mew = config.resources.tailnet_devices.refAttr "id";
        };
      };
    };
  };
};
}
