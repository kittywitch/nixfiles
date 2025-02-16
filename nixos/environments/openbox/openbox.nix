{pkgs, ...}: {
  services = {
    gnome.gnome-keyring.enable = true;
    xserver = {
      enable = true;
      libinput.touchpad = {
        tappingButtonMap = "lrm";
        clickMethod = "clickfinger";
      };
      windowManager = {
        openbox.enable = true;
      };
      displayManager.defaultSession = "none+openbox";
      xkbOptions = "ctrl:nocaps";
    };
    colord.enable = true;
  };
  programs.xfconf.enable = true;

  environment.systemPackages = with pkgs; [
    menumaker
    xclip
    obconf
    numix-gtk-theme
  ];
}
