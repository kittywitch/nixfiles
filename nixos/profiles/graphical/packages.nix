{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    jmtpfs
    dnsutils
    usbutils
    imagemagick
  ];
  services.udev.packages = [
    pkgs.android-udev-rules
    pkgs.zsa-udev-rules
    pkgs.via
  ];
}
