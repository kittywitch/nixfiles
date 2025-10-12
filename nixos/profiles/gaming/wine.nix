{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  inherit (lib.modules) mkMerge mkForce;
  cfg = config.mewtris;
in {
  mewtris = let
    gameStorage = "/home/kat/Games";
  in {
    enable = true;
    inherit gameStorage;
    runnerVariants = {
      PROTON_CACHYOS = "${inputs.chaotic.packages.${pkgs.system}.proton-cachyos_x86_64_v3.out}/bin";
      PROTON_GE = "${inputs.chaotic.packages.${pkgs.system}.proton-ge-custom.out}/bin";
      WINE_TKG = pkgs.wine-tkg;
    };
    runnerEnvironments = {
      common = {
        PROTON_LOG = builtins.toString 1;
        WINEDEBUG = "+warn";
        WINEUSERSANDBOX = builtins.toString 1;
      };
      dxvk = {
        DXVK_CONFIG_FILE = "${cfg.gameStorage}/dxvk/dxvk.conf";
        DXVK_USE_PIPECOMPILER = builtins.toString 1;
      };
      vkbasalt = {
        ENABLE_VKBASALT = builtins.toString 1;
        VKBASALT_CONFIG_FILE = "${cfg.gameStorage}/vkbasalt/vkBasalt_FilmicMedium.cfg";
        VKBASALT_LOG_FILE = "${cfg.gameStorage}/vkbasalt/vkBasalt_FilmicMedium.log";
      };
      shaderCache = {
        MESA_SHADER_CACHE_DIR = "${builtins.placeholder "game"}/shader-cache";
        __GL_SHADER_DISK_CACHE = builtins.toString 1;
        __GL_SHADER_DISK_CACHE_PATH = builtins.placeholder "prefix";
      };
      mangohud = let
        inherit (lib.strings) concatStringsSep;
      in {
        MANGOHUD = builtins.toString 1;
        MANGOHUD_CONFIG = concatStringsSep "," [
          "no_display"
          "vsync=1"
          "gl_vsync=0"
          "engine_version"
          "ram"
          "vram"
          "gpu_name"
          "cpu_stats"
          "gpu_stats"
          "frametime"
          "time"
          "wine"
          "winesync"
          "vkbasalt"
          "position=bottom-right"
          "font_size=36"
        ];
      };
      proton = {
        PROTON_USE_NTSYNC = builtins.toString 1;
      };
    };
    winTimezoneVariant = "PST8PDT";
    games = let
      protonCommon = {
        runner = "proton";
        variant = "PROTON_GE";
        environments = [
          "common"
          "proton"
          "dxvk"
          "mangohud"
          "shaderCache"
        ];
      };
      wineCommon = {
        runner = "wine";
        variant = "WINE_TKG";
        environments = [
          "common"
          "dxvk"
          "shaderCache"
        ];
      };
      battlenet = {
        long_name,
        launchArg,
      }: (protonCommon
        // rec {
          inherit long_name;
          battleNetGame = true;
          prefixFolder = gameStorage + "/battlenet";
          gameFolder = prefixFolder + "/drive_c/Program Files (x86)/Battle.net";
          gameExecutable = gameFolder + "/Battle.net.exe";
          gameArguments = [
            "--in-process-gpu"
            "--exec=\"launch ${launchArg}\""
          ];
        });
      vn = {
        long_name,
        vnDir,
        vnExe,
        vnArch ? "x86",
      }: (wineCommon
        // rec {
          inherit long_name;
          prefixFolder = gameStorage + "/VNs";
          gameFolder = prefixFolder;
          gameExecutable = "./drive_c/cmd.exe";
          gameArguments = [
            "/k"
            "C:/script.bat"
          ];
          environment = {
            VN_DIR = vnDir;
            VN_EXE = vnExe;
            VN_ARCH = vnArch;
          };
        });
    in {
      #
      # Visual Novels
      #

      kanon = vn {
        long_name = "Kanon";
        vnDir = "C:/KEY/KANON_SE_ALL";
        vnExe = "./REALLIVE.exe";
      };

      hanahira = vn {
        long_name = "Hanahira";
        vnDir = "C:/hanahira";
        vnExe = "./HANA9.exe";
      };

      #
      # Guild Warses
      #

      gw1 = mkMerge [
        protonCommon
        rec {
          long_name = "Guild Wars 1";
          prefixFolder = gameStorage + "/guild-wars";
          gameFolder = prefixFolder + "/drive_c/Program Files/Guild Wars";
          gameExecutable = gameFolder + "/Gw.exe";
          environments = ["vkbasalt"];
        }
      ];
      gw2 = mkMerge [
        protonCommon
        rec {
          variant = mkForce "PROTON_CACHYOS";
          long_name = "Guild Wars 2";
          prefixFolder = gameStorage + "/guild-wars-2";
          gameFolder = prefixFolder + "/drive_c/Program Files/Guild Wars 2";
          gameExecutable = gameFolder + "/Gw2-64.exe";
          environments = ["vkbasalt"];
          environment = {
            # https://github.com/Open-Wine-Components/umu-protonfixes/blob/master/gamefixes-steam/1284210.py
            # You know, having read this it feels disturbingly fucking pointless now?
            GAMEID = "umu-1284210";
            STORE = "none";
          };
        }
      ];

      #
      # Battle.net games
      #

      # The raw battlenet should not use the function OR the battlenet arg :p
      battlenet =
        protonCommon
        // rec {
          long_name = "Battle.net";
          prefixFolder = gameStorage + "/battlenet";
          gameFolder = prefixFolder + "/drive_c/Program Files (x86)/Battle.net";
          gameExecutable = gameFolder + "/Battle.net.exe";
          gameArguments = [
            "--in-process-gpu"
          ];
        };

      s1 = battlenet {
        long_name = "Starcraft: Remastered";
        launchArg = "S1";
      };
      s2 = battlenet {
        long_name = "Starcraft 2";
        launchArg = "S2";
      };
      w1 = battlenet {
        long_name = "Warcraft 1";
        launchArg = "W1";
      };
      w2 = battlenet {
        long_name = "Warcraft 2";
        launchArg = "W2";
      };
      w1r = battlenet {
        long_name = "Warcraft 1: Remastered";
        launchArg = "W1R";
      };
      w2r = battlenet {
        long_name = "Warcraft 2: Remastered";
        launchArg = "W2R";
      };
      w3 =
        battlenet {
          long_name = "Warcraft 3: Reforged";
          launchArg = "W3";
        }
        // {
          environment = {
            STAGING_SHARED_MEMORY = builtins.toString 1;
            __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = builtins.toString 1;
            PROTON_DISABLE_NVAPI = builtins.toString 1;
          };
        };
    };
  };
  hardware.graphics = {
    enable32Bit = true;
    extraPackages32 = with pkgs; [
      driversi686Linux.mesa
    ];
  };
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope;
  };
  environment.systemPackages = with pkgs; [
    gamescope-wsi
    mangohud
    vkbasalt
  ];
  #systemd.user.services =
  #  mapAttrs (k: v: {
  #    description = v;
  #    serviceConfig = {
  #      ExecStart = "${getExe pkgs.katwine} ${k}";
  #      Type = "simple";
  #    };
  #    inherit environment;
  #  })
  #  games;

  home-manager.users.kat.home.file = {
    # https://learnjapanese.moe/vn-linux/
    "Games/VNs/drive_c/script.bat".source = ./vn_script.bat;
    "Games/VNs/drive_c/cmd.exe".source = ./reactos_cmd.exe;
  };
}
