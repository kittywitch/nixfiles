{
  config,
  lib,
  ...
}: {
  networking.firewall.allowedTCPPorts = [
    # Zigbee2MQTT Frontend
    8072
  ];

  sops.secrets.z2m-secret = {
    owner = "zigbee2mqtt";
    path = "${config.services.zigbee2mqtt.dataDir}/secret.yaml";
  };

  users.groups.input.members = ["zigbee2mqtt"];

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
        password = "!secret z2m_pass";
      };
      homeassistant = true;
      permit_join = false;
      frontend = {
        port = 8072;
      };
      serial = {
        port = "/dev/ttyUSB0";
      };
    };
  };
}
