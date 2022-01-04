{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;
    autorun = false;
    exportConfiguration = true;
    displayManager = let 
      compiledLayout = pkgs.runCommand "keyboard-layout" {} ''
        ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${./layout.xkb} $out
      '';
    in {
      sessionCommands = "${pkgs.xorg.xkbcomp}/bin/xkbcomp ${compiledLayout} $DISPLAY";
      startx.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    xorg.xinit
    xsel
    scrot
  ];
}
