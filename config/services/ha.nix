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
        "jellyfin"
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

  deploy.tf.dns.records.services_internal_home = {
    inherit (config.network.dns) zone;
    domain = "home.int";
    cname = { inherit (config.network.addresses.yggdrasil) target; };
  };

  services.nginx.virtualHosts."home.kittywit.ch" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8123";
      extraConfig = ''
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
      '';
    };
  };

  network.firewall.public.tcp.ports = [ 8123 ];
}
