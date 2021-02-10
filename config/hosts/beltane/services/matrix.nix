{ config, pkgs, ... }:

let secrets = (import ../secrets.nix);
in {
  services.matrix-synapse = {
    enable = true;
    registration_shared_secret = secrets.matrix.secret;
    server_name = "kittywit.ch";
    listeners = [{
      port = 8008;
      bind_address = "::1";
      type = "http";
      tls = false;
      x_forwarded = true;
      resources = [{
        names = [ "client" "federation" ];
        compress = false;
      }];
    }];
  };
/*  services.mautrix-telegram = {
    enable = true;
    settings = {
      homeserver = {
        address = "http://localhost:8008";
        domain = "kittywit.ch";
      };
      bridge.permissions = {
        "@kat:kittywit.ch" = "admin";
        "kittywit.ch" = "full";
      };
    };
    environmentFile = "";
  };*/
}
