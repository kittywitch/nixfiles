{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    jmtpfs
    dnsutils
    usbutils
    plexamp
    super-slicer-beta
    nvidia-vaapi-driver
  ];
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vaapi
    ];
  };
  services.udev.packages = [
    pkgs.android-udev-rules
    pkgs.zsa-udev-rules
    pkgs.via
  ];
}
