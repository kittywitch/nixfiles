{ config, lib, tf, ... }: {
  kw.secrets.variables.ha-integration = {
    path = "secrets/home-assistant";
    field = "notes";
  };

  secrets.files.ha-integration = {
    text = tf.variables.ha-integration.ref;
    owner = "hass";
    group = "hass";
  };

  systemd.services.home-assistant = {
    preStart = lib.mkBefore ''
      rm ${config.services.home-assistant.configDir}/integration.json
      cp --no-preserve=mode ${config.secrets.files.ha-integration.path} ${config.services.home-assistant.configDir}/integration.json
    '';
  };

  services.home-assistant = {
    enable = true;
    config = {
      default_config = {};
      google_assistant = {
        project_id = "gensokyo-5cfaf";
        service_account = "!include integration.json";
      };
      http = {
        cors_allowed_origins = [
          "https://google.com"
          "https://www.home-assistant.io"
        ];
        use_x_forwarded_for = "true";
        trusted_proxies = [
          "127.0.0.0/24"
          "200::/7"
          "100.64.0.0/10"
          "fd7a:115c:a1e0:ab12::/64"
        ];
      };

      homeassistant = {
        name = "Gensokyo";
        unit_system = "metric";
        external_url = "https://home.gensokyo.zone";
      };
      logger = {
        default = "info";
      };
      recorder = {
        db_url = "postgresql://@/hass";

      };
      homekit = {
        name = "Tewi";
        port = 21063;
        ip_address = "10.1.1.38";
      };
    };
    extraPackages = python3Packages: with python3Packages; [
      psycopg2
      securetar
    ];
    extraComponents = [
      "zha"
      "esphome"
      "apple_tv"
      "spotify"
      "default_config"
      "cast"
      "plex"
      "met"
      "google"
      "google_assistant"
      "google_cloud"
      "google_translate"
      "homekit"
      "mqtt"
      "wake_on_lan"
      "zeroconf"
    ];
  };
                      }
