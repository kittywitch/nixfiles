{ config, lib, pkgs, ... }:

{
  katnet.public.udp.ranges = [ { from=60000; to=61000; }];
  katnet.private.udp.ranges = [ { from=60000; to=61000; }];

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
