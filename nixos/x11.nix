{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;
    autorun = false;
    exportConfiguration = true;
    in {
      startx.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    xorg.xinit
    xsel
    scrot
  ];
}
