{ config, pkgs, ... }:

let secrets = (import ../../../../secrets.nix);
in {
  services.bitwarden_rs = {
    enable = true;
    config = {
      rocketPort = 4000;
      websocketEnabled = true;
      signupsAllowed = false;
      adminToken = secrets.hosts.athame.bitwarden_secret;
      domain = "https://vault.kittywit.ch";
    };
  };
}
