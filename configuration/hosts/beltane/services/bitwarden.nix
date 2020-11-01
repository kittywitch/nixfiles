{ config, pkgs, ... }:

let secrets = ( import ../secrets.nix ); in {
    bitwarden_rs = {
        enable = true;
        config = {
            rocketPort = 4000;
            websocketEnabled = true;
            signupsAllowed = false;
            adminToken = secrets.bitwarden.token;
            domain = "https://pw.dork.dev";
        };
    };
}