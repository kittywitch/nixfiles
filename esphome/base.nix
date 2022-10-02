{ config, ... }: {
  api = {
    password = "!secret api_password";
  };
  ota = {
    safe_mode = true;
    password = "!secret ota_password";
  };
  wifi = {
    ssid = "Gensokyo";
    password = "!secret wifi_password";
  };
  logger = {
    level = "DEBUG";
  };
  secrets = {
    ota_password = "gensokyo/esphome#ota";
    api_password = "gensokyo/esphome#api";
    wifi_password = "gensokyo/esphome#wifi";
  };
}
