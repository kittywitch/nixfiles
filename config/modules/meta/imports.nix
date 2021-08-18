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
        (root + "/config/hosts/HN/nixos.nix")
        (root + "/config/trusted/hosts/HN/nixos.nix")
      ]);
      homeImports = mkDefault (map (path: toString path) [
        (root + "/config/hosts/HN/home.nix")
        (root + "/config/trusted/hosts/HN/home.nix")
      ]);
      users = mkDefault (singleton "kat");
    };
    lib.kw.nodeImport = hostName: lib.nodeImport {
      inherit (config.network.importing) nixosImports homeImports users;
      inherit profiles hostName;
    };

    _module.args = { inherit (config.lib) kw; };
  };
}
