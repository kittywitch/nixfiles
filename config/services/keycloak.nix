{ config, pkgs, lib, tf, ... }: with lib; let
  keystore-pass = "zZX3eS";
in {
  services.keycloak = {
    enable = builtins.getEnv "CI_PLATFORM" == "impure";
    package = (pkgs.keycloak.override {
      jre = pkgs.openjdk11;
    });
    bindAddress = "127.0.0.1";
    httpPort = "8089";
    httpsPort = "8445";
    initialAdminPassword = "mewpymewlymewlies";
    forceBackendUrlToFrontendUrl = true;
    frontendUrl = "https://auth.${config.network.dns.domain}/auth";
    database.passwordFile = config.secrets.files.keycloak-postgres-file.path;
    extraConfig = {
    "subsystem=undertow" = {
      "server=default-server" = {
        "http-listener=default" = {
          "proxy-address-forwarding" = true;
        };
      };
    };
    "subsystem=keycloak-server" = {
        "spi=truststore" = {
          "provider=file" = {
            enabled = true;
            properties.password = keystore-pass;
            properties.file = "/var/lib/acme/domain-auth/trust-store.jks";
            properties.hostname-verification-policy = "WILDCARD";
            properties.disabled = false;
          };
        };
      };
    };
  };


  network.extraCerts.domain-auth = "auth.${config.network.dns.domain}";
  users.groups.domain-auth.members = [ "nginx" "openldap" "keycloak" ];
  security.acme.certs.domain-auth = {
    group = "domain-auth";
    postRun = ''
      ${pkgs.adoptopenjdk-jre-bin}/bin/keytool -delete -alias auth.kittywit.ch -keypass ${keystore-pass} -storepass ${keystore-pass} -keystore ./trust-store.jks
      ${pkgs.adoptopenjdk-jre-bin}/bin/keytool -import -alias auth.${config.network.dns.domain} -noprompt -keystore trust-store.jks -keypass ${keystore-pass} -storepass ${keystore-pass} -file cert.pem
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

  services.nginx.virtualHosts."auth.${config.network.dns.domain}" = {
    useACMEHost = "domain-auth";
    forceSSL = true;
    locations = { "/".proxyPass = "http://127.0.0.1:8089"; };
  };

  deploy.tf.dns.records.services_keycloak = {
    inherit (config.network.dns) zone;
    domain = "auth";
    cname = { inherit (config.network.addresses.public) target; };
  };
}
