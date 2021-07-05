{ sources, config, pkgs, lib, ... }: with lib; let
  cfg = config.deploy;
  meta = config;
  tfModule = { lib, ... }: with lib; {
    config._module.args = {
      pkgs = mkDefault pkgs;
    };
  };
  tfType = types.submoduleWith {
    modules = [
      tfModule
      "${toString sources.tf-nix}/modules"
    ];
  };
in {
  imports = [
    (toString (sources.tf-nix + "/modules/run.nix"))
  ] ++ (optional (builtins.pathExists ../../trusted/tf/tf.nix) (../../trusted/tf/tf.nix));
  options = {
    deploy = {
      dataDir = mkOption {
        type = types.path;
      };
      local = {
        isRoot = mkOption {
          type = types.bool;
          default = builtins.getEnv "HOME_UID" == "0";
        };
        hostName = mkOption {
          type = types.nullOr types.str;
          default = let
            hostName = builtins.getEnv "HOME_HOSTNAME";
          in if hostName == "" then null else hostName;
        };
      };
      targets = let
        type = types.submodule ({ config, name, ... }: {
          options = {
            name = mkOption {
              type = types.str;
              default = name;
            };
            nodeNames = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
            tf = mkOption {
              type = tfType;
              default = { };
            };
          };
          config.tf = mkMerge (singleton {
            imports = [
              ../../targets/common
            ];
            deps = {
              select.allProviders = true;
              enable = true;
            };
            terraform = {
              version = "1.0";
              logPath = cfg.dataDir + "/terraform-${config.name}.log";
              dataDir = cfg.dataDir + "/tfdata/${config.name}";
              environment.TF_CLI_ARGS_apply = "-backup=-";
              environment.TF_CLI_ARGS_taint = "-backup=-";
            };
            state = {
              file = cfg.dataDir + "/terraform-${config.name}.tfstate";
            };
            runners = {
              lazy = {
                inherit (meta.runners.lazy) file args;
                attrPrefix = "deploy.targets.${name}.tf.runners.run.";
              };
              run = {
                apply.name = "${name}-apply";
                terraform.name = "${name}-tf";
              };
            };
            continue.envVar = "TF_NIX_CONTINUE_${replaceStrings [ "-" ] [ "_" ] config.name}";
          } ++ map (nodeName: mapAttrs (_: mkMerge) meta.network.nodes.${nodeName}.deploy.tf.out.set) config.nodeNames);
        });
      in mkOption {
        type = types.attrsOf type;
        default = { };
      };
    };
  };
  config = {
    runners = {
      run = mkMerge (mapAttrsToList (targetName: target: mapAttrs' (k: run:
      nameValuePair run.name run.set
      ) target.tf.runners.run) cfg.targets);
      lazy.run = mkMerge (mapAttrsToList (targetName: target: mapAttrs' (k: run:
      nameValuePair run.name run.set
      ) target.tf.runners.lazy.run) cfg.targets);
    };
  };
}
