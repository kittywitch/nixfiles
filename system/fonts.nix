{ config, pkgs, ... }: {
  fonts.fonts = with pkgs; [
    cantarell-fonts
    font-awesome
    cozette
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ] ++ map (variant: iosevka-bin.override { inherit variant; } ) [ "" "ss10" "aile" ];
}
