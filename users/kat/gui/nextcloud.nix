{ config, pkgs, ... }: {
  services = {
    nextcloud-client = {
      enable = true;
    };
    gnome-keyring = {
      enable = true;
    };
  };
  home.packages = [
    pkgs.gnome3.seahorse
  ];
}
