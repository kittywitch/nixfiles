{ config, pkgs, ... }:

{
  services.murmur = {
    enable = true;

    hostName = "voice.kittywit.ch";

    extraConfig = ''
      sslCert=/var/lib/acme/voice.kittywit.ch/fullchain.pem
      sslKey=/var/lib/acme/voice.kittywit.ch/key.pem
    '';
  };

  services.nginx.virtualHosts."voice.kittywit.ch" = {
    enableACME = true;
    forceSSL = true;
  };

  users.groups."voice-cert".members = [ "nginx" "murmur" ];

  security.acme.certs = { "voice.kittywit.ch" = { group = "voice-cert"; }; };

  deploy.tf.dns.records.kittywitch_voice = {
    tld = "kittywit.ch.";
    domain = "voice";
    cname.target = "athame.kittywit.ch.";
  };

  deploy.tf.dns.records.kittywitch_voice_tcp = {
    tld = "kittywit.ch.";
    domain = "@";
    srv = {
      service = "mumble";
      proto = "tcp";
      priority = 0;
      weight = 5;
      port = 64738;
      target = "voice.kittywit.ch.";
    };
  };

  deploy.tf.dns.records.kittywitch_voice_udp = {
    tld = "kittywit.ch.";
    domain = "@";
    srv = {
      service = "mumble";
      proto = "udp";
      priority = 0;
      weight = 5;
      port = 64738;
      target = "voice.kittywit.ch.";
    };
  };
}
