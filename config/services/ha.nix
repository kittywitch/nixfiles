{ config, ... }: {
  services.home-assistant = {
    enable = true;
    config = null;
    extraComponents = [
      "zha"
      "esphome"
      "met"
      "default_config"
      "google"
      "google_assistant"
      "google_cloud"
      "google_translate"
      "homekit"
      "zeroconf"
      "luci"
    ];
  };

  network.firewall.public.tcp.ports = [ 8123 ];
}
