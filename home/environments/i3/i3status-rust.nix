_: {
  programs.i3status-rust = {
    enable = true;
    bars = {
      # YOU! I WANNA TAKE YOU TO A
      gaybar = {
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
            block = "time";
            interval = 1;
            format = " $icon $timestamp.datetime(f:'%F %T %Z') ";
          }
        ];
        theme = "ctp-latte";
        icons = "awesome6";
      };
    };
  };
}
