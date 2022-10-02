{ config, lib, ... }: with lib;

{
  deploy.targets.home = let meta = config; in {
    tf = { config, ... }: {
      imports = optional (builtins.pathExists ../services/irlmail.nix) ../services/irlmail.nix;

  variables.tailscale-apikey = {
    value.shellCommand = "${meta.secrets.command} secrets/tailscale -f api_key";
    sensitive = true;
    export = true;
  };
    acme.account = {
      register = lib.mkForce true;
      emailAddress = "kat@inskip.me";
      accountKeyPem = config.resources.acme_private_key.refAttr "private_key_pem";
    };
    providers.tailscale = {
      inputs = {
        api_key = config.variables.tailscale-apikey.ref;
        tailnet = "inskip.me";
      };
    };
    resources = {
      acme_private_key = {
        provider = "tls";
        type = "private_key";
        inputs = {
          algorithm = "RSA";
          rsa_bits = 4096;
        };
      };
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
