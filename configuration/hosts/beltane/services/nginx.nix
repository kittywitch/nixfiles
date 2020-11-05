{ config, pkgs, ... }:

let common = {
    enableACME = true;
    forceSSL = true;
}; secrets = import ../secrets.nix; in {
    services.nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        commonHttpConfig = ''
        map $scheme $hsts_header {
            https   "max-age=31536000; includeSubdomains; preload";
        }
        add_header Strict-Transport-Security $hsts_header;
        #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;
        add_header 'Referrer-Policy' 'origin-when-cross-origin';
        #add_header X-Frame-Options DENY;
        #add_header X-Content-Type-Options nosniff;
        #add_header X-XSS-Protection "1; mode=block";
        #proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
        '';

        virtualHosts = {
            "beltane.dork.dev" = {
                root = "/var/www/beltane";
            } // common;
            "dork.dev" = {
                root = "/var/www/dork";
                /*locations = {
                    "/_matrix" = {
                        proxyPass = "http://[::1]:8008";
                    };
                    "= /.well-known/matrix/server".extraConfig = 
                        let server = { "m.server" = "dork.dev:443"; }; in ''
                            add_header Content-Type application/json;
                            return 200 '${builtins.toJSON server}';
                        '';
                    "= /.well-known/matrix/client".extraConfig =
                        let client = {
                            "m.homeserver" =  { "base_url" = "https://dork.dev"; };
                            "m.identity_server" =  { "base_url" = "https://vector.im"; };
                        }; in ''
                            add_header Content-Type application/json;
                            add_header Access-Control-Allow-Origin *;
                            return 200 '${builtins.toJSON client}';
                        '';
                };*/
            } // common;
            /*"pw.dork.dev" = {
                locations = {
                    "/".proxyPass = "http://127.0.0.1:4000";
                    "/notifications/hub".proxyPass = "http://127.0.0.1:3012";
                    "/notifications/hub/negotiate".proxyPass = "http://127.0.0.1:80";
                };
            } // common;
            "git.dork.dev" = {
                locations = {
                    "/".proxyPass = "http://127.0.0.1:3000";
                };
            } // common;*/
            "znc.dork.dev" = {
                locations = {
                    "/".proxyPass = "http://127.0.0.1:5000";
                };
            } // common;
            "irc.dork.dev" = {
                locations = {
                    "/" = {
                    root = pkgs.glowing-bear;
                    };
                    "^~ /weechat" = {
                        proxyPass = "http://127.0.0.1:9000";
                        proxyWebsockets = true;
                    };
                };
           } // common;
        };
    };

    security.acme = {
        email = secrets.acme.email;
        acceptTerms = true;
    };
}