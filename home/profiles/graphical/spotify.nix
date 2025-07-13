{
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in {
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      volumePercentage
      queueTime
      groupSession
    ];
    experimentalFeatures = true;
    windowManagerPatch = true;
    colorScheme = "CatppuccinMocha";
    theme =
      spicePkgs.themes.text
      // {
        additionalCss = ''
          :root {
            --font-family: 'Monaspace Krypton', monospace;
          }
        '';
      };
  };
}
