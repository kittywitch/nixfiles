{lib, ...}: let
  inherit (lib.modules) mkForce;
in {
  networking = {
    networkmanager.dns = mkForce "none";
    nameservers = [
      #"172.20.0.1"
      "1.1.1.1#cloudflare-dns.com"
      "1.0.0.1#cloudflare-dns.com"
      "8.8.8.8#dns.google"
    ];
  };
  services.resolved = {
    enable = false;
    domains = ["~."];
    dnssec = "false";
  };
}
