{ config, lib, pkgs, ... }:

with lib;

{
  network.firewall = {
    public = {
      tcp.ports = singleton 62954;
      udp.ranges = [{
        from = 60000;
        to = 61000;
      }];
    };
    private = {
      tcp.ports = singleton 62954;
      udp.ranges = [{
        from = 60000;
        to = 61000;
      }];
    };
  };

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
