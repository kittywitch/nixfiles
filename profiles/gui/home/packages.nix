{ config, lib, pkgs, ... }:

let
  bitw = pkgs.writeShellScriptBin "bitw" ''
    ${pkgs.arc.pkgs.rbw-bitw}/bin/bitw -p gpg://${
      ../../../private/files/bitw/master.gpg
    } "$@"'';
in {
  config = lib.mkIf config.deploy.profile.gui {
    home.packages = with pkgs; [
      _1password
      bitwarden
      bitw
      mpv
      element-desktop
      mumble
      obs-studio
      niv
      feh
      kat-scrot
      duc
      exiftool
      audacity
      avidemux
      vlc
      ffmpeg-full
      thunderbird
      unstable.syncplay
      unstable.youtube-dl
      unstable.mkchromecast
      unstable.google-chrome
      v4l-utils
      transmission-gtk
      lm_sensors
      p7zip
      baresip
      psmisc
      discord
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
      vifm
      neofetch
      htop
    ];
  };
}
