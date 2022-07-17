{ config, pkgs, lib, inputs, meta, ... }: {
  imports = with meta; [
    hardware.aarch64-darwin
    darwin.base
    darwin.kat
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
      "element"
      "visual-studio-code"
      "firefox"
      "telegram"
      "discord"
      "utm"
      "mullvadvpn"
      "bitwarden"
      "gimp"
      ];
      masApps = {
        Tailscale = 1475387142;
      };
    };

  environment.systemPackages = with pkgs; [
    terraform
    yt-dlp
    k2tf
    awscli
    jq
  ];

  system.stateVersion = 4;
}
