{pkgs, ...}: {
  programs.i3status-rust = {
    enable = true;
    bars = {
      # YOU! I WANNA TAKE YOU TO A
      gaybar = {
        settings = {
          icons = {
            icons = "awesome6";
            overrides = {
              caffeine_on = "";
              caffeine_off = "";
            };
          };
        };
        blocks = [
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "load";
            interval = 1;
            format = " $icon $1m ";
          }
          {
            block = "memory";
            format = " $icon $mem_used_percents.eng(w:2) $zram_comp_ratio ";
          }
          {
            block = "memory";
            format = " $icon_swap $swap_used_percents.eng(w:2) ";
          }
          {
            block = "nvidia_gpu";
            format = " $icon $utilization $memory $temperature ";
          }
          {
            block = "hueshift";
          }
          {
            block = "music";
            format = " $icon {$combo.str(max_w:60) $play |}";
          }
          {
            block = "sound";
            format = " $icon {$volume.eng(w:2) |}";
          }
          {
            block = "notify";
            format = " $icon {($notification_count.eng(w:1)) |}";
          }
          {
            block = "toggle";
            command_on = "${pkgs.xorg.xset}/bin/xset -dpms";
            command_off = "${pkgs.xorg.xset}/bin/xset +dpms";
            format = " $icon DPMS ";
            command_state = ''${pkgs.xorg.xset}/bin/xset q | ${pkgs.gnugrep}/bin/grep -F "DPMS is Disabled"'';
            icon_on = "caffeine_on";
            icon_off = "caffeine_off";
            state_on = "info";
          }
          {
            block = "time";
            interval = 1;
            format = " $icon $timestamp.datetime(f:'%F %T %Z') ";
          }
        ];
        theme = "ctp-latte";
      };
    };
  };
}
