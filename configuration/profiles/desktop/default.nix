{ config, lib, pkgs, ... }:

let unstable = import ( fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz ) {}; in {
  nixpkgs.config = {
    mumble.speechdSupport = true;
  };

  home-manager.users.kat = {
    home.packages = [
      pkgs._1password
      pkgs.mpv
      pkgs.mumble
      unstable.pkgs.syncplay
      unstable.pkgs.youtube-dl
      pkgs.jdk11
      pkgs.lm_sensors
      pkgs.discord
      pkgs.tdesktop
      pkgs.dino
      pkgs.nitrogen
      pkgs.terminator
      pkgs.appimage-run
      pkgs.gimp
      pkgs.vscode
      pkgs.neofetch
      pkgs.htop
    ];

    programs.fish = {
      interactiveShellInit = ''
        set PATH $PATH $HOME/.config/composer/vendor/bin
      '';
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
  fonts.fonts = [
    pkgs.nerdfonts
    pkgs.corefonts
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.enable = true;
  services.xserver.libinput.enable = true;
}
