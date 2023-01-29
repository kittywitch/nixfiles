{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    android-udev-rules
    jmtpfs
  ];
}
