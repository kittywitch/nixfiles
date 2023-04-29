{
  config,
  lib,
  meta,
  root,
  ...
}:
with lib; {
  options = {
    lib = mkOption {
      type = types.attrsOf (types.attrsOf types.unspecified);
    };
    network.importing = {
      nixosImports = mkOption {
        type = types.listOf types.str;
      };
    };
  };
  config = {
    network.importing = {
      nixosImports = mkDefault (map (path: toString path) [
        (root + "/nixos/systems/HN.nix")
        (root + "/nixos/systems/HN/nixos.nix")
      ]);
    };
    lib.nixfiles.nixosImport = hostName:
      lib.nodeImport {
        inherit (config.network.importing) nixosImports;
        profiles = meta.nixos;
        homeImports = [];
        users = [];
        inherit hostName;
      };
    _module.args = {inherit (config.lib) nixfiles;};
  };
}
