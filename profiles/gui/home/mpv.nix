{ config, lib, ... }:

{
  programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.sponsorblock ];    
    config = {
      profile = "gpu-hq";
      gpu-context = "wayland";
      vo = "gpu";
      hwdec = "auto";
      demuxer-max-bytes = "2000MiB";
      demuxer-max-back-bytes = "250MiB";
    };
  };
}
