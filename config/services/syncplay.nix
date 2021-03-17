{ config, pkgs, ... }:

{
  users.users.syncplay = { isSystemUser = true; };

  services.syncplay = {
    enable = true;
    user = "syncplay";
    group = "kittywit-ch";
    certDir = "/var/lib/acme/kittywit.ch/";
  };
}
