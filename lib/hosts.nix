{ pkgs
, target
, users
, hostsDir ? ../hosts
, profiles
, pkgsPath ? ../pkgs
, sources ? { }
, system ? builtins.currentSystem
}:

with pkgs.lib;

rec {
  baseModules = import (pkgs.path + "/nixos/modules/module-list.nix");

  hostNames = attrNames
    (filterAttrs (name: type: type == "directory") (builtins.readDir hostsDir));

  hostConfig = hostName:
    { config, ... }: {
      _module.args = { inherit hosts targets; };
      imports = [ ../nixos.nix ../modules/nixos ];
      networking = { inherit hostName; };
      nixpkgs.pkgs = pkgs;
    };

  hosts = listToAttrs (map
    (hostName:
    nameValuePair hostName (evalModules {
        modules = baseModules ++ [
          (hostConfig hostName)
          ({ config, ... }: {
            config._module.args.pkgs = pkgs;
            config.nixpkgs.system = mkDefault system;
            config.nixpkgs.initialSystem = system;
          })
          (if sources ? home-manager then
            sources.home-manager + "/nixos"
          else
            { })
          ];
          args = {
            inherit baseModules modules;
          };
          specialArgs = {
            modulesPath = builtins.toString pkgs.path + "/nixos/modules";
            inherit sources target profiles hostName users;
          };
      }))
    hostNames);

  targets = filterAttrs (targetName: _: targetName != "") (foldAttrs (host: hosts: [ host ] ++ hosts) [ ] (mapAttrsToList
    (hostName: host: { ${host.config.deploy.target} = hostName; })
    hosts));
}
