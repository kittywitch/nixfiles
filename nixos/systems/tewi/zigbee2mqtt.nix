{ config, lib, tf, ... }: {
  networks.gensokyo = {
    tcp = [
      # Zigbee2MQTT Frontend
      8072
    ];
  };

  secrets.variables.z2m-mqtt-password = {
    path = "secrets/mosquitto";
    field = "z2m";
  };

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

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      advanced = {
        log_level = "info";
        network_key = "!secret network_key";
      };
      mqtt = {
        server = "mqtt://127.0.0.1:1883";
        user = "z2m";
        password = tf.variables.z2m-mqtt-password.ref;
      };
      homeassistant = true;
      permit_join = false;
      frontend = {
        port = 8072;
      };
      serial = {
        port = "/dev/serial/by-id/usb-Silicon_Labs_Sonoff_Zigbee_3.0_USB_Dongle_Plus_0001-if00-port0";
      };

    };
  };

  systemd.services.zigbee2mqtt.preStart = let cfg = config.services.zigbee2mqtt; in lib.mkForce ''
    cp --no-preserve=mode ${config.secrets.files.zigbee2mqtt-config.path} "${cfg.dataDir}/configuration.yaml"
    cp --no-preserve=mode ${config.secrets.files.zigbee2mqtt-secret.path} "${cfg.dataDir}/secret.yaml"
  '';
}
