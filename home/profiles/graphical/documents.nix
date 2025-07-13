{pkgs, ...}: {
  home.packages = with pkgs; [
    calibre
    pkgs.kdePackages.okular
  ];
}
