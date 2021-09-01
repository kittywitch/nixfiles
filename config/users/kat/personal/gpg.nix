{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ pinentry.gtk2 ];
  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableSshSupport = false;
    pinentryFlavor = "gtk2";
    extraConfig = lib.mkMerge [
      "auto-expand-secmem 0x30000" # otherwise "gpg: public key decryption failed: Cannot allocate memory"
      "pinentry-timeout 30"
      "allow-loopback-pinentry"
      "enable-ssh-support"
      "no-allow-external-cache"
    ];
  };
}
