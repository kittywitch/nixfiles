{lib, ...}: let
  inherit (lib.modules) mkDefault mkMerge;
in {
  services.gpg-agent = {
    enable = mkDefault true;
    enableExtraSocket = true;
    enableSshSupport = true;
    sshKeys = [
      "59921D2F4E6DF7EEC3CB2934BD3D53666007B1AB" # kat@inskip.me
    ];
    extraConfig = mkMerge [
      "auto-expand-secmem 0x30000" # otherwise "gpg: public key decryption failed: Cannot allocate memory"
      "pinentry-timeout 30"
      "allow-loopback-pinentry"
      "enable-ssh-support"
      "no-allow-external-cache"
    ];
  };
}
