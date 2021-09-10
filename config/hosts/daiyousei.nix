{ config, tf, meta, kw, pkgs, lib, sources, ... }: with lib; {
  imports = with meta; [
    profiles.hardware.aarch64
    profiles.hardware.oracle.ubuntu
    profiles.network
    services.nginx
    services.keycloak
    services.roundcube
    services.openldap
    services.mail
    services.hedgedoc
    services.dnscrypt-proxy
  ];

  kw.oci = {
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

  services.nginx.virtualHosts =
    let
      splashy = pkgs.host-splash-site config.networking.hostName;
    in
    kw.virtualHostGen {
      networkFilter = [ "public" ];
      block.locations."/" = { root = splashy; };
    };

  system.stateVersion = "21.11";
}
