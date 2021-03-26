{ hextorgba, style }:

''
   * {
    border: none;
    border-radius: 0;
    font-family: "${style.font.name}";
    font-size: ${style.font.size_css};
    min-height: 14px
   }

  #clock, #memory, #cpu, #temperature, #pulseaudio, #network, #mpd, #backlight, #battery, #custom-weather, #custom-gpg-status, #idle_inhibitor, #tray {
    margin-left: 8px;
    margin-right: 8px;
    padding-left: 8px;
    padding-right: 8px;
    transition: none;
    border-bottom: 2px solid ${style.base16.color7};
    color: ${style.base16.color7}
  }

  window#waybar { background: ${hextorgba style.base16.color0} }

  #window {
    color: ${style.base16.color7};
    padding-left: 16px;
    padding-right: 16px
  }

  #workspaces { padding: 0px 4px 0px 4px }

  #workspaces button {
    color: ${style.base16.color7};
    background: ${hextorgba style.base16.color8};
    font-size: 16px;
    margin: 0px 4px 0px 4px;
    border-bottom: 2px solid transparent;
    border-left: 1px solid ${style.base16.color7};
    border-right: 1px solid ${style.base16.color7}
  }

  #workspaces button:last-child { margin-right: 0px }

  #workspaces button.focused {
      color: ${style.base16.color5};
      border-bottom-color: ${style.base16.color5}
  }

  #workspaces button:hover {
    transition: none;
    box-shadow: inherit;
    text-shadow: inherit;
    color: ${style.base16.color2};
    border-bottom-color: ${style.base16.color2}
  }

  #mpd, #idle_inhibitor { border-color: #5af78e }
  #mpd.disconnected, #mpd.stopped { border-color: #282a36 }
  #tray { border-color: ${style.base16.color19} }
  #network { border-color: ${style.base16.color3} }
  #custom-weather { border-color: ${style.base16.color14} }
  #custom-gpg-status { border-color: ${style.base16.color2} }
  #pulseaudio { border-color: ${style.base16.color2} }
  #temperature { border-color: ${style.base16.color4} }
  #battery { border-color: ${style.base16.color6} }
  #backlight { border-color: ${style.base16.color9} }
  #cpu { border-color: ${style.base16.color5} }
  #memory { border-color: ${style.base16.color17} }
  #clock { border-color: ${style.base16.color7} }
''
