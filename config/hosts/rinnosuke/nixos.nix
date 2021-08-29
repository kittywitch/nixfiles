{ config, tf, meta, kw, pkgs, lib, sources, ... }: with lib; let
  oci-root = meta.deploy.targets.oci-root.tf;
in
{
  imports = (with (import (sources.tf-nix + "/modules")); [
    nixos.ubuntu-linux
    nixos.oracle
    ./oracle.nix
  ]) ++ (with meta; [ services.nginx ]);

  services.nginx.virtualHosts =
    let
      splashy = pkgs.host-splash-site config.networking.hostName;
    in
    kw.virtualHostGen {
      networkFilter = [ "public" ];
      block.locations."/" = { root = splashy; };
    };

  networking = {
    hostName = "rinnosuke";
  };

  network = {
    addresses.public.enable = true;
    firewall.public.interfaces = singleton "ens3";
    tf = {
      enable = true;
      ipv4_attr = "public_ip";
    };
  };
}
