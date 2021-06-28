{ hextorgba, base16, font }:

''
   * {
    border: none;
    border-radius: 0;
    font-family: "${font.name}";
    font-size: ${font.size_css};
    min-height: 14px
   }

   #mode {
     padding-left: 4px;
     padding-right: 4px;
   }

  #clock, #memory, #cpu, #temperature, #pulseaudio, #network, #mpd, #backlight, #battery, #custom-weather, #custom-gpg-status, #idle_inhibitor {
    margin-left: 8px;
    margin-right: 8px;
    padding-left: 8px;
    padding-right: 8px;
    transition: none;
    background: ${base16.base02};
    border-left: 1px solid ${base16.base06};
    border-right: 1px solid ${base16.base06};
    color: ${base16.base05}
  }

  window#waybar {
    background: ${hextorgba base16.base00 0.9};
    border-bottom: 1px solid ${base16.base06};
  }

  #tray {
    margin-left: 8px;
  }

  #window {
    color: ${base16.base06};
    padding-left: 16px;
    padding-right: 16px
  }

  #workspaces { padding: 0px 4px 0px 4px }

  #workspaces button {
    color: ${base16.base04};
    background: ${base16.base02};
    font-size: 16px;
    margin: 0px 4px 0px 4px;
    border-left: 1px solid ${base16.base06};
    border-right: 1px solid ${base16.base06}
  }

  #workspaces button:last-child { margin-right: 0px }

  #workspaces button.focused {
      color: ${base16.base0A};
      border-color: ${base16.base0A}
  }

  #workspaces button:hover {
    transition: none;
    box-shadow: inherit;
    text-shadow: inherit;
    color: ${base16.base08};
    border-color: ${base16.base08}
  }

  #mpd, #idle_inhibitor { color: #5af78e }
  #mpd.disconnected, #mpd.stopped { color: #282a36 }
  #network { color: ${base16.base06} }
  #custom-weather { color: ${base16.base00} }
  #custom-gpg-status { color: ${base16.base09} }
  #pulseaudio { color: ${base16.base0A} }
  #temperature { color: ${base16.base0B} }
  #battery { color: ${base16.base0C} }
  #backlight { color: ${base16.base0D} }
  #cpu { color: ${base16.base0E} }
  #memory { color: ${base16.base0F} }
  #clock { color: ${base16.base05} }
''
