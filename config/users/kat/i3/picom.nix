{ config, pkgs, lib, ... }: with lib; {
  services.picom = {
    enable = true;
    experimentalBackends = mkDefault true;
    package = mkDefault pkgs.picom-next;
    opacityRule = [
        # https://wiki.archlinux.org/index.php/Picom#Tabbed_windows_(shadows_and_transparency)
        "100:class_g = 'URxvt' && !_NET_WM_STATE@:32a"
        "0:_NET_WM_STATE@[0]:32a *= '_NET_WM_STATE_HIDDEN'"
        "0:_NET_WM_STATE@[1]:32a *= '_NET_WM_STATE_HIDDEN'"
        "0:_NET_WM_STATE@[2]:32a *= '_NET_WM_STATE_HIDDEN'"
        "0:_NET_WM_STATE@[3]:32a *= '_NET_WM_STATE_HIDDEN'"
        "0:_NET_WM_STATE@[4]:32a *= '_NET_WM_STATE_HIDDEN'"
      ];
      shadowExclude = [
        "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      ];
    };
  }
