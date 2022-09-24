{ config, pkgs, lib, tf, ... }: with lib; let
  keystore-pass = "zZX3eS";
in {
  services.keycloak = {
    enable = builtins.getEnv "CI_PLATFORM" == "impure";
    package = (pkgs.keycloak.override {
      jre = pkgs.openjdk11;
    });
    initialAdminPassword = "mewpymewlymewlies";
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
      https-key-store-file = "/var/lib/acme/domain-auth/trust-store.jks";
      https-key-store-password = keystore-pass;
      };
    };


  users.groups.domain-auth = {
    gid = 10600;
    members = [ "keycloak" ];
  };

  security.acme.certs."auth.kittywit.ch" = {
    group = "domain-auth";
    postRun = ''
      ${pkgs.adoptopenjdk-jre-bin}/bin/keytool -delete -alias auth.kittywit.ch -keypass ${keystore-pass} -storepass ${keystore-pass} -keystore ./trust-store.jks
      ${pkgs.adoptopenjdk-jre-bin}/bin/keytool -import -alias auth.kittywit.ch -noprompt -keystore trust-store.jks -keypass ${keystore-pass} -storepass ${keystore-pass} -file cert.pem
      chown acme:domain-auth ./trust-store.jks
    '';
  };

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
    useACMEHost = "domain-auth";
    forceSSL = true;
    locations = {
      "/".extraConfig = ''
        return 301 /auth;
      '';
      "/auth".proxyPass = "http://127.0.0.1:8089/auth";
    };
  };

  domains.kittywitch-keycloak = {
    network = "internet";
    type = "cname";
    domain = "auth";
  };
}
