{
  config,
  pkgs,
  lib,
  std,
  ...
}: {
  options.mewtris = let
    inherit (lib.types) path attrsOf submodule str nullOr enum either package bool lines listOf;
    inherit (lib.options) mkEnableOption mkOption;
    inherit (lib.meta) getExe';
  in {
    enable = mkEnableOption "Enable mewtris";
    umuLauncher = mkOption {
      description = "umu-launcher package";
      type = package;
      default = pkgs.umu-launcher;
    };
    gameStorage = mkOption {
      description = "Where is the base directory for your game runner storage?";
      type = nullOr path;
      default = null;
    };
    runnerEnvironments = mkOption {
      description = "Sets of environments to compose for your games";
      type = attrsOf (attrsOf str);
      default = {};
    };
    runnerVariants = mkOption {
      description = "Contains references to proton version bin/ folders";
      type = attrsOf (either path package);
      default = {};
    };
    winTimezoneVariant = mkOption {
      description = ''
        Please refer to https://www.ibm.com/docs/en/idr/11.4.0?topic=zos-time-zone-codes-tz-environment-variable
        For Proton, this allows you to fix weird timezone issues.
      '';
      type = nullOr str;
      default = null;
    };
    globalPrerun = mkOption {
      description = "Commands to run before every runner";
      default = ''
        export WINE_CPU_TOPOLOGY=$(${getExe' pkgs.coreutils "nproc"} --all)
      '';
      type = lines;
    };
    games = let
      nixosConfig = config;
      gameSubmodule = {
        name,
        config,
        ...
      }: let
        cfg = nixosConfig.mewtris;
      in {
        options = {
          name = mkOption {
            description = "Systemd service name for the game, a shorthand";
            type = str;
            default = name;
          };
          long_name = mkOption {
            description = "Longhand name of the game";
            type = nullOr str;
          };
          prefixFolder = mkOption {
            description = "Where is the game's wine prefix?";
            type = either path str;
          };
          gameFolder = mkOption {
            description = "Where is the game's folder?";
            type = nullOr (either path str);
            default = null;
          };
          gameExecutable = mkOption {
            description = "Where is the EXE to run?";
            type = either path str;
          };
          gameArguments = mkOption {
            description = "What arguments do we run the game with?";
            type = listOf str;
            default = [];
          };
          battleNetGame = mkOption {
            description = "Is this a battle.net game? Not used for battle.net itself!";
            type = bool;
            default = false;
          };
          prefixArch = mkOption {
            description = "Wine prefix architecture";
            type = enum [
              "win64"
              "win32"
            ];
            default = "win64";
          };
          runner = mkOption {
            description = "What runner system to use?";
            type = enum [
              "proton"
              "wine"
            ];
            default = "proton";
          };
          prerun = mkOption {
            description = "Commands to run before the game";
            default = "";
            type = lines;
          };
          environments = mkOption {
            description = "What environments to compose into the runner?";
            type = listOf str;
            default = [];
          };
          environment = mkOption {
            description = "Any game specific environment variables?";
            type = attrsOf str;
            default = {};
          };
          variant = mkOption {
            description = "What variant of the runner?";
            type = nullOr str;
          };
          startLine = mkOption {
            description = "What do we run to start this game as a systemd service?";
            type = package;
            internal = true;
          };
        };
        config = let
          inherit (lib.modules) mkIf mkMerge;
          inherit (lib.strings) escapeShellArgs optionalString;
          inherit (lib.attrsets) optionalAttrs;
        in
          mkMerge [
            {
              environment = {
                WINEPREFIX = config.prefixFolder;
                WINEARCH = config.prefixArch;
              };
            }
            (mkIf (config.runner == "wine") {
              startLine = pkgs.writeShellScript "${config.name}" ''
                ${cfg.globalPrerun}
                ${config.prerun}
                ${optionalString (config.gameFolder != null) ''
                  "cd ${config.gameFolder}"
                ''}
                "${getExe' cfg.runnerVariants.${config.variant} "wine"}" "${config.gameExecutable}" ${escapeShellArgs config.gameArguments}
              '';
            })
            (mkIf (config.runner == "proton") {
              environment =
                (optionalAttrs (cfg.winTimezoneVariant != null) {
                  TZ = cfg.winTimezoneVariant;
                })
                // {
                  PROTONPATH = cfg.runnerVariants.${config.variant};
                };
              startLine = let
                protonLauncher = getExe' cfg.umuLauncher "umu-run";
              in
                pkgs.writeShellScript "${config.name}" ''
                  ${cfg.globalPrerun}
                  ${config.prerun}
                  ${optionalString config.battleNetGame ''
                    "${protonLauncher}" "${config.gameFolder}/Battle.net Launcher.exe" &
                  ''}
                  cd "${config.gameFolder}"
                  "${protonLauncher}" "${config.gameExecutable}" ${escapeShellArgs config.gameArguments}
                '';
            })
          ];
      };
    in
      mkOption {
        type = attrsOf (submodule gameSubmodule);
        default = {};
      };
  };
  config = let
    cfg = config.mewtris;
    inherit (lib.lists) singleton concatMap;
    inherit (lib.strings) replaceStrings;
    inherit (lib.attrsets) mapAttrs nameValuePair mapAttrs' attrNames attrValues;
    inherit (lib.modules) mkIf;
    inherit (std.set) merge;
  in
    mkIf cfg.enable {
      systemd.user.services = mapAttrs' (_k: v:
        nameValuePair v.name {
          description = v.long_name;
          serviceConfig = {
            ExecStart = v.startLine;
            Type = "simple";
          };
          environment = let
            composedEnvironments = concatMap (e: singleton cfg.runnerEnvironments.${e}) v.environments;
            combinedEnvironments = merge (composedEnvironments ++ (singleton v.environment));
            replacements = {
              ${builtins.placeholder "prefix"} = v.prefixFolder;
              ${builtins.placeholder "game"} = v.gameFolder;
              ${builtins.placeholder "exe"} = v.gameExecutable;
            };
            replacer = replaceStrings (attrNames replacements) (attrValues replacements);
            replacePlaceholders = _k: replacer;
          in
            mapAttrs replacePlaceholders combinedEnvironments;
        })
      config.mewtris.games;
    };
}
