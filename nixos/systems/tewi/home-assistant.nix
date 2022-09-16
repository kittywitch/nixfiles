{ config, lib, ... }: {
  services.home-assistant = {
    enable = true;
    config = {
      automation = "automations.yaml";
      config = null;
      counter = null;
      device_tracker = null;
      dhcp = null;
      energy = null;
      frontend = { themes = "themes"; };
      google_assistant = null;
      group = "groups.yaml";
      history = null;
      homeassistant = {
        external_url = "https://home.gensokyo.zone";
        packages = "packages";
      };
      http = {
        cors_allowed_origins = [
          "https://google.com"
          "https://www.home-assistant.io"
        ];
        trusted_proxies = [
          "127.0.0.0/24"
          "200::/7"
        ];
        use_x_forwarded_for = true;
      };
      image = null;
      input_boolean = null;
      input_datetime = null;
      input_number = null;
      input_select = null;
      input_text = null;
      logbook = null;
      logger = {
        default = "info";
      };
      device_tracker = null;
      map = null;
      media_source = null;
      mobile_app = null;
      my = null;
      person = null;
      recorder = {
        auto_purge = true;
        commit_interval = 1;
        exclude = {
          domains = [
            "automation"
              "updater"
          ]; 
          entities = [
            "sun.sun"
              "sensor.last_boot"
              "sensor.date"
              "sensor.time"
          ];
          entity_globs = [
            "sensor.weather_*"
              "sensor.date_*"
          ];
          event_types = [
            "call_service"
          ];
        };
        purge_keep_days = 14;
      };
      scene = "scenes.yaml";
      script = "scripts.yaml";
      ssdp = null;
      stream = null;
      sun = null;
      switch = null;
      system_health = null;
      tag = null;
      template = null;
      timer = null;
      tts = [{
        platform = "google_translate";
        service_name = "google_say";
      }];
      wake_on_lan = null;
      webhook = null;
      zeroconf = null;
      zone = null;
    };
    extraComponents = [
      "zha"
        "esphome"
        "apple_tv"
        "spotify"
        "default_config"
        "cast"
        "plex"
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
