{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkDefault;
in {
  gensokyo-zone = {
    access = {
      tail.enable = mkDefault true;
      local.enable = mkDefault (config.networking.hostName == "goliath");
    };
    nix = {
      #  enable = true;
      #cache.infrastructure.enable = true;
      # builder.enable = true;
    };
    kyuuto = {
      enable = mkDefault true;
      shared.enable = mkDefault true;
      #domain = mkIf config.gensokyo-zone.access.local.enable "local.${domain}";
    };
    /*
      krb5 = {
      enable = mkDefault true;
      sssd = {
        enable = mkDefault true;
        # TODO: sssd ldap backend config is currently broken for unknown reasons
        # EDIT: wait ifp was disabled maybe it's actually just fine and I'm dumb?
        backend = "ipa";
      };
      nfs.enable = mkDefault true;
      #nfs.debug.enable = true;
      ipa.enable = mkDefault true;
    };
    */
    dns = {
      enable = mkDefault false;
    };
    monitoring = {
      enable = mkIf config.gensokyo-zone.access.local.enable (mkDefault true);
    };
  };
}
