{config, ...}: {
  services.nginx = {
    virtualHosts = {
      "public.gensokyo.zone" = {
        enableACME = true;
        forceSSL = true;
        locations."/kat-is-a-cute-girl" = {
          root = "/var/www/public";
          extraConfig = ''
            autoindex on;
          '';
        };
      };
    };
  };
}
