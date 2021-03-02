{ config, pkgs, ... }:

let secrets = (import ../../../secrets.nix);
in {
  security.acme = { certs."kittywit.ch" = { group = "kittywit-ch"; }; };

  users.groups."kittywit-ch".members = [ "murmur" "nginx" ];

  services.murmur = {
    enable = true;

    hostName = "kittywit.ch";

    extraConfig = ''
      sslCert=/var/lib/acme/kittywit.ch/fullchain.pem
      sslKey=/var/lib/acme/kittywit.ch/key.pem
    '';
  };
}
