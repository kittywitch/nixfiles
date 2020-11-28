{ config, lib, pkgs, ... }:

let
  nixpkgs-master = import
    (fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {
      config.allowUnfree = true;
    };
in {
  nixpkgs.config = { mumble.speechdSupport = true; };

  home-manager.users.kat = {
    home.packages = [
      pkgs._1password
      pkgs.mpv
      pkgs.mumble
      pkgs.vlc
      nixpkgs-master.pkgs.syncplay
      nixpkgs-master.pkgs.youtube-dl
      nixpkgs-master.google-chrome
      pkgs.transmission-gtk
      pkgs.jdk11
      pkgs.lm_sensors
      pkgs.discord
      pkgs.tdesktop
      pkgs.dino
      pkgs.vegur
      pkgs.nitrogen
      pkgs.terminator
      pkgs.appimage-run
      pkgs.scrot
      pkgs.gimp
      pkgs.vscode
      pkgs.cryptsetup
      pkgs.neofetch
      pkgs.htop
    ];

    programs.fish = {
      interactiveShellInit = ''
        set PATH $PATH $HOME/.config/composer/vendor/bin
      '';
    };

    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = "Numix-Square";
        package = pkgs.numix-icon-theme-square;
      };
      theme = {
        name = "Arc-Dark";
        package = pkgs.arc-theme;
      };
    };
  };

  fonts.fontconfig.enable = true;
  fonts.fonts = [ pkgs.nerdfonts pkgs.corefonts ];

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
}
