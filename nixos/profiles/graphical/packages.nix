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
    barrier
  ];
  services.udev.packages = [
    pkgs.android-udev-rules
    pkgs.zsa-udev-rules
    pkgs.via
  ];
}
