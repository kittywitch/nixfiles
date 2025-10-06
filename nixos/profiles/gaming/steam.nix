{pkgs, ...}: {
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraProfile = ''
        unset TZ
      '';
    };
    remotePlay.openFirewall = true;
    platformOptimizations.enable = true;
    extraCompatPackages = [
    ];
  };
}
