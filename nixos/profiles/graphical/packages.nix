{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    jmtpfs
    dnsutils
    usbutils
    inputs.push2talk.defaultPackage.${pkgs.system}
  ];
  services.udev.packages = [
    pkgs.android-udev-rules
    pkgs.zsa-udev-rules
    pkgs.via
  ];
}
