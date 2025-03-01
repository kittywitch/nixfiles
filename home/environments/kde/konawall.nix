{
  inputs,
  pkgs,
  ...
}: let
  konawallWithDelay = pkgs.writeShellScriptBin "konawally" ''
    sleep 5 && XDG_BACKEND=x11 GDK_BACKEND=x11 ${inputs.konawall-py.packages.${pkgs.system}.konawall-py}/bin/konawall
  '';
  desktop_entry = ''
    [Desktop Entry]
    Exec=${konawallWithDelay}/bin/konawally
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
      #"rating:s"
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
  home.packages = [
    konawallWithDelay
    inputs.konawall-py.packages.${pkgs.system}.konawall-py
  ];
  xdg.configFile = {
    "konawall/config.toml".source = (pkgs.formats.toml {}).generate "konawall-config" konawallConfig;
    "autostart/konawall.desktop".text = desktop_entry;
  };
}
