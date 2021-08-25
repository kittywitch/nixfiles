{ hextorgba, base16, font }:

let
  bcolor = color: ''
    background: ${hextorgba color 0.75};
  '';
in
''
   * {
    border: none;
    border-radius: 0;
    background: none;
    font-family: "${font.name}";
    font-size: ${font.size_css};
    min-height: 12px;
    text-shadow: none;
    box-shadow: none;
   }

   #mode {
    color: ${base16.base06};
    padding: 0 4px;
   }

  #clock, #memory, #cpu, #temperature, #pulseaudio, #network, #mpd, #backlight, #battery, #custom-weather, #custom-konawall, #custom-gpg-status, #idle_inhibitor, #tray {
    padding: 0 8px;
    transition: none;
    color: ${base16.base00};
  }

  .modules-left, .modules-center, .modules-right {
    margin: 2px 4px;
    border-radius: 1em;
  }

  .modules-left widget label {
    margin: 0 4px;
    border-radius: 1em;
  }

  .modules-left widget:first-child {
    margin-left: 0px;
  }

  .modules-left widget:last-child {
    margin-right: 0px;
  }

  #workspaces, #window, #clock, #tray {
    background: ${hextorgba base16.base00 0.75};
  }

  #workspaces {
    padding: 0px;
    border-radius: 1em;
  }

  #window {
    padding: 0 8px;
  }

  .modules-center widget:first-child label, .modules-right widget:first-child label, #workspaces button:first-child {
    border-top-left-radius: 1em;
    border-bottom-left-radius: 1em;
  }

  .modules-center widget:last-child label, .modules-right widget:last-child label, #workspaces button:last-child, #tray {
    border-top-right-radius: 1em;
    border-bottom-right-radius: 1em;
  }

  tooltip, #tray menu {
    background: ${hextorgba base16.base00 0.75};
    border-radius: 1em;
  }

  tooltip label {
    color: ${base16.base07};
  }

  #window {
    color: ${base16.base06};
    border-bottom: 2px solid transparent;
  }

  window#waybar.empty #window {
    opacity: 0;
  }

  #workspaces button {
    color: ${base16.base06};
  }

  #workspaces button.focused {
      color: ${base16.base07};
      background: ${base16.base0D};
  }

  #workspaces button:hover {
    transition: none;
    box-shadow: inherit;
    text-shadow: inherit;
    background: ${base16.base06};
    color: ${base16.base0C};
  }

  #tray { padding: 0 10px 0 8px }
  #clock { color: ${base16.base07} }
  #clock.arc { ${bcolor base16.base0B} }
  #clock.miku { ${bcolor base16.base0C} }
  #clock.hex { ${bcolor base16.base0F} }
  #custom-konawall.enabled { ${bcolor base16.base0E} }
  #custom-konawall.disabled { ${bcolor base16.base0D} }
  #idle_inhibitor.activated { ${bcolor base16.base0E} }
  #idle_inhibitor.deactivated { ${bcolor base16.base0D} }
  #custom-gpg-status.enabled { ${bcolor base16.base0B} }
  #custom-gpg-status.disabled { ${bcolor base16.base08} }
  #network { ${bcolor base16.base0C} }
  #custom-weather { ${bcolor base16.base00} }
  #pulseaudio { ${bcolor base16.base06} }
  #temperature { ${bcolor base16.base0B} }
  #pulseaudio.muted { ${bcolor base16.base03} }
  #battery { ${bcolor base16.base0C} }
  #backlight { ${bcolor base16.base0D} }
  #cpu { ${bcolor base16.base08} }
  #memory { ${bcolor base16.base09} }
''
