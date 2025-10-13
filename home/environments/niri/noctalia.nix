{
  config,
  lib,
  ...
}: let
  inherit (lib.meta) getExe;
in {
  programs.noctalia-shell = {
    enable = true;
    settings = {
      settingsVersion = 15;
      bar = {
        position = "top";
        backgroundOpacity = 0.9;
        monitors = [];
        density = "comfortable";
        showCapsule = true;
        floating = true;
        marginVertical = 0.25;
        marginHorizontal = 0.25;
        widgets = {
          left = [
            {
              id = "Workspace";
              labelMode = "name";
            }
            {
              id = "ActiveWindow";
              widgetWidth = 300;
            }
          ];
          center = [
            {
              id = "MediaMini";
              showAlbumArt = true;
              showVisualizer = true;
              scrollingMode = "always";
              # check if this works,
              # if not, rewrite their system for it o.o
              widgetWidth = 300;
            }
            {
              id = "Clock";
              formatHorizontal = "yyyy-MM-dd HH:mm t";
            }
            {
              id = "NightLight";
            }
            {
              id = "DarkMode";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "ScreenRecorder";
            }
          ];
          right = [
            {
              id = "SystemMonitor";
            }
            {
              id = "Tray";
            }
            {
              id = "NotificationHistory";
            }
            {
              id = "Battery";
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "ControlCenter";
            }
          ];
        };
      };
      general = {
        avatarImage = ../../user/avatar.jpg;
        dimDesktop = false;
        showScreenCorners = false;
        forceBlackScreenCorners = false;
        radiusRatio = 1;
        screenRadiusRatio = 1;
        animationSpeed = 1;
        animationDisabled = false;
      };
      location = {
        name = "Vancouver";
        useFahrenheit = false;
        use12hourFormat = false;
        showWeekNumberInCalendar = false;
      };
      screenRecorder = {
        directory = "${config.home.homeDirectory}/Videos/";
        frameRate = 60;
        audioCodec = "opus";
        videoCodec = "h264";
        quality = "very_high";
        colorRange = "limited";
        showCursor = true;
        audioSource = "default_output";
        videoSource = "portal";
      };
      wallpaper = {
        # konawall
        enabled = false;
        directory = "";
        enableMultiMonitorDirectories = false;
        setWallpaperOnAllMonitors = true;
        defaultWallpaper = "";
        fillMode = "crop";
        fillColor = "#000000";
        randomEnabled = false;
        randomIntervalSec = 300;
        transitionDuration = 1500;
        transitionType = "random";
        transitionEdgeSmoothness = 0.05;
        monitors = [];
      };
      appLauncher = {
        enableClipboardHistory = true;
        position = "center";
        backgroundOpacity = 1;
        pinnedExecs = [];
        useApp2Unit = false;
        sortByMostUsed = true;
        terminalCommand = "${getExe config.programs.alacritty.package}";
      };
      controlCenter = {
        position = "close_to_bar_button";
        quickSettingsStyle = "compact";
        widgets = {
          quickSettings = [
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "Notifications";
            }
            {
              id = "ScreenRecorder";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "WallpaperSelector";
            }
          ];
        };
      };
      dock = {
        displayMode = "auto_hide";
        backgroundOpacity = 1;
        floatingRatio = 1;
        onlySameOutput = true;
        monitors = [];
        pinnedApps = [];
      };
      network = {
        wifiEnabled = true;
      };
      notifications = {
        doNotDisturb = false;
        monitors = [];
        location = "top_right";
        alwaysOnTop = false;
        lastSeenTs = 0;
        respectExpireTimeout = false;
        lowUrgencyDuration = 3;
        normalUrgencyDuration = 8;
        criticalUrgencyDuration = 15;
      };
      osd = {
        enabled = true;
        location = "top_right";
        monitors = [];
        autoHideMs = 2000;
      };
      audio = {
        volumeStep = 5;
        volumeOverdrive = false;
        cavaFrameRate = 60;
        visualizerType = "linear";
        mprisBlacklist = [];
        preferredPlayer = "";
      };
      ui = {
        fontDefault = config.stylix.fonts.sansSerif;
        fontFixed = config.stylix.fonts.monospace;
        fontDefaultScale = 1;
        fontFixedScale = 1;
        monitorsScaling = [
          {
            name = "DP-2";
            scale = 1.25;
          }
        ];
        idleInhibitorEnabled = false;
        tooltipsEnabled = true;
      };
      brightness = {
        brightnessStep = 5;
      };
      colorSchemes = {
        useWallpaperColors = false;
        predefinedScheme = "Dracula";
        darkMode = true;
        matugenSchemeType = "scheme-fruit-salad";
        generateTemplatesForPredefined = true;
      };
      templates = {
        gtk = false;
        qt = false;
        kitty = false;
        ghostty = false;
        foot = false;
        fuzzel = false;
        discord = false;
        discord_vesktop = false;
        discord_webcord = false;
        discord_armcord = false;
        discord_equibop = false;
        discord_lightcord = false;
        discord_dorion = false;
        pywalfox = false;
        enableUserTemplates = false;
      };
      nightLight = {
        enabled = false;
        forced = false;
        autoSchedule = true;
        nightTemp = "4000";
        dayTemp = "6500";
        manualSunrise = "06:30";
        manualSunset = "18:30";
      };
      hooks = {
        enabled = false;
        wallpaperChange = "";
        darkModeChange = "";
      };
    };
  };
}
