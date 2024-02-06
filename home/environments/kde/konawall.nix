{
  inputs,
  pkgs,
  ...
}: let
  desktop_entry = ''
    [Desktop Entry]
    Exec=${inputs.konawall-py.packages.${pkgs.system}.konawall-py}/bin/konawall
    Icon=
    Name=konawall
    Path=
    Terminal=False
    Type=Application
  '';
  konawallConfig = {
    interval = 30 * 60;
    rotate = true;
    source = "konachan";
    tags = [
      "rating:s"
      "touhou"
      "score:>=50"
      "width:>=1500"
    ];
    logging = {
      file = "INFO";
      console = "DEBUG";
    };
  };
in {
  xdg.configFile = {
    "konawall/config.toml".source = (pkgs.formats.toml {}).generate "konawall-config" konawallConfig;
    "autostart/konawall.desktop".text = desktop_entry;
  };
}
