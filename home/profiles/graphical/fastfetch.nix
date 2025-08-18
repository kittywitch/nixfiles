_: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "chafa";
        source = ./nixowos.png;
        height = 32;
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
        "chassis"
        "board"
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
        {
          type = "physicaldisk";
          temp = true;
        }
        "lm"
        "wm"
        "theme"
        "wmtheme"
        "icons"
        "font"
        "cursor"
        "terminal"
        "terminalfont"
        "terminalsize"
        "terminaltheme"
        "break"
        {
          type = "weather";
          timeout = 1000;
        }
        "dns"
        "break"
        "break"
        "bluetooth"
        "break"
        "player"
        "media"
        "break"
        "colors"
      ];
    };
  };
}
