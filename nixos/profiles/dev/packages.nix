{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ida-pro-kat
    android-studio
    bingrep
    hexyl
    jwt-cli
    silicon
    tokei
  ];
}
