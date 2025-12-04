{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    jmtpfs
    dnsutils
    usbutils
    imagemagick
  ];
  services.udev.packages = [
    pkgs.zsa-udev-rules
    pkgs.via
  ];
}
