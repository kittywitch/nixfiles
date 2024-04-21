{ pkgs, ... }: {
  services.gnome.gnome-keyring.enable = true;
  services.xserver = {
    enable = true;
    libinput.touchpad = {
      tappingButtonMap = "lrm";
      clickMethod = "clickfinger";
    };
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager.gdm.enable = true;
    displayManager.defaultSession = "xfce";
    xkbOptions = "ctrl:nocaps";
  };
  programs.xfconf.enable = true;

  environment.systemPackages = with pkgs; [
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-whiskermenu-plugin
    xclip
  ];

  services.colord.enable = true;
}
