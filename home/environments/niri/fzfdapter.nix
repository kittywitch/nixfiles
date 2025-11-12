{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib.meta) getExe getExe';
  inherit (inputs.fzfdapter.packages.${pkgs.system}) fzfdapter;
  terminal_exec = args: "${getExe pkgs.alacritty}${
    if args != ""
    then " ${args} "
    else " "
  }-e";
in {
  home.packages = [
    fzfdapter
    pkgs.skim
  ];

  xdg.configFile."fzfdapter/config.toml".source = (pkgs.formats.toml {}).generate "fzfdapter-config" {
    terminal_exec = terminal_exec "";
    fuzzy_exec = "${getExe' pkgs.skim "sk"} --layout=reverse-list";
  };

  # TODO: `niri msg focused-output` to handle resolution(s)
  programs.niri.settings = let
    sh = config.lib.niri.actions.spawn "sh" "-c";
  in {
    binds = {
      "Mod+D".action = sh "${terminal_exec "-T fzfdapter --option 'font.size=18' --class fzfdapter"} ${getExe fzfdapter} --mode all";
    };
    window-rules = [
      {
        matches = [
          {
            app-id = "^fzfdapter$";
            title = "fzfdapter";
          }
        ];
        max-height = 1000;
        max-width = 750;
        min-height = 1000;
        min-width = 750;
        open-focused = true;
        open-floating = true;
      }
    ];
  };
}
