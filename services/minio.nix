{ config, lib, ... }: let
  import (lib.modules) mkIf mkDefault;
  cfg = config.services.minio;
in {
  options.services.minio.isNAS = mkEnableFunction "NAS lack of defaults";

  config = {
    secrets = {
      variables = mapAttrs' (name: value: nameValuePair "minio-${name}-key" value) (genAttrs ["access" "secret"] (name: {
          path = "gensokyo/minio";
          field = "${name}-key";
      }));
      };
      files = {
        minio-root-credentials = {
          text = ''
            MINIO_ROOT_USER=${tf.variables.minio-access-key.ref}
            MINIO_ROOT_PASSWORD=${tf.variables.minio-secret-key.ref}
          '';
          owner = "minio";
          group = "minio";
        };
      };
    };

    systemd.tmpfiles.rules = mkIf !cfg.isNAS ''
      v /minio 700 minio minio
    '';

    services = {
      minio = {
        region = config.services.cockroachdb.locality;
        enable = true;
        dataDir = lib.optional !cfg.isNAS "/minio";
        listenAddress = "${config.networks.tailscale.ipv4}:9000";
        consoleAddress = "${config.networks.tailcale.ipv4}:9001";
        rootCredentialsFile = config.secrets.files.minio-root-credentials.path;
      };
    };
  };
}
