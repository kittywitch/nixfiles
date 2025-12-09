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

  programs.mosh.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      KexAlgorithms = [
        "mlkem768x25519-sha256"
        "sntrup761x25519-sha512"
        "curve25519-sha256@libssh.org"
      ];
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
