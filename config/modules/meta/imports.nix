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
        (root + "/config/nodes/nixos/HN.nix")
        (root + "/config/nodes/nixos/HN/nixos.nix")
        (root + "/config/trusted/nodes/nixos/HN/nixos.nix")
      ]);
      darwinImports = mkDefault (map (path: toString path) [
        (root + "/config/nodes/darwin/HN.nix")
        (root + "/config/nodes/darwin/HN/darwin.nix")
        (root + "/config/trusted/nodes/darwin/HN/darwin.nix")
      ]);
      homeImports = mkDefault (map (path: toString path) [
        (root + "/config/nodes/nixos/HN/home.nix")
        (root + "/config/nodes/darwin/HN/home.nix")
        (root + "/config/trusted/nodes/HN/home.nix")
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
