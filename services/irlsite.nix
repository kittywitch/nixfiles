{ config, lib, pkgs, ... }: {
  services.nginx.virtualHosts."inskip.me" = {
    root = pkgs.irlsite;
    enableACME = true;
    forceSSL = true;
  };
}
