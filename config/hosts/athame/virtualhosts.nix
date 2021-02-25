{ config, pkgs, ... }:

let
  common = {
    enableACME = true;
    forceSSL = true;
  };
  secrets = (import ../../../secrets.nix);
in {
  services.nginx.virtualHosts = {
    "kittywit.ch" = {
      root = "/var/www/kittywitch";
      locations = {
        "/_matrix" = { proxyPass = "http://[::1]:8008"; };
        "= /.well-known/matrix/server".extraConfig =
          let server = { "m.server" = "kittywit.ch:443"; };
          in ''
            add_header Content-Type application/json;
            return 200 '${builtins.toJSON server}';
          '';
        "= /.well-known/matrix/client".extraConfig = let
          client = {
            "m.homeserver" = { "base_url" = "https://kittywit.ch"; };
            "m.identity_server" = { "base_url" = "https://vector.im"; };
          };
        in ''
          add_header Content-Type application/json;
          add_header Access-Control-Allow-Origin *;
          return 200 '${builtins.toJSON client}';
        '';
      };
    } // common;
    "athame.kittywit.ch" = {
      root = "/var/www/athame";
    } // common;
    "vault.kittywit.ch" = {
      locations = {
        "/".proxyPass = "http://127.0.0.1:4000";
        "/notifications/hub".proxyPass = "http://127.0.0.1:3012";
        "/notifications/hub/negotiate".proxyPass = "http://127.0.0.1:80";
      };
    } // common;
    "git.kittywit.ch" = {
      locations = { "/".proxyPass = "http://127.0.0.1:3000"; };
    } // common;
    "znc.kittywit.ch" = {
      locations = { "/".proxyPass = "http://127.0.0.1:5000"; };
    } // common;
    "irc.kittywit.ch" = {
      locations = {
        "/" = { root = pkgs.glowing-bear; };
        "^~ /weechat" = {
          proxyPass = "http://127.0.0.1:9000";
          proxyWebsockets = true;
        };
      };
    } // common;
  } // secrets.virtualHosts.athame;
}
