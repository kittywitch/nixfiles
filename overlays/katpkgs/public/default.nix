{
  akiflags = import ./akiflags;

  fusionpbx = import ./fusionpbx;
  fusionpbx-apps = import ./fusionpbx-apps;

  fusionpbxWithApps = { symlinkJoin, fusionpbx, ... }: apps: symlinkJoin {
    inherit (fusionpbx) version name;
    paths = [ fusionpbx ] ++ apps;
  };

  libreelec-dvb-firmware = import ./libreelec-dvb-firmware/default.nix;

  yggdrasil-held = import ./yggdrasil;
}
