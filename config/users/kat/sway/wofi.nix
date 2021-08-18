{ config, lib, ... }:

{
  xdg.configFile."wofi/wofi.css".text = let base16 = config.kw.hexColors; in ''
    #scroll, #input {
      background: ${base16.base01};
      }

      window {
      font-family: ${config.kw.font.name};
      background: ${lib.hextorgba base16.base00 0.75};
      border-radius: 1em;
      font-size: ${config.kw.font.size_css};
      color: ${base16.base07};
      }

    #outer-box {
      margin: 1em;
      }

    #scroll {
      border: 1px solid ${base16.base03};
      }

    #input {
      border: 1px solid ${base16.base0C};
      margin: 1em;
      background: ${base16.base02};
      color: ${base16.base04};
      }

    #entry {
      border-bottom: 1px dashed ${base16.base04};
      padding: .75em;
      }

    #entry:selected {
      background-color: ${base16.base0D};
      }
  '';
}
