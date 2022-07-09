{ config, lib, profiles, root, ... }:

with lib;

{
  options = {
    lib = mkOption {
      type = types.attrsOf (types.attrsOf types.unspecified);
    };
    network.importing = {
      nixosImports = mkOption {
        type = types.listOf types.str;
      };
      darwinImports = mkOption {
        type = types.listOf types.str;
      };
      homeImports = mkOption {
        type = types.listOf types.str;
      };
      users = mkOption {
        type = types.listOf types.str;
      };
    };
  };
  config = {
    network.importing = {
      nixosImports = mkDefault (map (path: toString path) [
        (root + "/nodes/nixos/HN.nix")
        (root + "/nodes/nixos/HN/nixos.nix")
        (root + "/trusted/nodes/nixos/HN/nixos.nix")
      ]);
      darwinImports = mkDefault (map (path: toString path) [
        (root + "/nodes/darwin/HN.nix")
        (root + "/nodes/darwin/HN/darwin.nix")
        (root + "/trusted/nodes/darwin/HN/darwin.nix")
      ]);
      homeImports = mkDefault (map (path: toString path) [
        (root + "/nodes/nixos/HN/home.nix")
        (root + "/nodes/darwin/HN/home.nix")
        (root + "/trusted/nodes/HN/home.nix")
      ]);
      users = mkDefault (singleton "kat");
    };
    lib.kw.nixosImport = hostName: lib.nodeImport {
      inherit (config.network.importing) nixosImports homeImports users;
      inherit profiles hostName;
    };
    lib.kw.darwinImport = hostName: lib.nodeImport {
      nixosImports = config.network.importing.darwinImports;
      profiles = profiles // { base = {}; };
      inherit (config.network.importing) homeImports users;
      inherit hostName;
    };
    _module.args = { inherit (config.lib) kw; };
  };
}
