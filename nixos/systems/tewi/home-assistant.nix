{ config, lib, tf, ... }: let
  inherit (lib.attrsets) attrNames filterAttrs mapAttrs' nameValuePair;
  inherit (lib.strings) hasPrefix;
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

  sops.secrets = {
    ha-integration = {
      owner = "hass";
      path = "${config.services.home-assistant.configDir}/integration.yaml";
    };
    ha-secrets = {
      owner = "hass";
      path = "${config.services.home-assistant.configDir}/secrets.yaml";
    };
  };

  systemd.services.home-assistant = {
    # UI-editable config files
    preStart = lib.mkBefore ''
      touch ${config.services.home-assistant.configDir}/{automations,scenes,scripts,manual}.yaml
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
        packages = {
          manual = "!include manual.yaml";
        };
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
          "light.closet_overhead".expose = true;
          "light.closet_overhead_left".room = hidden;
          "light.closet_overhead_right".room = hidden;
          "fan.bedroom_purifier" = {
            expose = true;
            aliases = [
              "FÖRNUFTIG"
              "Bedroom Air Purifier"
            ];
          };
          "fan.bedroom_floor".expose = true;
          "switch.swb1_relay_3".expose = true;
          "switch.swb1_relay_4".expose = true;

          # living room entities
          "light.dining_overhead".expose = true;
          "light.living_cluster".expose = true;
          "light.living_overhead".room = hidden;
          "light.tv_overhead".room = hidden;
          "light.couch_overhead_left".room = hidden;
          "light.couch_overhead_right".room = hidden;
          "light.tv_bias" = {
            room = hidden;
            aliases = [
              "Bias Lighting"
              "TV Backlight"
            ];
          };
          "light.living_bookshelf".room = hidden;
          # midea
          "climate.living_ac".aliases = [
            "AC"
            "Midea"
          ];
          "sensor.living_ac_outdoor_temperature".expose = false;

          # kitchen
          "light.kitchen_overhead".expose = true;
          "light.kitchen_overhead_inner".room = hidden;
          "light.kitchen_overhead_middle".room = hidden;
          "light.kitchen_overhead_outer".room = hidden;

          # balcony
          "light.outdoor_strip".expose = true;
          "light.lantern".expose = true;

          # foyer
          "light.entry_overhead".expose = true;
          "light.entry_overhead_left".room = hidden;
          "light.entry_overhead_right".room = hidden;

          # shanghai systemd
          "switch.shanghai_graphical".expose = true;
          "switch.shanghai_mradio".expose = true;
          "switch.shanghai_vm_goliath1650".expose = true;
          "switch.shanghai_vm_goliath3080".expose = true;
          "switch.shanghai_vm_hourai1650".expose = true;
          "switch.shanghai_vm_hourai3080".expose = true;
          "cover.shanghai_dpms" = {
            expose = true;
            aliases = [
              "DPMS"
            ];
          };
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
            "light.closet_overhead"
            "light.kitchen_overhead"
            "light.entry_overhead"
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
      sensor = {};
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
