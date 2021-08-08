{ config, lib, pkgs, ... }:

with lib;

{
  kw.fw = {
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

  services.openssh = {
    enable = true;
    ports = lib.mkDefault [ 62954 ];
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
    permitRootLogin = lib.mkDefault "prohibit-password";
    kexAlgorithms = [ "curve25519-sha256@libssh.org" ];
    extraConfig = ''
      StreamLocalBindUnlink yes
      LogLevel VERBOSE 
    '';
  };
  programs.mosh.enable = true;
}
