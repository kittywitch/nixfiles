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
