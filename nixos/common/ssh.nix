{
  config,
  lib,
  std,
  ...
}: let
  inherit (lib.modules) mkDefault;
  inherit (std) list;
in {
  networking.firewall = {
    allowedTCPPorts = [(list.unsafeHead config.services.openssh.ports)];
  };

  services.openssh = {
    enable = true;
    settings = {
      KexAlgorithms = ["curve25519-sha256@libssh.org"];
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
}
