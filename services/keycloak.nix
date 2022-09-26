{ config, pkgs, lib, tf, ... }: with lib; let
  id = tf.acme.certs."auth.kittywit.ch".out.resource.getAttr "id";
in {
  services.keycloak = {
    enable = builtins.getEnv "CI_PLATFORM" == "impure";
    package = (pkgs.keycloak.override {
      jre = pkgs.openjdk11;
    });
    database.passwordFile = config.secrets.files.keycloak-postgres-file.path;
    settings = {
      http-enabled = true;
      http-host = "127.0.0.1";
      http-port = 8089;
      https-port = 8445;
      proxy = "edge";
      hostname = "auth.kittywit.ch";
      hostname-strict = false;
      http-relative-path = "/auth";
      hostname-strict-backchannel = true;
      https-key-store-file = "/run/keycloak/${id}.jks";
      https-key-store-password = id;
      };
    };

  domains.kittywitch-keycloak = {
    network = "internet";
    type = "cname";
    domain = "auth";
  };

  users.groups.domain-auth = {
    gid = 10600;
    members = [ "keycloak" "openldap" ];
  };

  systemd.services.keycloak.script  = lib.mkBefore ''
    mkdir -p /run/keycloak
    if [[ ! -e /run/keycloak/${id}.jks ]]; then
      ${pkgs.adoptopenjdk-jre-bin}/bin/keytool -import -alias auth.kittywit.ch -noprompt -keystore /run/keycloak/${id}.jks -keypass ${id} -storepass ${id} -file ${config.domains.kittywitch-keycloak.cert_path}
    fi
  '';

  users.groups.keycloak = { };

  users.users.keycloak = {
    isSystemUser = true;
    group = "keycloak";
  };

  kw.secrets.variables.keycloak-postgres = {
    path = "services/keycloak";
    field = "postgres";
  };

  secrets.files.keycloak-postgres-file = {
    text = "${tf.variables.keycloak-postgres.ref}";
    owner = "postgres";
    group = "keycloak";
  };

  services.nginx.virtualHosts."auth.kittywit.ch" = {
    forceSSL = true;
    locations = {
      "/".extraConfig = ''
        return 301 /auth;
      '';
      "/auth".proxyPass = "http://127.0.0.1:8089/auth";
    };
  };
}
