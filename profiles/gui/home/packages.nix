{ config, lib, pkgs, ... }:

let
  bitw = pkgs.writeShellScriptBin "bitw" ''
    ${pkgs.arc.pkgs.rbw-bitw}/bin/bitw -p gpg://${
      ../../../private/files/bitw/master.gpg
    } "$@"'';
in {
  home.packages = with pkgs; [
    _1password
    bitwarden
    bitw
    wire-desktop
    element-desktop
    wf-recorder
    mumble
    obs-studio
    niv
    feh
    kat-scrot
    duc
    exiftool
    audacity
    avidemux
    gst_all_1.gstreamer.dev
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
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
}
