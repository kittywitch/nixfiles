{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    config.programs.rofi.finalPackage
  ];
  programs.rofi = {
    enable = true;
    font = "Monaspace Krypton";
    terminal = "wezterm";
    plugins = with pkgs; [
      rofi-games
      rofimoji
      rofi-rbw
    ];
  };
}
