{ config, lib, pkgs, ... }:

with lib;

{
  kw.fw.public.tcp.ports = singleton 64738;
  kw.fw.public.udp.ports = singleton 64738;

  services.murmur = {
    enable = true;
    hostName = "voice.${config.kw.dns.domain}";
    bandwidth = 130000;
    welcometext = "mew!";
    extraConfig = ''
      sslCert=/var/lib/acme/voice.${config.kw.dns.domain}/fullchain.pem
      sslKey=/var/lib/acme/voice.${config.kw.dns.domain}/key.pem
    '';
  };

  services.nginx.virtualHosts."voice.${config.kw.dns.domain}" = {
    enableACME = true;
    forceSSL = true;
  };

  users.groups."voice-cert".members = [ "nginx" "murmur" ];

  security.acme.certs = { "voice.${config.kw.dns.domain}" = { group = "voice-cert"; }; };

  deploy.tf.dns.records.services_murmur = {
    tld = config.kw.dns.tld;
    domain = "voice";
    cname.target = "${config.networking.hostName}.${config.kw.dns.tld}";
  };

  deploy.tf.dns.records.services_murmur_tcp_srv = {
    tld = config.kw.dns.tld;
    domain = "@";
    srv = {
      service = "mumble";
      proto = "tcp";
      priority = 0;
      weight = 5;
      port = 64738;
      target = "voice.${config.kw.dns.tld}";
    };
  };

  deploy.tf.dns.records.services_murmur_udp_srv = {
    tld = config.kw.dns.tld;
    domain = "@";
    srv = {
      service = "mumble";
      proto = "udp";
      priority = 0;
      weight = 5;
      port = 64738;
      target = "voice.${config.kw.dns.tld}";
    };
  };
}
