{
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkForce;
  qtct = ''
    [Appearance]
    color_scheme_path=${inputs.catppuccin-qtct}/themes/Catppuccin-Frappe.conf
    custom_palette=true
    icon_theme=Breeze
    standard_dialogs=kde
    style=Breeze
  '';
  colors = pkgs.writeTextFile {
    name = "colors";
    text = ''
      @define-color accent_color ${config.palette.${config.catppuccin.accent}.hex};
      @define-color accent_bg_color ${config.palette.${config.catppuccin.accent}.hex};
      @define-color accent_fg_color ${config.palette.base.hex};
      @define-color destructive_color ${config.palette.red.hex};
      @define-color destructive_bg_color ${config.palette.red.hex};
      @define-color destructive_fg_color ${config.palette.base.hex};
      @define-color success_color ${config.palette.green.hex};
      @define-color success_bg_color ${config.palette.green.hex};
      @define-color success_fg_color ${config.palette.base.hex};
      @define-color warning_color ${config.palette.mauve.hex};
      @define-color warning_bg_color ${config.palette.mauve.hex};
      @define-color warning_fg_color ${config.palette.base.hex};
      @define-color error_color ${config.palette.red.hex};
      @define-color error_bg_color ${config.palette.red.hex};
      @define-color error_fg_color ${config.palette.base.hex};
      @define-color window_bg_color ${config.palette.base.hex};
      @define-color window_fg_color ${config.palette.text.hex};
      @define-color view_bg_color ${config.palette.base.hex};
      @define-color view_fg_color ${config.palette.text.hex};
      @define-color headerbar_bg_color ${config.palette.mantle.hex};
      @define-color headerbar_fg_color ${config.palette.text.hex};
      @define-color headerbar_border_color rgba(${builtins.toString config.palette.base.rgb.r}, ${builtins.toString config.palette.base.rgb.g}, ${builtins.toString config.palette.base.rgb.b}, 0.7);
      @define-color headerbar_backdrop_color @window_bg_color;
      @define-color headerbar_shade_color rgba(0, 0, 0, 0.07);
      @define-color headerbar_darker_shade_color rgba(0, 0, 0, 0.07);
      @define-color sidebar_bg_color ${config.palette.mantle.hex};
      @define-color sidebar_fg_color ${config.palette.text.hex};
      @define-color sidebar_backdrop_color @window_bg_color;
      @define-color sidebar_shade_color rgba(0, 0, 0, 0.07);
      @define-color secondary_sidebar_bg_color @sidebar_bg_color;
      @define-color secondary_sidebar_fg_color @sidebar_fg_color;
      @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
      @define-color secondary_sidebar_shade_color @sidebar_shade_color;
      @define-color card_bg_color ${config.palette.mantle.hex};
      @define-color card_fg_color ${config.palette.text.hex};
      @define-color card_shade_color rgba(0, 0, 0, 0.07);
      @define-color dialog_bg_color ${config.palette.mantle.hex};
      @define-color dialog_fg_color ${config.palette.text.hex};
      @define-color popover_bg_color ${config.palette.mantle.hex};
      @define-color popover_fg_color ${config.palette.text.hex};
      @define-color popover_shade_color rgba(0, 0, 0, 0.07);
      @define-color shade_color rgba(0, 0, 0, 0.07);
      @define-color scrollbar_outline_color ${config.palette.surface0.hex};
      @define-color blue_1 ${config.palette.blue.hex};
      @define-color blue_2 ${config.palette.blue.hex};
      @define-color blue_3 ${config.palette.blue.hex};
      @define-color blue_4 ${config.palette.blue.hex};
      @define-color blue_5 ${config.palette.blue.hex};
      @define-color green_1 ${config.palette.green.hex};
      @define-color green_2 ${config.palette.green.hex};
      @define-color green_3 ${config.palette.green.hex};
      @define-color green_4 ${config.palette.green.hex};
      @define-color green_5 ${config.palette.green.hex};
      @define-color yellow_1 ${config.palette.yellow.hex};
      @define-color yellow_2 ${config.palette.yellow.hex};
      @define-color yellow_3 ${config.palette.yellow.hex};
      @define-color yellow_4 ${config.palette.yellow.hex};
      @define-color yellow_5 ${config.palette.yellow.hex};
      @define-color orange_1 ${config.palette.peach.hex};
      @define-color orange_2 ${config.palette.peach.hex};
      @define-color orange_3 ${config.palette.peach.hex};
      @define-color orange_4 ${config.palette.peach.hex};
      @define-color orange_5 ${config.palette.peach.hex};
      @define-color red_1 ${config.palette.red.hex};
      @define-color red_2 ${config.palette.red.hex};
      @define-color red_3 ${config.palette.red.hex};
      @define-color red_4 ${config.palette.red.hex};
      @define-color red_5 ${config.palette.red.hex};
      @define-color purple_1 ${config.palette.mauve.hex};
      @define-color purple_2 ${config.palette.mauve.hex};
      @define-color purple_3 ${config.palette.mauve.hex};
      @define-color purple_4 ${config.palette.mauve.hex};
      @define-color purple_5 ${config.palette.mauve.hex};
      @define-color brown_1 ${config.palette.flamingo.hex};
      @define-color brown_2 ${config.palette.flamingo.hex};
      @define-color brown_3 ${config.palette.flamingo.hex};
      @define-color brown_4 ${config.palette.flamingo.hex};
      @define-color brown_5 ${config.palette.flamingo.hex};
      @define-color light_1 ${config.palette.mantle.hex};
      @define-color light_2 ${config.palette.mantle.hex};
      @define-color light_3 ${config.palette.mantle.hex};
      @define-color light_4 ${config.palette.mantle.hex};
      @define-color light_5 ${config.palette.mantle.hex};
      @define-color dark_1 ${config.palette.mantle.hex};
      @define-color dark_2 ${config.palette.mantle.hex};
      @define-color dark_3 ${config.palette.mantle.hex};
      @define-color dark_4 ${config.palette.mantle.hex};
      @define-color dark_5 ${config.palette.mantle.hex};
    '';
  };
  gtk4-vars = pkgs.writeTextFile {
    name = "gtk4-vars";
    text = ''
      :root {
        --accent-bg-color: @accent_bg_color;
        --accent-fg-color: @accent_fg_color;

        --destructive-bg-color: @destructive_bg_color;
        --destructive-fg-color: @destructive_fg_color;

        --success-bg-color: @success_bg_color;
        --success-fg-color: @success_fg_color;

        --warning-bg-color: @warning_bg_color;
        --warning-fg-color: @warning_fg_color;

        --error-bg-color: @error_bg_color;
        --error-fg-color: @error_fg_color;

        --window-bg-color: @window_bg_color;
        --window-fg-color: @window_fg_color;

        --view-bg-color: @view_bg_color;
        --view-fg-color: @view_fg_color;

        --headerbar-bg-color: @headerbar_bg_color;
        --headerbar-fg-color: @headerbar_fg_color;
        --headerbar-border-color: @headerbar_border_color;
        --headerbar-backdrop-color: @headerbar_backdrop_color;
        --headerbar-shade-color: @headerbar_shade_color;
        --headerbar-darker-shade-color: @headerbar_darker_shade_color;

        --sidebar-bg-color: @sidebar_bg_color;
        --sidebar-fg-color: @sidebar_fg_color;
        --sidebar-backdrop-color: @sidebar_backdrop_color;
        --sidebar-border-color: @sidebar_border_color;
        --sidebar-shade-color: @sidebar_shade_color;

        --secondary-sidebar-bg-color: @secondary_sidebar_bg_color;
        --secondary-sidebar-fg-color: @secondary_sidebar_fg_color;
        --secondary-sidebar-backdrop-color: @secondary_sidebar_backdrop_color;
        --secondary-sidebar-border-color: @secondary_sidebar_border_color;
        --secondary-sidebar-shade-color: @secondary_sidebar_shade_color;

        --card-bg-color: @card_bg_color;
        --card-fg-color: @card_fg_color;
        --card-shade-color: @card_shade_color;

        --dialog-bg-color: @dialog_bg_color;
        --dialog-fg-color: @dialog_fg_color;

        --popover-bg-color: @popover_bg_color;
        --popover-fg-color: @popover_fg_color;
        --popover-shade-color: @popover_shade_color;

        --thumbnail-bg-color: @thumbnail_bg_color;
        --thumbnail-fg-color: @thumbnail_fg_color;

        --shade-color: @shade_color;
        --scrollbar-outline-color: @scrollbar_outline_color;
      }
    '';
  };
in {
  catppuccin = {
    enable = true;
    flavor = "frappe";
    firefox.profiles = mkForce {};
    kvantum.enable = false;
    gtk = {
      enable = false;
      icon.enable = true;
      gnomeShellTheme = mkForce false;
    };
  };
  dconf.settings = mkForce {};
  gtk.enable = true;
  # https://git.gay/olivia/fur/src/branch/main/modules/home/theming/qt/default.nix
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };
  xdg.configFile = {
    "qt5ct/qt5ct.conf".text = qtct;
    "qt6ct/qt6ct.conf".text = qtct;
  };
  home.packages = [
    pkgs.kdePackages.breeze
    pkgs.kdePackages.breeze-icons
  ];
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    gtk3 = {
      extraCss = ''@import url("${colors}");'';
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    gtk4 = {
      extraCss = ''
        @import url("${colors}");
        @import url("${gtk4-vars}");
      '';
    };
  };
}
