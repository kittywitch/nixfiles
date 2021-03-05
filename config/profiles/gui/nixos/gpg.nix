{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.deploy.profile.gui {
    services.pcscd.enable = true;
    services.udev.packages = [ pkgs.yubikey-personalization ];
  };
}
