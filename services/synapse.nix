{ config, pkgs, lib, tf, ... }:

with lib;

{
  environment.systemPackages = [ pkgs.mx-puppet-discord pkgs.mautrix-whatsapp ];

  services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
    CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
    CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
    TEMPLATE template0
    LC_COLLATE = "C"
    LC_CTYPE = "C";
  '';

  kw.secrets.variables = (mapListToAttrs
    (field:
      nameValuePair "mautrix-telegram-${field}" {
        path = "secrets/mautrix-telegram";
        inherit field;
      }) [ "api-hash" "api-id" "as-token" "hs-token" ]
      // (mapListToAttrs (field:
        nameValuePair "synapse-saml2-${field}" {
          path = "secrets/synapse-saml2-${field}";
        }) ["cert" "key"])
      // {
    matrix-registration = {
      path = "secrets/matrix-registration";
    };
  });

  secrets.files.mautrix-telegram-env = {
    text = ''
      MAUTRIX_TELEGRAM_TELEGRAM_API_ID=${tf.variables.mautrix-telegram-api-id.ref}
      MAUTRIX_TELEGRAM_TELEGRAM_API_HASH=${tf.variables.mautrix-telegram-api-hash.ref}
      MAUTRIX_TELEGRAM_APPSERVICE_AS_TOKEN=${tf.variables.mautrix-telegram-as-token.ref}
      MAUTRIX_TELEGRAM_APPSERVICE_HS_TOKEN=${tf.variables.mautrix-telegram-hs-token.ref}
    '';
  };

  secrets.files.matrix-registration-secret = {
    text = ''
      registration_shared_secret: ${tf.variables.matrix-registration.ref}
    '';
    owner = "matrix-synapse";
    group = "matrix-synapse";
  };

  secrets.files.saml2-cert = {
    text = tf.variables.synapse-saml2-cert.ref;
    owner = "matrix-synapse";
    group = "matrix-synapse";
  };

  secrets.files.saml2-privkey = {
    text = tf.variables.synapse-saml2-key.ref;
    owner = "matrix-synapse";
    group = "matrix-synapse";
  };

  secrets.files.saml2-map = {
    fileName = "map.py";
    text = ''
MAP = {
    "identifier": "urn:oasis:names:tc:SAML:2.0:attrname-format:uri",
    "fro": {
        'uid': 'uid',
        'displayName': 'displayName',
    },
    "to": {
        'uid': 'uid',
        'displayName': 'displayName',
    }
}
    '';
    owner = "matrix-synapse";
    group = "matrix-synapse";
  };

  secrets.files.saml2-config = {
    fileName = "saml2-config.py";
    text = ''
import saml2
from saml2.saml import NAME_FORMAT_URI

BASE = "https://kittywit.ch/"

CONFIG = {
    "entityid": "matrix-kittywit.ch",
    "description": "Matrix Server",
    "service": {
        "sp": {
            "name": "matrix-login",
            "endpoints": {
                "single_sign_on_service": [
                    (BASE + "_matrix/saml2/authn_response", saml2.BINDING_HTTP_POST),
                ],
                "assertion_consumer_service": [
                    (BASE + "_matrix/saml2/authn_response", saml2.BINDING_HTTP_POST),
                ],
                #"single_logout_service": [
                #    (BASE + "_matrix/saml2/logout", saml2.BINDING_HTTP_POST),
                #],
            },
            "required_attributes": ["uid",],
            "optional_attributes": ["displayName"],
            "sign_assertion": True,
            "sign_response": True,
        }
    },
    "debug": 0,
    "key_file": "${config.secrets.files.saml2-privkey.path}",
    "cert_file": "${config.secrets.files.saml2-cert.path}",
    "encryption_keypairs": [
        {
            "key_file": "${config.secrets.files.saml2-privkey.path}",
            "cert_file": "${config.secrets.files.saml2-cert.path}",
        }
    ],
    "attribute_map_dir": "${builtins.dirOf config.secrets.files.saml2-map.path}",
    "metadata": {
        "remote": [
          {
          "url": "https://auth.kittywit.ch/auth/realms/kittywitch/protocol/saml/descriptor",
          },
        ],
    },
    # If you want to have organization and contact_person for the pysaml2 config
    #"organization": {
    #    "name": "Example AB",
    #    "display_name": [("Example AB", "se"), ("Example Co.", "en")],
    #    "url": "http://example.com/roland",
    #},
    #"contact_person": [{
    #    "given_name": "Example",
    #    "sur_name": "Example",
    #    "email_address": ["example@example.com"],
    #    "contact_type": "technical",
    #    },
    #],
    # Make sure to have xmlsec1 installed on your host(s)!
    "xmlsec_binary": "${pkgs.xmlsec}/bin/xmlsec1",
}
    '';
    owner = "matrix-synapse";
    group = "matrix-synapse";
  };

  services.matrix-synapse.extraConfigFiles = [
    config.secrets.files.matrix-registration-secret.path
  ];

  services.mautrix-telegram.environmentFile =
    config.secrets.files.mautrix-telegram-env.path;
  services.matrix-synapse = {
    enable = true;
    settings = {
      log_config = pkgs.writeText "nya.yaml" ''
      version: 1
      formatters:
        precise:
          format: '%(asctime)s - %(name)s - %(lineno)d - %(levelname)s - %(request)s - %(message)s'
      filters:
        context:
          (): synapse.util.logcontext.LoggingContextFilter
          request: ""
      handlers:
        console:
          class: logging.StreamHandler
          formatter: precise
          filters: [context]
      loggers:
        synapse:
          level: WARNING
        synapse.storage.SQL:
          # beware: increasing this to DEBUG will make synapse log sensitive
          # information such as access tokens.
          level: WARNING
      root:
        level: WARNING
        handlers: [console]
    '';
      server_name = "kittywit.ch";
      app_service_config_files = [
        "/var/lib/matrix-synapse/telegram-registration.yaml"
        "/var/lib/matrix-synapse/discord-registration.yaml"
        "/var/lib/matrix-synapse/whatsapp-registration.yaml"
      ];
      max_upload_size = "512M";
      rc_messages_per_second = mkDefault 0.1;
      rc_message_burst_count = mkDefault 25;
      public_baseurl = "https://kittywit.ch";
      url_preview_enabled = mkDefault true;
      enable_registration = mkDefault false;
      enable_metrics = mkDefault false;
      report_stats = mkDefault false;
      dynamic_thumbnails = mkDefault true;
      allow_guest_access = mkDefault true;
      suppress_key_server_warning = mkDefault true;
      listeners = [{
        port = 8008;
        bind_addresses = [ "::1" ] ;
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [{
          names = [ "client" "federation" ];
          compress = false;
        }];
      }];
      saml2_config = {
        sp_config.metadata.remote = [ {
          url = "https://auth.kittywit.ch/auth/realms/kittywitch/protocol/saml/descriptor";
        } ];
        config_path = config.secrets.files.saml2-config.path;
        user_mapping_provider = {
          config = {};
        };
        password_config = {
          enabled = false;
        };
      };
    };
  };

  services.mautrix-telegram = {
    enable = true;
    settings = {
      homeserver = {
        address = "https://kittywit.ch";
        domain = config.network.dns.domain;
      };
      appservice = {
        provisioning.enabled = false;
        id = "telegram";
        public = {
          enabled = false;
          prefix = "/public";
          external = "https://kittywit.ch/public";
        };
      };
      bridge = {
        relaybot.authless_portals = false;
        permissions = {
          "@kat:kittywit.ch" = "admin";
          "kittywit.ch" = "full";
        };
      };
    };
  };

  systemd.services.mx-puppet-discord = {
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      ExecStart =
        "${pkgs.mx-puppet-discord}/bin/mx-puppet-discord -c /var/lib/mx-puppet-discord/config.yaml -f /var/lib/mx-puppet-discord/discord-registration.yaml";
      WorkingDirectory = "/var/lib/mx-puppet-discord";
      DynamicUser = true;
      StateDirectory = "mx-puppet-discord";
      UMask = 27;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
    };
    requisite = [ "matrix-synapse.service" ];
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
  };

  systemd.services.mautrix-whatsapp = {
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      ExecStart =
        "${pkgs.mautrix-whatsapp}/bin/mautrix-whatsapp -c /var/lib/mautrix-whatsapp/config.yaml -r /var/lib/mautrix-whatsapp/registration.yaml";
      WorkingDirectory = "/var/lib/mautrix-whatsapp";
      DynamicUser = true;
      StateDirectory = "mautrix-whatsapp";
      UMask = 27;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
    };
    requisite = [ "matrix-synapse.service" ];
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
  };

  domains.kittywitch-matrix = {
    inherit (config.networks.internet) target;
    type = "cname";
    domain = "matrix";
  };

  services.nginx.virtualHosts."matrix.kittywit.ch" = {
    extraConfig = ''
      keepalive_requests 100000;
    '';
    root = pkgs.cinny.override {
      conf = {
        defaultHomeserver = 0;
        homeserverList = [
          "kittywit.ch"
        ];
        allowCustomHomeservers = false;
      };
    };
  };

  services.nginx.virtualHosts."kittywit.ch" = {
    # allegedly fixes https://github.com/poljar/weechat-matrix/issues/240
    extraConfig = ''
      keepalive_requests 100000;
    '';

    locations = {
      "/_matrix" = { proxyPass = "http://[::1]:8008"; };
      "= /.well-known/matrix/server".extraConfig =
        let server = { "m.server" = "${config.network.dns.domain}:443"; };
        in
        ''
          add_header Content-Type application/json;
          return 200 '${builtins.toJSON server}';
        '';
      "= /.well-known/matrix/client".extraConfig =
        let
          client = {
            "m.homeserver" = { "base_url" = "https://kittywit.ch"; };
            "m.identity_server" = { "base_url" = "https://vector.im"; };
          };
        in
        ''
          add_header Content-Type application/json;
          add_header Access-Control-Allow-Origin *;
          return 200 '${builtins.toJSON client}';
        '';
    };
  };
}
