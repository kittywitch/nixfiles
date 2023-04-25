{
  lib,
  config,
  pkgs,
  prev,
  ...
}: let
  start = prev.config.systemd.services.matrix-synapse.serviceConfig.ExecStart;
  synapse_cfgfile = builtins.head (builtins.match "^.*--config-path ([^\ ]*).*$" "${start}");
in {
  systemd.services.matrix-synapse.serviceConfig.ExecStart = lib.mkForce (
    builtins.replaceStrings ["${synapse_cfgfile}"] ["${config.scalpel.trafos."homeserver.yaml".destination} "] "${start}"
  );
  scalpel.trafos."homeserver.yaml" = {
    source = synapse_cfgfile;
    matchers."MATRIX_SHARED_REGISTRATION_SECRET".secret = config.sops.secrets.matrix_shared_registration_secret.path;
    owner = "matrix-synapse";
    group = "matrix-synapse";
    mode = "0440";
  };
}
