{ config, lib, tf, ... }: let
  inherit (lib.attrsets) attrNames filterAttrs mapAttrs' nameValuePair;
in {
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
    path = "gensokyo/home-assistant";
    field = "notes";
  };

  secrets.files.ha-integration = {
    text = tf.variables.ha-integration.ref;
    owner = "hass";
    group = "hass";
  };

  secrets.variables.latitude = {
    path = "gensokyo/home-assistant";
    field = "latitude";
  };

  secrets.variables.longitude = {
    path = "gensokyo/home-assistant";
    field = "longitude";
  };

  secrets.variables.elevation = {
    path = "gensokyo/home-assistant";
    field = "elevation";
  };

  secrets.variables.iphone-se-irk = {
    path = "gensokyo/home-assistant";
    field = "iphone-se-irk";
  };
  secrets.variables.tile-bee = {
    path = "gensokyo/home-assistant";
    field = "tile-bee";
  };
  secrets.variables.tile-kat-wallet = {
    path = "gensokyo/home-assistant";
    field = "tile-kat-wallet";
  };
  secrets.variables.tile-kat-keys = {
    path = "gensokyo/home-assistant";
    field = "tile-kat-keys";
  };
  secrets.variables.mpd-shanghai-password = {
    path = "gensokyo/abby";
    field = "mpd";
  };

  secrets.files.home-assistant-secrets = {
    text = let
      espresenceDevices = {
        iphone-se-irk = tf.variables.iphone-se-irk.ref;
        tile-kat-wallet = tf.variables.tile-kat-wallet.ref;
        tile-kat-keys = tf.variables.tile-kat-keys.ref;
        tile-bee = tf.variables.tile-bee.ref;
      };
    in builtins.toJSON ({
      latitude = tf.variables.latitude.ref;
      longitude = tf.variables.longitude.ref;
      elevation = tf.variables.elevation.ref;
      mpd-shanghai-password = tf.variables.mpd-shanghai-password.ref;
    } // espresenceDevices // mapAttrs' (key: device_id:
      nameValuePair "${key}-topic" "espresense/devices/${device_id}"
    ) espresenceDevices);
    owner = "hass";
    group = "hass";
  };

  systemd.services.home-assistant = {
    preStart = lib.mkBefore ''
      cp --no-preserve=mode ${config.secrets.files.home-assistant-secrets.path} ${config.services.home-assistant.configDir}/secrets.yaml
      cp --no-preserve=mode ${config.secrets.files.ha-integration.path} ${config.services.home-assistant.configDir}/integration.yaml
      # UI-editable config files
      touch ${config.services.home-assistant.configDir}/{automations,scenes,scripts}.yaml
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
      withings = {
        use_webhook = true;
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
        report_state = true;
        exposed_domains = [
          "scene"
          "script"
          "climate"
          #"sensor"
        ];
        entity_config = let
          hidden = "XYZ";
        in {
          # bedroom entities
          "light.bedside_lamp".expose = true;
          "light.bedroom_strip".expose = true;
          "light.bedroom_overhead".expose = true;
          "light.bed_side_overhead".room = hidden;
          "light.closet_side_overhead".room = hidden;
          "light.pc_side_overhead".room = hidden;
          "fan.fornuftig_fan".expose = true;
          "fan.bedroom_floor".expose = true;
          "switch.swb1_relay_3".expose = true;
          "switch.swb1_relay_4".expose = true;

          # living room entities
          "light.dining_overhead".expose = true;
          "light.living_cluster".expose = true;
          "light.living_overhead".room = hidden;
          "light.couch_overhead_left".room = hidden;
          "light.couch_overhead_right".room = hidden;
          # midea
          "climate.living_ac".aliases = [
            "AC"
            "Midea"
          ];
          "sensor.living_ac_outdoor_temperature".expose = false;

          # balcony
          "light.outdoor_strip".expose = true;

          # shanghai systemd
          "switch.shanghai_graphical".expose = true;
          "switch.shanghai_mradio".expose = true;
          "switch.shanghai_vm_goliath1650".expose = true;
          "switch.shanghai_vm_goliath3080".expose = true;
          "switch.shanghai_vm_hourai1650".expose = true;
          "switch.shanghai_vm_hourai3080".expose = true;
        };
      };
      homekit = {
        name = "Tewi";
        port = 21063;
        ip_address = "10.1.1.38";
        filter = let
          inherit (config.services.home-assistant.config) google_assistant;
          entities = filterAttrs (_: entity: entity.expose or true) google_assistant.entity_config;
        in {
          include_domains = google_assistant.exposed_domains;
          include_entities = attrNames (removeAttrs entities [
            # HomeKit is able to group lights together, no need to use the google hack here
            "light.living_cluster"
            "light.bedroom_overhead"
          ]);
        };
        entity_config = {
          "switch.swb1_relay_3".type = "outlet";
          "switch.swb1_relay_4".type = "outlet";
        };
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
      "script manual" = [];
      "script ui" = "!include scripts.yaml";
      counter = {};
      device_tracker = {};
      energy = {};
      group = {};
      history = {};
      image = {};
      input_boolean = {};
      input_button = {};
      input_datetime = {};
      input_number = {};
      input_select = {};
      input_text = {};
      logbook = {};
      schedule = {};
      map = {};
      media_source = {};
      media_player = [
        {
          platform = "mpd";
          name = "Shanghai MPD";
          host = "10.1.1.32";
          password = "!secret mpd-shanghai-password";
        }
      ];
      mobile_app = {};
      my = {};
      person = {};
      ssdp = {};
      switch = {};
      stream = {};
      sun = {};
      system_health = {};
      tag = {};
      template = {};
      tile = {};
      timer = {};
      webhook = {};
      wake_on_lan = {};
      zeroconf = {};
      zone = {};
      sensor = let
        mkESPresenceBeacon = { device_id, ... }@args: {
          platform = "mqtt_room";
          state_topic = "espresense/devices/${device_id}";
        } // args;
      in [
        (mkESPresenceBeacon {
          device_id = "!secret iphone-se-irk";
          state_topic = "!secret iphone-se-irk-topic";
          name = "iPhone SE";
          timeout = 2;
          away_timeout = 120;
        })
        (mkESPresenceBeacon {
          device_id = "name:galaxy-watch-active";
          name = "Galaxy Watch Active";
        })
        (mkESPresenceBeacon {
          device_id = "3003c8383b6c";
          name = "MT7922 BT";
        })
        (mkESPresenceBeacon {
          device_id = "d8f8833681ba";
          name = "AX210 BT";
        })
        (mkESPresenceBeacon {
          device_id = "md:03ff:6";
          name = "Kat's Smartwatch";
        })
        (mkESPresenceBeacon {
          device_id = "!secret tile-bee";
          state_topic = "!secret tile-bee-topic";
          name = "Bee";
        })
        (mkESPresenceBeacon {
          device_id = "!secret tile-kat-wallet";
          state_topic = "!secret tile-kat-wallet-topic";
          name = "Kat's Wallet";
        })
        (mkESPresenceBeacon {
          device_id = "!secret tile-kat-keys";
          state_topic = "!secret tile-kat-keys-topic";
          name = "Girlwife";
        })
      ];
    };
    extraPackages = python3Packages: with python3Packages; [
      psycopg2
      aiohomekit
      pkgs.withings-api
      securetar
      getmac # for upnp integration
      (aiogithubapi.overrideAttrs (_: { doInstallCheck = false; }))
    ];
    extraComponents = [
      "automation"
      "scene"
      "script"
      "zha"
      "esphome"
      "apple_tv"
      "spotify"
      "default_config"
      "brother"
      "ipp"
      "cast"
      "plex"
      "met"
      "google"
      "google_assistant"
      "google_cloud"
      "google_translate"
      "homekit"
      "mpd"
      "mqtt"
      "tile"
      "wake_on_lan"
      "withings"
      "zeroconf"
    ];
  };
}
