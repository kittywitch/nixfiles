{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gst_all_1.gstreamer.dev
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    imv
    ffmpeg-full
    yt-dlp
    mkchromecast
    v4l-utils
    gimp-with-plugins
    wf-recorder
    dolphinEmuMaster
    pcsxr
    pcsx2
    mgba
    nestopia
    snes9x-gtk
    citra
    melonDS
    mupen64plus
    retroarch
    sixpair
    xboxdrv
  ];
}
