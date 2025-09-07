{pkgs, ...}: {
  home.packages = with pkgs; [
    pkgs.kdePackages.okular
  ];
}
