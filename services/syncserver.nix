{ config, pkgs, ... }:

{
  services.firefox.syncserver = {
    enable = true;
    listen.port = 5001;
    allowNewUsers = false;
    publicUrl = "https://sync.kittywit.ch";
  };

  services.nginx.virtualHosts."sync.kittywit.ch" = {
    enableACME = true;
    forceSSL = true;
    locations = { "/".proxyPass = "http://127.0.0.1:5001"; };
  };  

  deploy.tf.dns.records.kittywitch_sync = {
    tld = "kittywit.ch.";
    domain = "sync";
    cname.target = "athame.kittywit.ch.";
  };
}
