{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ida-pro-kat
    android-studio
  ];
}
