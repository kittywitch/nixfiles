{
  pkgs,
  inputs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    brotab
    oath-toolkit
  ];
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
    settings = {
      font.family = config.stylix.fonts.sansSerif.name;
      font.size = config.stylix.fonts.sizes.popups;
      theme.name = "catppuccin-macchiato";
      window = {
        csd = false;
        opacity = config.stylix.opacity.popups;
        rounding = 5;
      };
    };
    extensions =
      (with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
        bluetooth
        nix
        mullvad
        player-pilot
        wifi-commander
        ssh
        niri
        brotab
      ])
      ++ [
        (inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.mkVicinaeExtension rec {
          pname = "vicinae-rbw";
          src = inputs.${pname}.outPath;
        })
      ];
  };
}
