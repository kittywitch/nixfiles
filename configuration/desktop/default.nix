{ config, lib, pkgs, ... }:

let unstable = import ( fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz ) {}; in {
  nixpkgs.config = {
    mumble.speechdSupport = true;
  };

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  environment.systemPackages = [ 
    pkgs.php 
    pkgs.php74Packages.composer2
  ];

  services.gvfs = {
    enable = true;
    package = pkgs.gnome3.gvfs;
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
      pkgs.carnix
      pkgs.rustc
      pkgs.cargo
      pkgs.steam
      pkgs.dino
      pkgs.dconf2nix
      pkgs.nitrogen
      pkgs.terminator
      pkgs.appimage-run
      pkgs.gimp
      pkgs.vscode
      pkgs.neofetch
      pkgs.htop
      pkgs.jetbrains.clion
      pkgs.jetbrains.idea-ultimate
      pkgs.jetbrains.goland
      pkgs.jetbrains.phpstorm
      pkgs.gnome3.gnome-tweak-tool
      pkgs.gnomeExtensions.caffeine
      pkgs.gnomeExtensions.emoji-selector
      pkgs.gnomeExtensions.gsconnect
      pkgs.gnomeExtensions.dash-to-panel
      pkgs.gnomeExtensions.appindicator
      pkgs.gnomeExtensions.dash-to-dock
      pkgs.gnomeExtensions.arc-menu
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

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.enable = true;
  services.xserver.libinput.enable = true;
}
