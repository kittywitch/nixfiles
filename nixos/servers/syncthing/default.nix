{
  self,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkOption;
  inherit (lib.types) str nullOr;
  inherit (lib.attrsets) filterAttrs mapAttrs;
  enabledHosts = filterAttrs (_n: v: v.config.services.syncthing.enable) self.nixosConfigurations;
  enabledSyncthings = mapAttrs (_n: _v: config.services.syncthing) enabledHosts;
  enabledDevices = mapAttrs' (_n: v: (nameValuePair v.device_name {id = v.device_id;})) enabledSyncthings;
in {
  options = {
    services.syncthing = {
      device_id = mkOption {
        type = nullOr str;
        default = null;
      };
      device_name = mkOption {
        type = nullOr str;
        default = config.networking.hostName;
      };
    };
  };
  config = {
    sops.secrets = let
      commonOptions = {
        sopsFile = ./. + "${config.networking.hostName}.yaml";
      };
    in {
      syncthing-key = commonOptions;
      syncthing-cert = commonOptions;
    };
    services.syncthing = {
      settings = {
        devices = enabledDevices; # :3
      };

      extraFlags = ["--no-default-folder"];

      # To those of us in future ages, including me going back over this,
      # this is obtained via getting the contents of
      # `syncthing generate --no-default-folder --config meep/`
      # I hope this helps! That's what the content of those secrets are from.

      key = sops.secrets.syncthing-key.path;
      cert = sops.secrets.syncthing-cert.path;
    };
  };
}
