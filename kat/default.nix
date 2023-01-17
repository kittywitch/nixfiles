{tree,lib,...}: let
  inherit (lib.attrsets) mapAttrs;
  wrapImports = imports: mapAttrs
    (_: paths: { config, ... }: {
      config.home-manager.users.kat = {
        imports = lib.singleton paths;
      };
    })
    imports;
  dirImports = wrapImports tree.prev;
in
tree.prev
// {
  common = {
    imports = with tree.prev; [
      base16
      shell
      neovim
    ];
  };
  work = {
    imports = with dirImports; [
      wezterm
      gpg
    ];
  };
}
