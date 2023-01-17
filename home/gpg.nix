{lib, ...}: let
  inherit (lib.modules) mkMerge;
in {
  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableSshSupport = false;
    extraConfig = mkMerge [
      "auto-expand-secmem 0x30000" # otherwise "gpg: public key decryption failed: Cannot allocate memory"
      "pinentry-timeout 30"
      "allow-loopback-pinentry"
      "enable-ssh-support"
      "no-allow-external-cache"
    ];
  };
}
