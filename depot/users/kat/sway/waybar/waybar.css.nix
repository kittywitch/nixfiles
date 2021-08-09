{ hextorgba, base16, font }:

''
   * {
    border: none;
    border-radius: 0;
    font-family: "${font.name}";
    font-size: ${font.size_css};
    min-height: 14px;
    text-shadow: none;
    box-shadow: none;
   }

   #mode {
     padding-left: 4px;
     padding-right: 4px;
   }

  #clock, #memory, #cpu, #temperature, #pulseaudio, #network, #mpd, #backlight, #battery, #custom-weather, #custom-konawall, #custom-gpg-status, #idle_inhibitor {
    margin-left: 8px;
    margin-right: 8px;
    padding-left: 8px;
    padding-right: 8px;
    transition: none;
    background: ${base16.base02};
    border-left: 1px solid ${base16.base06};
    border-right: 1px solid ${base16.base06};
    color: ${base16.base07};
    border-bottom: 1px solid ${base16.base06};
  }

  window#waybar {
    background: ${hextorgba base16.base00 0.75};
    border-bottom: 1px solid ${base16.base06};
  }

  #tray {
    margin-left: 8px;
  }

  #window {
    color: ${base16.base06};
    padding: 0 8px;
    margin: 0 8px;
  }

  #workspaces {
    margin: 0 8px;
  }

  #workspaces button {
    color: ${base16.base06};
    background: ${base16.base02};
    font-size: 16px;
    border-right: 1px dashed ${base16.base06};
    border-bottom: 1px solid ${base16.base06};
  }

  #workspaces button:first-child {
    border-left: 1px solid ${base16.base05};
  }

  #workspaces button:last-child {
    border-right: 1px solid ${base16.base05};
  }

  #workspaces button.focused {
      color: ${base16.base07};
      background: ${base16.base0D}
  }

  #workspaces button:hover {
    transition: none;
    box-shadow: inherit;
    text-shadow: inherit;
    background: ${base16.base07};
    color: ${base16.base0D};
  }

  #custom-konawall.enabled { color: ${base16.base0E} }
  #custom-konawall.disabled { color: ${base16.base0D} }
  #idle_inhibitor.activated { color: ${base16.base0E} }
  #idle_inhibitor.deactivated { color: ${base16.base0D} }
  #custom-gpg-status.enabled { color: ${base16.base0B} }
  #custom-gpg-status.disabled { color: ${base16.base08} }
  #network { color: ${base16.base0C} }
  #custom-weather { color: ${base16.base00} }
  #pulseaudio { color: ${base16.base06} }
  #temperature { color: ${base16.base0B} }
  #battery { color: ${base16.base0C} }
  #backlight { color: ${base16.base0D} }
  #cpu { color: ${base16.base08} }
  #memory { color: ${base16.base09} }
  #clock { color: ${base16.base05} }
''
