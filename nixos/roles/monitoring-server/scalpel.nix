{
  lib,
  config,
  prev,
  ...
}: let
  inherit (lib.strings) addContextFrom;
  inherit (lib.modules) mkForce;
  telegraf_start = prev.config.systemd.services.telegraf.serviceConfig.ExecStart;
  telegraf_cfgfile = builtins.head (builtins.match "^.*-config ([^\ ]*).*$" "${telegraf_start}");
  prometheus_start = prev.config.systemd.services.prometheus.serviceConfig.ExecStart;
  prometheus_cfgfile = builtins.head (builtins.match "^.*-config\.file=([^\ ]*).*$" "${prometheus_start}");
in {
  systemd.services.telegraf.serviceConfig.ExecStart = mkForce (
    builtins.replaceStrings ["${telegraf_cfgfile}"] ["${config.scalpel.trafos."config.toml".destination} "] "${telegraf_start}"
  );
  scalpel.trafos."config.toml" = {
    source = addContextFrom telegraf_start telegraf_cfgfile;
    matchers."TELEGRAF_API_KEY".secret = config.sops.secrets.telegraf_api_key.path;
    owner = "telegraf";
    group = "telegraf";
    mode = "0440";
  };
  systemd.services.prometheus.serviceConfig.ExecStart = mkForce (
    builtins.replaceStrings ["${prometheus_cfgfile}"] ["${config.scalpel.trafos."prometheus.yml".destination} "] "${prometheus_start}"
  );
  scalpel.trafos."prometheus.yml" = {
    source = addContextFrom prometheus_start prometheus_cfgfile;
    matchers."HOME_ASSISTANT_API_TOKEN".secret = config.sops.secrets.home_assistant_api_key.path;
    owner = "prometheus";
    group = "prometheus";
    mode = "0440";
  };
}
