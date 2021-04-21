{ config, lib, pkgs, ... }: {
  networking = {
    #      networkmanager.enable = true;
    resolvconf.useLocalResolver = true;
    networkmanager.dns = "none";
  };

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v2/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key =
          "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v2/public-resolvers.md
      server_names = [
        "acsacsar-ams-ipv4"
        "acsacsar-ams-ipv6"
        "dnscrypt.eu-dk"
        "dnscrypt.eu-dk-ipv6"
        "dnscrypt.eu-nl"
        "dnscrypt.eu-nl-ipv6"
        "meganerd"
        "meganerd-ipv6"
      ];
    };
  };
}
