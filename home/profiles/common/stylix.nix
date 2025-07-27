{ pkgs, ... }: {
  stylix = {
    enable = true;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 32;
    };
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
  };
}
