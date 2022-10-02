{ config, lib, tf, ... }: {
  services = {
    home-assistant = {
      enable = true;
      config = lib.mkForce null;
      extraComponents = [
        "zha"
        "esphome"
        "apple_tv"
        "spotify"
        "met"
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
        "luci"
      ];
    };
    mosquitto = {
      enable = true;
      persistence = true;
      listeners = [ {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      } ];
    };
    zigbee2mqtt = {
      enable = true;
      settings = {
        advanced = {
          log_level = "info";
          network_key = "!secret network_key";
        };
        homeassistant = true;
        permit_join = false;
        frontend = {
          port = 8072;
        };
        serial = {
          port = "tcp://192.168.1.149:8888";
          adapter = "ezsp";
        };

      };
    };
  };

  systemd.services.home-assistant.reloadTriggers = lib.mkForce [ ];

  secrets.variables.z2m-network-key = {
    path = "secrets/zigbee2mqtt";
    field = "password";
  };

  secrets.files.zigbee2mqtt-config = {
    text = builtins.toJSON config.services.zigbee2mqtt.settings;
    owner = "zigbee2mqtt";
    group = "zigbee2mqtt";
  };

  secrets.files.zigbee2mqtt-secret = {
    text = "network_key: ${tf.variables.z2m-network-key.ref}";
    owner = "zigbee2mqtt";
    group = "zigbee2mqtt";
  };

  systemd.services.zigbee2mqtt.preStart = let cfg = config.services.zigbee2mqtt; in lib.mkForce ''
    cp --no-preserve=mode ${config.secrets.files.zigbee2mqtt-config.path} "${cfg.dataDir}/configuration.yaml"
    cp --no-preserve=mode ${config.secrets.files.zigbee2mqtt-secret.path} "${cfg.dataDir}/secret.yaml"
  '';

  networks.chitei.tcp = [ 8123 8072 1883 ];
}
