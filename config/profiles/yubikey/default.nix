{ config, lib, pkgs, ... }: {
  config = lib.mkIf (lib.elem "yubikey" config.meta.deploy.profiles) {
    services.pcscd.enable = true;
    services.udev.packages = [ pkgs.yubikey-personalization ];

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "curses";
    };
  };
}
