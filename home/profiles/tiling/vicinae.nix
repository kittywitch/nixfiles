{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    brotab
    oath-toolkit
  ];
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
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
