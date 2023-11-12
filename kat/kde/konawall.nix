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
in {
  xdg.configFile."autostart/konawall.desktop".text = desktop_entry;
}
