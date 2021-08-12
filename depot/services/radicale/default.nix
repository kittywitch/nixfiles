{ config, pkgs, lib, ... }:

with lib;

let
  mailAccounts = config.mailserver.loginAccounts;
  htpasswd = pkgs.writeText "radicale.users" (concatStrings
    (flip mapAttrsToList mailAccounts
      (mail: user: mail + ":" + user.hashedPassword + "\n")));
in
{
  services.radicale = {
    enable = true;
    settings = {
      auth = {
        type = "htpasswd";
        htpasswd_filename = toString htpasswd;
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
