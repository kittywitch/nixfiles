{ config, lib, tf, ... }: {
  services.zigbee2mqtt = {
    enable = true;
    settings = {
      advanced = {
        log_level = "info";
        network_key = "!secret network_key";
      };
      homeassistant = true;
      permit_join = true;
      frontend = {
        port = 8072;
      };
      serial = {
        port = "/dev/serial/by-id/usb-Silicon_Labs_Sonoff_Zigbee_3.0_USB_Dongle_Plus_0001-if00-port0";
      };

    };
  };

  kw.secrets.variables.z2m-network-key = {
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

  network.firewall.public.tcp.ports = [ 8123 8072 1883 ];
  network.firewall.private.tcp.ports = [ 8123 ];
}
