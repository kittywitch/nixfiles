{ config, lib, tf, ... }: let
  inherit (lib.attrsets) attrNames filterAttrs;
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

          # shanghai systemd
          "switch.graphical".expose = true;
          "switch.mradio".expose = true;
          "switch.vm_goliath1650".expose = true;
          "switch.vm_goliath3080".expose = true;
          "switch.vm_hourai1650".expose = true;
          "switch.vm_hourai3080".expose = true;
        };
      };
      homekit = {
        name = "Tewi";
        port = 21063;
        ip_address = "10.1.1.38";
        filter = let
          inherit (config.services.home-assistant.config) google_assistant;
        in {
          include_domains = google_assistant.exposed_domains;
          include_entities = attrNames (filterAttrs (_: entity: entity.expose or true) google_assistant.entity_config);
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
      input_datetime = {};
      input_number = {};
      input_select = {};
      input_text = {};
      logbook = {};
      map = {};
      media_source = {};
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
      "scene"
      "script"
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
