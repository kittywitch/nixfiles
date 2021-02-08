{ config, lib, pkgs, ... }:

let
  sources = import ../../../nix/sources.nix;
  unstable = import sources.nixpkgs-unstable { inherit (pkgs) config; };
in {
  config = lib.mkIf (lib.elem "desktop" config.meta.deploy.profiles) {

    nixpkgs.config = {
      mumble.speechdSupport = true;
      pulseaudio = true;
    };

    environment.systemPackages = [ pkgs.redshift ];

    services.xserver.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
    programs.light.enable = true;

    home-manager.users.kat = {
      home.packages = [
        pkgs._1password
        pkgs.mpv
        pkgs.mumble
        pkgs.obs-studio
        pkgs.xfce.ristretto
        pkgs.avidemux
        pkgs.gnome3.networkmanagerapplet
        pkgs.vlc
        pkgs.ffmpeg-full
        unstable.syncplay
        unstable.youtube-dl
        unstable.google-chrome
        pkgs.v4l-utils
        pkgs.transmission-gtk
        pkgs.jdk11
        pkgs.lm_sensors
        unstable.discord
        pkgs.tdesktop
        pkgs.dino
        pkgs.vegur
        pkgs.nitrogen
        pkgs.terminator
        pkgs.pavucontrol
        pkgs.appimage-run
        pkgs.gparted
        pkgs.scrot
        pkgs.gimp-with-plugins
        pkgs.vscode
        pkgs.cryptsetup
        pkgs.neofetch
        pkgs.htop
      ];

      programs.fish = { interactiveShellInit = "set -g fish_greeting ''"; };

      programs.firefox = { enable = true; };

      services.kdeconnect = {
        enable = true;
        indicator = true;
      };

      services.redshift = {
        enable = true;
        latitude = "51.5074";
        longitude = "0.1278";
      };

      gtk = {
        enable = true;
        iconTheme = {
          name = "Numix-Square";
          package = pkgs.numix-icon-theme-square;
        };
        theme = {
          name = "Arc";
          package = pkgs.arc-theme;
        };
      };
    };

    fonts.fontconfig.enable = true;
    fonts.fonts = [ pkgs.nerdfonts pkgs.corefonts ];

    # KDE Connect
    networking.firewall = {
      allowedTCPPortRanges = [{
        from = 1714;
        to = 1764;
      }];
      allowedUDPPortRanges = [{
        from = 1714;
        to = 1764;
      }];
    };

    sound.enable = true;
    hardware.pulseaudio.enable = true;
    hardware.opengl.enable = true;
    services.xserver.libinput.enable = true;
  };
}
