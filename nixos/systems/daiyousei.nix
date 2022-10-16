{ config, inputs, tf, meta, nixfiles, pkgs, lib, ... }: with lib; {
  imports = with meta; [
    hardware.aarch64-linux
    hardware.oracle.ubuntu
    home.weechat
    home.services.weechat
    services.nginx
    services.murmur
    services.murmur-ldap
    services.prosody
    services.synapse
    services.syncplay
    services.filehost
    services.keycloak
    services.openldap
    services.mail
    services.hedgedoc
    services.website
    services.dnscrypt-proxy
    services.vaultwarden
    services.weechat
    services.znc
    services.cockroachdb
  ];

  nixfiles.oci = {
    specs = {
      shape = "VM.Standard.A1.Flex";
      cores = 4;
      ram = 24;
      space = 100;
    };
    ad = 1;
    network = {
      publicV6 = 6;
      privateV4 = 5;
    };
  };

  networks.internet = {
    extra_domains = [
      "kittywit.ch"
    ];
  };

  domains = {
    kittywitch-root = {
      network = "internet";
      type = "both";
      domain = "@";
      zone = "kittywit.ch.";
      create_cert = false;
    };
  };

  system.stateVersion = "21.11";
}
