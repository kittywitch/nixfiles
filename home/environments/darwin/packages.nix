{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    exiftool
  ];
}
