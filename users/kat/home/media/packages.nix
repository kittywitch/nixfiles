{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
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
    youtube-dl
    mkchromecast
    v4l-utils
    gimp-with-plugins
    wf-recorder
  ];
}
