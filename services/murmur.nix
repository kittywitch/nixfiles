{ config, pkgs, ... }:

{
  security.acme = { certs."kittywit.ch" = { group = "kittywit-ch"; }; };

  users.groups."kittywit-ch".members = [ "murmur" "nginx" "syncplay" ];

  services.murmur = {
    enable = true;

    hostName = "mumble.kittywit.ch";

    extraConfig = ''
      sslCert=/var/lib/acme/kittywit.ch/fullchain.pem
      sslKey=/var/lib/acme/kittywit.ch/key.pem
    '';
  };
}
