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
    inputs.konawall-py.packages.${pkgs.system}.konawall-py
  ];
  services.udev.packages = [
    pkgs.android-udev-rules
    pkgs.via
  ];
}
