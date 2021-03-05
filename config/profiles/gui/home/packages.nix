{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.deploy.profile.gui {
    home.packages = with pkgs; [
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
      libnotify
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
}
