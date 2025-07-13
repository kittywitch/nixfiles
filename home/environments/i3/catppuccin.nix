{config, ...}: let
  inherit (config.catppuccin) sources;
  cfg = config.catppuccin.sway;
  theme = "${sources.sway}/catppuccin-${cfg.flavor}";
in {
  xsession.windowManager.i3.extraConfigEarly = ''
    ${builtins.readFile theme}
  '';
}
