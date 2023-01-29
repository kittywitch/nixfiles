{ config, lib, std, ... }: let
  inherit (lib.modules) mkDefault;
  inherit (std) list;
in {
  networking.firewall = {
    allowedTCPPorts = [ (list.unsafeHead config.services.openssh.ports) ];
    allowedUDPPortRanges = [ { from = 60000; to = 61000; } ];
  };

  services.openssh = {
    enable = true;
    kexAlgorithms = [ "curve25519-sha256@libssh.org" ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = mkDefault "prohibit-password";
    };
    extraConfig = ''
      PubkeyAcceptedAlgorithms +ssh-rsa
      StreamLocalBindUnlink yes
      LogLevel VERBOSE
    '';
  };

  programs.mosh.enable = true;
}
