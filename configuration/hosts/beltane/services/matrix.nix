{ config, pkgs, ... }:

let secrets = ( import ../secrets.nix ); in {
    matrix-synapse = {
        enable = true;
        registration_shared_secret = secrets.matrix.secret;
        server_name = "dork.dev";
        listeners = [
        {
            port = 8008;
            bind_address = "::1";
            type = "http";
            tls = false;
            x_forwarded = true;
            resources = [
                {
                    names = [ "client" "federation" ];
                    compress = false;
                }
            ];
            }
        ];
    };  
}