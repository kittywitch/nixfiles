{ hextorgba, style }:

''
   * {
    border: none;
    border-radius: 0;
    font-family: "${style.font.name}";
    font-size: ${style.font.size_css};
    min-height: 14px
   }

  #clock, #memory, #cpu, #temperature, #pulseaudio, #network, #mpd, #backlight, #battery, #custom-weather, #custom-gpg-status, #idle_inhibitor {
    margin-left: 8px;
    margin-right: 8px;
    padding-left: 8px;
    padding-right: 8px;
    transition: none;
    border-bottom: 2px solid ${style.base16.base00};
    color: ${style.base16.base05}
  }

  window#waybar { background: ${hextorgba style.base16.base00} }

  #tray {
    margin-left: 8px;
  }

  #window {
    color: ${style.base16.base06};
    padding-left: 16px;
    padding-right: 16px
  }

  #workspaces { padding: 0px 4px 0px 4px }

  #workspaces button {
    color: ${style.base16.base04};
    background: ${hextorgba style.base16.base02};
    font-size: 16px;
    margin: 0px 4px 0px 4px;
    border-bottom: 2px solid transparent;
    border-left: 1px solid ${style.base16.base07};
    border-right: 1px solid ${style.base16.base07}
  }

  #workspaces button:last-child { margin-right: 0px }

  #workspaces button.focused {
      color: ${style.base16.base0A};
      border-bottom-color: ${style.base16.base0A}
  }

  #workspaces button:hover {
    transition: none;
    box-shadow: inherit;
    text-shadow: inherit;
    color: ${style.base16.base0F};
    border-bottom-color: ${style.base16.base0F}
  }

  #mpd, #idle_inhibitor { border-color: #5af78e }
  #mpd.disconnected, #mpd.stopped { border-color: #282a36 }
  #network { border-color: ${style.base16.base08} }
  #custom-weather { border-color: ${style.base16.base00} }
  #custom-gpg-status { border-color: ${style.base16.base09} }
  #pulseaudio { border-color: ${style.base16.base0A} }
  #temperature { border-color: ${style.base16.base0B} }
  #battery { border-color: ${style.base16.base0C} }
  #backlight { border-color: ${style.base16.base0D} }
  #cpu { border-color: ${style.base16.base0E} }
  #memory { border-color: ${style.base16.base0F} }
  #clock { border-color: ${style.base16.base06} }
''
