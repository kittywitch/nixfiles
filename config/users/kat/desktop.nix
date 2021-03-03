{ config, lib, pkgs, ... }:

let sources = import ../../../nix/sources.nix;
in {
  imports = [ ./firefox ];

  config = lib.mkIf (lib.elem "desktop" config.deploy.profiles) {
    nixpkgs.config = {
      mumble.speechdSupport = true;
      pulseaudio = true;
    };

    services.xserver.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
    programs.light.enable = true;
    services.tumbler.enable = true;

    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
        gtkUsePortal = true;
      };
    };

    users.users.kat = {
      packages = with pkgs; [
        _1password
        bitwarden
        mpv
        element-desktop
        mumble
        obs-studio
        xfce.ristretto
        audacity
        avidemux
        vlc
        ffmpeg-full
        thunderbird
        unstable.syncplay
        unstable.youtube-dl
        unstable.google-chrome
        v4l-utils
        transmission-gtk
        lm_sensors
        baresip
        psmisc
        unstable.discord
        tdesktop
        yubikey-manager
        pinentry.gtk2
        dino
        nextcloud-client
        vegur
        nitrogen
        terminator
        pavucontrol
        gparted
        scrot
        gimp-with-plugins
        vscode
        cryptsetup
        pcmanfm
        neofetch
        htop
      ];
    };

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };

    home-manager.users.kat = {
      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
        XDG_CURRENT_DESKTOP = "sway";
        XDG_SESSION_TYPE = "wayland";
      };

      home.file.".gnupg/gpg-agent.conf".text = ''
        enable-ssh-support
        pinentry-program ${pkgs.pinentry.gtk2}/bin/pinentry
      '';

      services.nextcloud-client.enable = true;

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

    services.pcscd.enable = true;
    services.udev.packages = [ pkgs.yubikey-personalization ];

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
