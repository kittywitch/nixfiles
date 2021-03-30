{ config, pkgs, ... }:

{
  security.acme = { certs."kittywit.ch" = { group = "kittywit-ch"; }; };

  users.groups."kittywit-ch".members = [ "murmur" "nginx" "syncplay" ];

  services.murmur = {
    enable = true;

    hostName = "voice.kittywit.ch";

    extraConfig = ''
      sslCert=/var/lib/acme/kittywit.ch/fullchain.pem
      sslKey=/var/lib/acme/kittywit.ch/key.pem
    '';
  };

  deploy.tf.dns.records.kittywitch_voice = {
    tld = "kittywit.ch.";
    domain = "voice";
    cname.target = "athame.kittywit.ch.";
  };
}
