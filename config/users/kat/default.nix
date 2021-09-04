{ lib, tree, ... }: with lib; let
  wrapImports = imports: mapAttrs
    (name: paths: { config, ... }: {
      config.home-manager.users.kat = {
        imports = if isAttrs paths then attrValues paths else singleton paths;
      };
    })
    imports;
  dirImports = wrapImports tree.dirs;
  serviceImports = wrapImports tree.dirs.services;
in
(removeAttrs dirImports (singleton "base")) // {
  base = {
    imports = [
      dirImports.base
      tree.files.nixos
    ];
  };
  server = { };
  guiFull = {
    imports = with dirImports; [
      gui
      sway
      dev
      media
      personal
    ];
  };
  services = serviceImports;
}
