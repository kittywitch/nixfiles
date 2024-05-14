_: {
  services.nginx = {
    virtualHosts = {
      "irc.kittywit.ch" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://[::1]:9000";
          proxyWebsockets = true;
        };
      };
    };
  };
}
