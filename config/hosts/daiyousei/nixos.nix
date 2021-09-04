{ config, tf, meta, kw, pkgs, lib, sources, ... }: with lib; {
  imports = with meta; [
    profiles.hardware.aarch64
    profiles.hardware.oracle.ubuntu
    services.nginx
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
}
