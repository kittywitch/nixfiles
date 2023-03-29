{ pkgs, config, lib, tf, ... }: let
  cfg = config.services.home-assistant;
  inherit (lib.attrsets) attrNames filterAttrs mapAttrs' nameValuePair;
  inherit (lib.strings) hasPrefix;
in {
  # MDNS
  services.avahi.enable = true;

  networks.gensokyo = {
    tcp = [
      # Home Assistant
      cfg.config.http.server_port
      # Tewi Homekit
      cfg.config.homekit.port
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
      path = "${cfg.configDir}/integration.yaml";
    };
    ha-secrets = {
      owner = "hass";
      path = "${cfg.configDir}/secrets.yaml";
    };
  };

  systemd.services.home-assistant = {
    # UI-editable config files
    preStart = lib.mkBefore ''
      touch ${cfg.configDir}/{automations,scenes,scripts,manual,homekit_entity_config,homekit_include_entities}.yaml
    '';
  };

  services.home-assistant = {
    enable = true;
    config = {
      homeassistant = {
        name = "Gensokyo";
        unit_system = "metric";
        latitude = "!secret home_lat";
        longitude = "!secret home_long";
        elevation = "!secret home_asl";
        currency = "CAD";
        country = "CA";
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
          "::1"
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
        entity_config = { };
      };
      homekit = {
        name = "Tewi";
        port = 21063;
        ip_address = "10.1.1.38";
        filter = let
          inherit (cfg.config) google_assistant;
        in {
          include_domains = google_assistant.exposed_domains;
          include_entities = "!include homekit_include_entities.yaml";
        };
        entity_config = "!include homekit_entity_config.yaml";
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
    package = pkgs.home-assistant.override {
      packageOverrides = self: super: {
        pysnmplib = if lib.versionAtLeast self.brother.version "2.3.0"
          then lib.warn "outdated pysnmplib override can be deleted" super.pysnmplib
          else super.pysnmplib.overrideAttrs (old: rec {
            version = "5.0.20";
            src = pkgs.fetchFromGitHub {
              inherit (old.src) owner repo;
              rev = "v${version}";
              hash = "sha256-SrtOn9zETtobT6nMVHLi6hP7VZGBvXvFzoThTi3ITag=";
            };
          });
      };
    };
    extraPackages = python3Packages: with python3Packages; [
      psycopg2
      aiohomekit
      securetar
      getmac # for upnp integration
      python-otbr-api
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
      "wled"
      "zeroconf"
    ];
  };
}
