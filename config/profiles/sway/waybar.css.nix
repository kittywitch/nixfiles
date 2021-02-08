{ hextorgba, colors }:

''
   * {
    border: none;
    border-radius: 0;
    font-family: "Hack Nerd Font";
    font-size: 12px;
    min-height: 14px
   }

  #clock, #memory, #cpu, #temperature, #pulseaudio, #network, #mpd {
    margin-left: 8px;
    margin-right: 8px;
    padding-left: 8px;
    padding-right: 8px;
    transition: none;
    border-bottom: 2px solid ${colors.base16.color7};
    color: ${colors.base16.color7}
  }

  window#waybar { background: ${hextorgba colors.base16.color0} }

  #window {
    color: ${colors.base16.color7};
    padding-left: 16px;
    padding-right: 16px
  }

  #workspaces { padding: 0px 4px 0px 4px }

  #workspaces button {
    color: ${colors.base16.color7};
    background: ${hextorgba colors.base16.color11};
    font-size: 16px;
    margin: 0px 4px 0px 4px;
    border-bottom: 2px solid transparent;
    border-left: 1px solid ${colors.base16.color7};
    border-right: 1px solid ${colors.base16.color7}
  }

  #workspaces button:last-child { margin-right: 0px }

  #workspaces button.focused {
      color: ${colors.base16.color5};
      border-bottom-color: ${colors.base16.color5}
  }

  #workspaces button:hover {
    transition: none;
    box-shadow: inherit;
    text-shadow: inherit;
    color: ${colors.base16.color2};
    border-bottom-color: ${colors.base16.color2}
  }

  #mpd { border-color: #5af78e }
  #mpd.disconnected, #mpd.stopped { border-color: #282a36 }
  #network { border-color: ${colors.base16.color3} }
  #pulseaudio { border-color: ${colors.base16.color2} }
  #temperature { border-color: ${colors.base16.color4} }
  #cpu { border-color: ${colors.base16.color5} }
  #memory { border-color: ${colors.base16.color17} }
  #clock { border-color: ${colors.base16.color7} }
''
