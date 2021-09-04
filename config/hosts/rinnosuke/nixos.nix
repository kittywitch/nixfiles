{ config, tf, meta, kw, pkgs, lib, sources, ... }: with lib; {
  imports = with meta; [
    profiles.hardware.oracle.ubuntu
    services.knot
    services.nginx
  ];

  kw.oci = {
    base = "Canonical Ubuntu";
    specs = {
      shape = "VM.Standard.E2.1.Micro";
      cores = 1;
      ram = 1;
      space = 50;
    };
    ad = 2;
    network = {
      publicV6 = 7;
      privateV4 = 3;
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
