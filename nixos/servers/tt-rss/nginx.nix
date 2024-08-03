_: {
  services.nginx = {
    virtualHosts."rss.kittywit.ch" = {
      enableACME = true;
      forceSSL = true;
    };
  };
}
