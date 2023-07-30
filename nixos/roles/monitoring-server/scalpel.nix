{
  lib,
  config,
  prev,
  ...
}: let
  inherit (lib.strings) addContextFrom;
  inherit (lib.modules) mkForce;
  start = prev.config.systemd.services.telegraf.serviceConfig.ExecStart;
  telegraf_cfgfile = builtins.head (builtins.match "^.*-config ([^\ ]*).*$" "${start}");
in {
  systemd.services.telegraf.serviceConfig.ExecStart = mkForce (
    builtins.replaceStrings ["${telegraf_cfgfile}"] ["${config.scalpel.trafos."config.toml".destination} "] "${start}"
  );
  scalpel.trafos."config.toml" = {
    source = addContextFrom start telegraf_cfgfile;
    matchers."TELEGRAF_API_KEY".secret = config.sops.secrets.telegraf_api_key.path;
    owner = "telegraf";
    group = "telegraf";
    mode = "0440";
  };
  #environment.etc."ensure_telegraf_trafos".source = telegraf_cfgfile;
}
