{ config, lib, pkgs, ... }:

{
  home.sessionVariables = {
    SSH_AUTH_SOCK =
      "\${SSH_AUTH_SOCK:-$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)}";
  };
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
