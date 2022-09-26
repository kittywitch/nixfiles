{ config, lib, meta, root, ... }:

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
      esphomeImports = mkOption {
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
        (root + "/nixos/systems/HN.nix")
        (root + "/nixos/systems/HN/nixos.nix")
      ]);
      esphomeImports = mkDefault (map (path: toString path) [
        (root + "/esphome/HN.nix")
        (root + "/esphome/HN/esphome.nix")
      ]);
      darwinImports = mkDefault (map (path: toString path) [
        (root + "/darwin/systems/HN.nix")
        (root + "/darwin/systems/HN/darwin.nix")
      ]);
      homeImports = [];
      users = mkDefault (singleton "kat");
    };
    lib.kw.nixosImport = hostName: lib.nodeImport {
      inherit (config.network.importing) nixosImports homeImports users;
      profiles = meta.nixos;
      inherit hostName;
    };
    lib.kw.esphomeImport = hostName: lib.nodeImport {
      nixosImports = config.network.importing.esphomeImports;
      homeImports = [];
      users = [];
      profiles = { base = { }; };
      inherit hostName;
    };
    lib.kw.darwinImport = hostName: lib.nodeImport {
      nixosImports = config.network.importing.darwinImports;
      profiles = meta.darwin;
      inherit (config.network.importing) homeImports users;
      inherit hostName;
    };
    _module.args = { inherit (config.lib) kw; };
  };
}
