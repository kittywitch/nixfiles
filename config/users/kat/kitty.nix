{ config, lib, pkgs, ... }:

let style = import ./style.nix;
in {
  config = lib.mkIf (lib.elem "desktop" config.meta.deploy.profiles) {

    home-manager.users.kat = {
      programs.kitty = {
        enable = true;
        font.name = style.font.name;
        settings = {
          font_size = style.font.size;
          background = style.base16.color0;
          background_opacity = "0.7";
          foreground = style.base16.color7;
          selection_background = style.base16.color7;
          selection_foreground = style.base16.color0;
          url_color = style.base16.color3;
          cursor = style.base16.color7;
          active_border_color = "#75715e";
          active_tab_background = "#9900ff";
          active_tab_foreground = style.base16.color7;
          inactive_tab_background = "#3a3a3a";
          inactive_tab_foreground = "#665577";
        } // style.base16;
      };
    };
  };
}
