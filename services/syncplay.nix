{ config, pkgs, ... }:

{
  users.users.syncplay = { isSystemUser = true; };

  services.syncplay = {
    enable = true;
    user = "syncplay";
    group = "kittywit-ch";
    certDir = "/var/lib/acme/sync.kittywit.ch/";
  };

  security.acme.certs."sync.kittywit.ch".postRun = ''
    cp key.pem privkey.pem
  '';
}
