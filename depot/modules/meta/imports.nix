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
        (root + "/depot/hosts/HN/nixos.nix")
        (root + "/depot/trusted/hosts/HN/nixos.nix")
      ]);
      homeImports = mkDefault (map (path: toString path) [
        (root + "/depot/hosts/HN/home.nix")
        (root + "/depot/trusted/hosts/HN/home.nix")
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
