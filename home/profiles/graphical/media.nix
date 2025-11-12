{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.attrsets) mapAttrsToList;
in {
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      sponsorblock
      mpris
      uosc
    ];
    config = {
      profile = "gpu-hq";
      hwdec = "auto";
      vo = "gpu";
      volume-max = 200;
      opengl-waitvsync = true;
      script-opts =
        builtins.concatStringsSep ","
        (mapAttrsToList (k: v: "${k}=${builtins.toString v}") {
          ytdl_hook-ytdl_path = "${pkgs.yt-dlp}/bin/yt-dlp";
          osc-layout = "slimbox";
          osc-vidscale = "no";
          osc-deadzonesize = 0.75;
          osc-minmousemove = 4;
          osc-hidetimeout = 2000;
          osc-valign = 0.9;
          osc-timems = "yes";
          osc-seekbarstyle = "knob";
          osc-seekbarkeyframes = "no";
          osc-seekrangestyle = "slider";
        });
    };
  };

  programs.zsh.shellAliases = {
    yt = "mpv --ytdl-format='bestvideo[height<=?720][fps<=?30][vcodec!=?vp9]+bestaudio/best[height<=720]'"; # Laptop doesn't like above 720p :c
  };
  home.packages = with pkgs; [
    yt-dlp # Watch videos from multiple sources without having to use a browser for it
    ytcc #  Subscriptions manager and RSS feed exporter for YouTube # TODO: Broken: 2025-10-28
  ];
}
