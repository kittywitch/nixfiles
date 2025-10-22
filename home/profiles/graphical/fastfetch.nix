_: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        padding = {
          right = 2;
        };
      };
      display = {
        size = {
          binaryPrefix = "si";
        };
        color = "magenta";
        separator = "  ";
      };
      modules = [
        {
          type = "datetime";
          key = "Date";
          format = "{1}-{3}-{11}";
        }
        {
          type = "datetime";
          key = "Time";
          format = "{14}:{17}:{20}";
        }
        "break"
        "title"
        "break"
        "os"
        "kernel"
        "bootmgr"
        "uptime"
        {
          type = "battery";
          format = "{/4}{-}{/}{4}{?5} [{5}]{?}";
        }
        "break"
        "shell"
        "display"
        "terminal"
        "break"
        {
          type = "cpu";
          showPeCoreCount = true;
          temp = true;
        }
        {
          type = "gpu";
          key = "GPU";
          temp = true;
        }
        "monitor"
        "memory"
        {
          type = "swap";
          separate = true;
        }
        "break"
        "disk"
        "zpool"
        "lm"
        "wm"
        "theme"
        "wmtheme"
        "icons"
        "cursor"
      ];
    };
  };
}
