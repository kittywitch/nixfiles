{ config, lib, pkgs, tf, ... }: let
  inherit (lib.types) unspecified isType;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) mapAttrs' nameValuePair mapAttrsToList;
  inherit (lib.strings) concatStringsSep;
  cfg = config.services.pounce;
in {
  options.services.pounce = {
    enable = mkEnableOption "Pounce BNC";
    servers = mkOption {
      type = unspecified;
      default = {};
    };
  };
  config = mkIf (cfg.enable) {
    #services.pounce.servers = builtins.fromJSON tf.variables."pounce-config".import;
    secrets = {
      variables = (mapAttrs' (server: config:
        nameValuePair "pounce-${server}-cert" {
          path = "gensokyo/pounce";
          field = "${server}-cert";
        }
      ) cfg.servers) // (mapAttrs' (server: config:
        nameValuePair "pounce-${server}-password" {
          path = "gensokyo/pounce";
          field = "${server}-password";
        }
      ) cfg.servers) // {
        "pounce-config" = {
          path = "gensokyo/pounce";
          field = "notes";
        };
      };
      files = (mapAttrs' (server: config:
        nameValuePair "pounce-${server}-config" {
          text = concatStringsSep "\n" (mapAttrsToList (key: value: if (builtins.typeOf value == "bool") then "${key}"
            else if (builtins.typeOf value == "int") then "${key} = ${builtins.toString value}"
            else if (builtins.typeOf value == "list") then "${key} = ${concatStringsSep "," value}" else "${key} = ${value}") config);
          owner = "pounce";
          group = "pounce";
        }
      ) cfg.servers) // (mapAttrs' (server: config:
        nameValuePair "pounce-${server}-cert" {
          text = tf.variables."pounce-${server}-cert".ref;
          owner = "pounce";
          group = "domain-auth";
        }
      ) cfg.servers);
    };
    users.users.pounce = {
      uid = 1501;
      isSystemUser = true;
      group = "domain-auth";
    };
    systemd.services = mapAttrs' (name: text: nameValuePair "pounce-${name}" {
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${pkgs.pounce}/bin/pounce ${config.secrets.file."pounce-${name}-config".path}";
        WorkingDirectory = "/var/lib/pounce";
        User = "pounce";
        Group = "domain-auth";
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
    }) cfg.servers;
  };
}
