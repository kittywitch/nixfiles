{ config, lib, pkgs, ... }:

with lib;

{
  network.firewall = {
    public = {
      tcp.ports = singleton 64738;
      udp.ports = singleton 64738;
    };
  };

  services.murmur = {
    enable = true;
    hostName = "voice.${config.network.dns.domain}";
    bandwidth = 130000;
    welcometext = "mew!";
    extraConfig = ''
      sslCert=/var/lib/acme/voice.${config.network.dns.domain}/fullchain.pem
      sslKey=/var/lib/acme/voice.${config.network.dns.domain}/key.pem
    '';
  };

  services.nginx.virtualHosts."voice.${config.network.dns.domain}" = {
    enableACME = true;
    forceSSL = true;
  };

  users.groups."voice-cert".members = [ "nginx" "murmur" ];

  security.acme.certs = { "voice.${config.network.dns.domain}" = { group = "voice-cert"; }; };

  deploy.tf.dns.records.services_murmur = {
    tld = config.network.dns.tld;
    domain = "voice";
    cname.target = "${config.networking.hostName}.${config.network.dns.tld}";
  };

  deploy.tf.dns.records.services_murmur_tcp_srv = {
    tld = config.network.dns.tld;
    domain = "@";
    srv = {
      service = "mumble";
      proto = "tcp";
      priority = 0;
      weight = 5;
      port = 64738;
      target = "voice.${config.network.dns.tld}";
    };
  };

  deploy.tf.dns.records.services_murmur_udp_srv = {
    tld = config.network.dns.tld;
    domain = "@";
    srv = {
      service = "mumble";
      proto = "udp";
      priority = 0;
      weight = 5;
      port = 64738;
      target = "voice.${config.network.dns.tld}";
    };
  };
}
