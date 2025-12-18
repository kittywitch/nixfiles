{ pkgs, std, lib, config, parent, inputs, ... }: let
  inherit (std) list;
  inherit (lib.meta) getExe' getExe;
in {
  home.packages = with pkgs; [
    grimblast
    wl-clipboard
    wlr-randr
    wl-screenrec
    slurp
    grim
    swww
    pavucontrol
    hyprpicker
    brightnessctl
    playerctl
    glib
    pcmanfm
  ];
  services = {
    swww.enable = true;
    hyprpolkitagent.enable = true;
    hyprpaper.enable = lib.mkForce false;
  };
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    plugins = [ inputs.hy3.packages.x86_64-linux.hy3 ];
    settings = let
    in {
      input = {
        kb_options = "ctrl:nocaps";
        accel_profile = "flat";
        sensitivity = 1.0;
        scroll_factor = 1.0;
      };
      cursor = {
        use_cpu_buffer = true;
      };
      env = [
        "MOZ_ENABLE_WAYLAND,1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "GDK_BACKEND,wayland,x11"
        "CLUTTER_BACKEND,wayland"
      ];
      render = {
        #direct_scanout = true;
        #new_render_scheduling = true;
      };
      misc = {
        vfr = true;
      };
      #debug.disable_logs = false;
      exec-once = [
        "${pkgs.swww}/bin/swww init"
        "${pkgs.dbus}/bin/dbus-update-activation-environment --all"
        "${pkgs.networkmanagerapplet}/bin/nm-applet"
        "${pkgs.udiskie}/bin/udiskie &"
        "${getExe' pkgs.systemd "systemctl"} restart konawall-py --user"
      ];
      xwayland = {
        force_zero_scaling = true;
      };
    };
  };
}
