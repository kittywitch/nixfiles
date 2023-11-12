{lib, ...}: let
  inherit (lib.modules) mkForce;
in {
  networking = {
    networkmanager.dns = mkForce "none";
    nameservers = [
      "9.9.9.9"
    ];
  };
  services.resolved = {
    enable = true;
    fallbackDns = [
      "9.9.9.9"
    ];
    domains = ["~."];
    dnssec = "true";
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };
}
