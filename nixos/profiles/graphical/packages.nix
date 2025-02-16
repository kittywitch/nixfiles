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
    prusa-slicer
    super-slicer-beta
    inputs.konawall-py.packages.${pkgs.system}.konawall-py
    barrier
  ];
  services.udev.packages = [
    pkgs.android-udev-rules
    pkgs.via
  ];
}
