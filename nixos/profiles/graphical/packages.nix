{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    android-udev-rules
    jmtpfs
    dnsutils
    firefox
    usbutils
    inputs.konawall-py.packages.${pkgs.system}.konawall-py
  ];
}
