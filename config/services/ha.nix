{ config, ... }: {
  services = {
    home-assistant = {
      enable = true;
      config = null;
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
        homeassistant = true;
        permit_join = true;
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

  network.firewall.public.tcp.ports = [ 8123 ];
  network.firewall.private.tcp.ports = [ 8123 ];
}
