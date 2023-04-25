{pkgs, ...}: {
  home.packages = with pkgs; [
    imv # Image viewer
    yt-dlp # Downloading media
    v4l-utils # Webcam
  ];
}
