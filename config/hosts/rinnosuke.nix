{ config, tf, meta, kw, pkgs, lib, sources, ... }: with lib; {
  imports = with meta; [
    profiles.hardware.oracle.ubuntu
    profiles.network
    services.knot
    services.nginx
  ];

  kw.oci = {
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

  network = {
    yggdrasil = {
      enable = true;
      pubkey = "d3db7b089f3cb2d33e18c77b8f9a5a08185798143822b219dbc938aa37d29310";
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
