{ config, lib, pkgs, ... }:

with lib;

{
  networks = genAttrs [ "chitei" "gensokyo" ] (_: {
    # Mosh
    tcp = [62954];
    udp = [ [60000 61000] ];
  });

/*
  security.pam.services.sshd.text = mkDefault (mkAfter ''
    session required pam_exec.so ${katnotify}/bin/notify
  '');
*/

  services.openssh = {
    enable = true;
    ports = lib.mkDefault [ 62954 ];
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    permitRootLogin = lib.mkDefault "prohibit-password";
    kexAlgorithms = [ "curve25519-sha256@libssh.org" ];
    extraConfig = ''
      PubkeyAcceptedAlgorithms +ssh-rsa
      StreamLocalBindUnlink yes
      LogLevel VERBOSE
    '';
  };

  programs.mosh.enable = true;
}
