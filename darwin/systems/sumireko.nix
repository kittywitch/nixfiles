{ config, pkgs, lib, inputs, meta, ... }: {
  imports = with meta; [
    hardware.aarch64-darwin
      darwin.base
      darwin.kat
      home.work
  ];

  security.pam.enableSudoTouchIdAuth = true;

  home-manager.users.root.programs.ssh = {
    enable = true;
    matchBlocks = {
      "daiyousei-build" = {
        hostname = "daiyousei.kittywit.ch";
        port = 62954;
        user = "root";
      };
      "renko-build" = {
        hostname = "192.168.64.3";
        port = 62954;
        user = "root";
      };
    };
  };

  nix = {
    envVars = {
      "SSH_AUTH_SOCK" = "/Users/kat/.gnupg/S.gpg-agent.ssh";
    };
    buildMachines = [
    {
      hostName = "renko-build";
      sshUser = "root";
      system = "x86_64-linux";
      maxJobs = 100;
      speedFactor = 1;
      supportedFeatures = [ "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }
    {
      hostName = "daiyousei-build";
      sshUser = "root";
      system = "aarch64-linux";
      maxJobs = 100;
      speedFactor = 1;
      supportedFeatures = [ "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }
    ];
    distributedBuilds = true;
  };

  homebrew = {
    brewPrefix = "/opt/homebrew/bin";
    casks = [
      "utm"
        "mullvadvpn"
        "android-studio"
        "bitwarden"
        "telegram"
        "deluge"
        "alt-tab"
        "kicad"
        "disk-inventory-x"
        "element"
        "dozer"
        "discord"
        "firefox"
        "gimp"
        "devtoys"
        "google-assistant"
        "cyberduck"
        "docker"
        "google-chrome"
        "android-studio"
        "linear-linear"
        "pycharm-ce"
        "parsec"
        "nextcloud"
        "slack"
    ];
    masApps = {
      Tailscale = 1475387142;
      Dato = 1470584107;
      Lungo = 1263070803;
      "Battery Indicator" = 1206020918;
    };
  };

  system.stateVersion = 4;
                                          }
