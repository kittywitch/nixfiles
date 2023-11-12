{lib, ...}: let
  inherit (lib.modules) mkForce;
in {
  networking = {
    networkmanager.dns = mkForce "none";
    nameservers = [
      "194.242.2.2#dns.mullvad.net"
    ];
  };
  services.resolved = {
    enable = true;
    domains = ["~."];
    dnssec = "true";
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };
}
