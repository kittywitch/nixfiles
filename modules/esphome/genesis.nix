{ name, config, meta, pkgs, lib, ... }: with lib;
{
  options = {
  } // genAttrs [ "esphome" "api" "platform" "wifi" "i2c" "logger" "ota" "sensor" "secrets" ] (key:
  mkOption {
    type = types.unspecified;
    default = {};
  }
  );
  imports = with meta; [
    esphome.base
  ];
}
