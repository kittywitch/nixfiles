{ config, pkgs, ... }:

{
    services.postgresql.enable = true;
    services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
        CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
        CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';
    services.postgresql.ensureDatabases = [ "nextcloud" ];
    services.postgresql.ensureUsers = [
        { 
            name = "nextcloud";
            ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
        }
    ];
}