{ config, lib, tf, ... }: {
  # MDNS
  services.avahi.enable = true;

  networks.gensokyo = {
    tcp = [
      # Home Assistant
      8123
      # Tewi Homekit
      21063
    ];
    udp = [
      # Chromecast
      [ 32768 60999 ]
      # MDNS
      5353
    ];
  };

  secrets.variables.ha-integration = {
    path = "secrets/home-assistant";
    field = "notes";
  };

  secrets.files.ha-integration = {
    text = tf.variables.ha-integration.ref;
    owner = "hass";
    group = "hass";
  };

  secrets.variables.latitude = {
    path = "secrets/home-assistant";
    field = "latitude";
  };

  secrets.variables.longitude = {
    path = "secrets/home-assistant";
    field = "longitude";
  };

  secrets.variables.elevation = {
    path = "secrets/home-assistant";
    field = "elevation";
  };

  secrets.variables.iphone-se-irk = {
    path = "secrets/home-assistant";
    field = "iphone-se-irk";
  };


  secrets.files.home-assistant-secrets = {
    text = builtins.toJSON {
      latitude = tf.variables.latitude.ref;
      longitude = tf.variables.longitude.ref;
      elevation = tf.variables.elevation.ref;
      iphone-se-irk = tf.variables.iphone-se-irk.ref;
    };
    owner = "hass";
    group = "hass";
  };

  systemd.services.home-assistant = {
    preStart = lib.mkBefore ''
      cp --no-preserve=mode ${config.secrets.files.home-assistant-secrets.path} ${config.services.home-assistant.configDir}/secrets.yaml
      cp --no-preserve=mode ${config.secrets.files.ha-integration.path} ${config.services.home-assistant.configDir}/integration.yaml
      touch ${config.services.home-assistant.configDir}/automations.yaml
      touch ${config.services.home-assistant.configDir}/scenes.yaml
    '';
  };

  services.home-assistant = {
    enable = true;
    config = {
      homeassistant = {
        name = "Gensokyo";
        unit_system = "metric";
        latitude = "!secret latitude";
        longitude = "!secret longitude";
        elevation = "!secret elevation";
        currency = "CAD";
        time_zone = "America/Vancouver";
        external_url = "https://home.gensokyo.zone";
      };
      frontend = {
        themes = "!include_dir_merge_named themes";
      };
      powercalc = {
      };
      utility_meter = {
      };
      logger = {
        default = "info";
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
      recorder = {
        db_url = "postgresql://@/hass";
        auto_purge = true;
        purge_keep_days = 14;
        commit_interval = 1;
        exclude = {
          domains = [
            "automation"
              "updater"
          ];
          entity_globs = [
            "sensor.weather_*"
              "sensor.date_*"
          ];
          entities = [
            "sun.sun"
              "sensor.last_boot"
              "sensor.date"
              "sensor.time"
          ];
          event_types = [
            "call_service"
          ];
        };
      };
      google_assistant = {
        project_id = "gensokyo-5cfaf";
        service_account = "!include integration.yaml";
      };
      homekit = {
        name = "Tewi";
        port = 21063;
        ip_address = "10.1.1.38";
      };
      tts = [{
        platform = "google_translate";
        service_name = "google_say";
      }];
      # https://nixos.wiki/wiki/Home_Assistant#Combine_declarative_and_UI_defined_automations
      "automation manual" = [ ];
      "automation ui" = "!include automations.yaml";
      # https://nixos.wiki/wiki/Home_Assistant#Combine_declarative_and_UI_defined_scenes
      "scene manual" = [];
      "scene ui" = "!include scenes.yaml";
      sensor = let
        mkESPresenceBeacon = { device_id, ... }@args: {
          platform = "mqtt_room";
          state_topic = "espresense/devices/${device_id}";
        } // args;
      in [
        (mkESPresenceBeacon {
          device_id = "!secret iphone-se-irk";
          name = "iPhone SE";
          timeout = 2;
          away_timeout = 120;
        })
        (mkESPresenceBeacon {
          device_id = "name:galaxy-watch-active";
          name = "Galaxy Watch Active";
        })
      ];
    };
    extraPackages = python3Packages: with python3Packages; [
      psycopg2
      aiohomekit
      securetar
      getmac # for upnp integration
      (aiogithubapi.overrideAttrs (_: { doInstallCheck = false; }))
    ];
    extraComponents = [
      "automation"
      "counter"
      "device_tracker"
      "energy"
      "group"
      "history"
      "image"
      "input_boolean"
      "input_datetime"
      "input_number"
      "input_select"
      "input_text"
      "logbook"
      "map"
      "media_source"
      "mobile_app"
      "my"
      "person"
      "scene"
      "script"
      "ssdp"
      "switch"
      "stream"
      "sun"
      "system_health"
      "tag"
      "template"
      "timer"
      "webhook"
      "zone"
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
