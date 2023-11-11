_: {
  networking = {
    nameservers = [
      "194.242.2.2" # For now, Mullvad DNS.
    ];
  };
  services.resolved = {
    enable = true;
    fallbackDns = [
      "1.1.1.1"
    ];
    dnssec = "false";
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };
}
