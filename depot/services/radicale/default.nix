{ config, pkgs, lib, tf, ... }:

with lib;

{
  secrets.files.radicale_htpasswd = {
    text = ''
      kat@kittywit.ch:${tf.variables.mail-kat-hash.ref}
    '';
  };

  services.radicale = {
    enable = true;
    settings = {
      auth = {
        type = "htpasswd";
        htpasswd_filename = config.secrets.files.radicale_htpasswd.path;
        htpasswd_encryption = "bcrypt";
      };
    };
  };

  services.nginx.virtualHosts = {
    "cal.${config.network.dns.domain}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:5232/";
        extraConfig = ''
          proxy_set_header  X-Script-Name /;
          proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_pass_header Authorization;
        '';
      };
    };
  };

  deploy.tf.dns.records.services_radicale = {
    tld = config.network.dns.tld;
    domain = "cal";
    cname.target = "${config.networking.hostName}.${config.network.dns.tld}";
  };
}
