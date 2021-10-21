{ config, tf, meta, kw, pkgs, lib, sources, ... }: with lib; {
  imports = with meta; [
    profiles.hardware.aarch64
    profiles.hardware.oracle.ubuntu
    profiles.network
    services.nginx
    services.filehost
    services.keycloak
    services.vikunja
    services.tt-rss
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

  network.yggdrasil = {
    enable = true;
    pubkey = "edb7de263e6924b8c9446123979782420e5196317bffc75e9a6ca546551252da";
    address = "206:d807:a98:309f:3bc0:de7a:411d:9d95";
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
