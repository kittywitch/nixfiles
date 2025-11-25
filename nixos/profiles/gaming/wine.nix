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
    inherit (lib.strings) concatStringsSep;
    gameStorage = "/home/kat/Games";
  in {
    enable = true;
    createDesktopItems = true;
    inherit gameStorage;
    runnerVariants = {
      PROTON_CACHYOS = "${inputs.chaotic.packages.${pkgs.system}.proton-cachyos_x86_64_v3.out}/bin";
      PROTON_GE = "${inputs.chaotic.packages.${pkgs.system}.proton-ge-custom.out}/bin";
      WINE_TKG = pkgs.wine-tkg;
      WINE_CACHYOS = pkgs.wine-cachyos;
    };
    pathPackages = with pkgs; [
      mangohud
      vkbasalt
    ];
    runnerEnvironments = {
      common = {
        # inherit WINEDEBUG;
        PROTON_LOG = builtins.toString 1;
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
      mangohud = {
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
        PRESSURE_VESSEL_FILESYSTEMS_RW = "/games";
      };
    };
    winTimezoneVariant = "PST8PDT";
    games = let
      protonCommon = {
        runner = "proton";
        variant = "PROTON_GE";
        enableGamemode = true;
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
      }: let
        prefixFolder = gameStorage + "/battlenet";
        gameFolder' = "C:\\Program Files (x86)\\Battle.net";
        gameExecutable' = "Battle.net.exe";
      in
        protonCommon
        // {
          inherit long_name prefixFolder;
          gameFolder = prefixFolder;
          gameExecutable = "./drive_c/cmd.exe";
          gameArguments = [
            "/k"
            "C:/script.bat"
            gameFolder'
            gameExecutable'
            launchArg
          ];
        };
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
          gameExecutable = "C:\\cmd.exe";
          gameArguments = [
            "/k"
            "C:/script.bat"
            vnDir
            vnExe
            vnArch
          ];
          environment = {
            TZ = "Asia/Tokyo";
            LC_ALL = "ja_JP.UTF-8";
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
      # VRChat utilities
      #

      vrosc = mkMerge [
        protonCommon
        rec {
          long_name = "VR OSC";
          prefixFolder = gameStorage + "/Steam Library/steamapps/compatdata/438100";
          gameFolder = gameStorage + "/Steam Library/steamapps/common/VRChat";
          gameExecutable = gameFolder + "/VROSCSetup.exe";
        }
      ];

      #
      # Guild Warses
      #

      gw1 = mkMerge [
        protonCommon
        #wineCommon
        rec {
          #variant = mkForce "PROTON_CACHYOS";
          #variant = mkForce "PROTON_GE";
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
  programs.gamemode = {
    enable = true;
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

  home-manager.users.kat.home.file = let
    inherit (lib.attrsets) listToAttrs nameValuePair attrNames;
    inherit (lib.lists) concatMap;
    dxvks = {
      "x64" = pkgs.dxvk-w32;
      "x32" = pkgs.dxvk-w64;
    };
    pfxes = [
      "Games/VNs/drive_c/windows"
      "Games/guild-wars/drive_c/windows"
    ];
    arches = {
      "x32" = "system32";
      "x64" = "syswow64";
    };
    files = [
      "d3d8.dll"
      "d3d9.dll"
      "d3d10core.dll"
      "d3d11.dll"
      "dxgi.dll"
    ];
    dxvkLinker = pfx: arch: file: let
      dxvk = dxvks.${arch};
    in
      nameValuePair "${pfx}/${arches.${arch}}/${file}" {
        source = "${dxvk}/bin/${file}";
      };
  in
    (listToAttrs (concatMap (
        pfx:
          concatMap (
            arch:
              concatMap (
                file: [(dxvkLinker pfx arch file)]
              )
              files
          ) (attrNames arches)
      )
      pfxes))
    // {
      "Games/battlenet/drive_c/script.bat".source = ./bnet_script.bat;
      "Games/battlenet/drive_c/cmd.exe".source = ./reactos_cmd.exe;
      # https://learnjapanese.moe/vn-linux/
      "Games/VNs/drive_c/script.bat".source = ./vn_script.bat;
      "Games/VNs/drive_c/cmd.exe".source = ./reactos_cmd.exe;
    };
}
