{ pkgs, target, hostsDir ? ../hosts, profiles, pkgsPath ? ../pkgs, sources ? { }
, witch ? { } }:

with pkgs.lib;

rec {
  hostNames = attrNames
    (filterAttrs (name: type: type == "directory") (builtins.readDir hostsDir));

  hostConfig = hostName:
    { config, ... }: {
      _module.args = { inherit hosts targets; };
      imports = [ ../nixos.nix ../modules/nixos ];
      networking = { inherit hostName; };
      nixpkgs.pkgs = import pkgsPath {
        inherit (config.nixpkgs) config;
        inherit sources;
      };
    };

  hosts = listToAttrs (map (hostName:
    nameValuePair hostName (import (pkgs.path + "/nixos/lib/eval-config.nix") {
      modules = [
        (hostConfig hostName)
        (if sources ? home-manager then
          sources.home-manager + "/nixos"
        else
          { })
      ];
      specialArgs = { inherit sources target profiles witch hostName; };
    })) hostNames);

  targets = foldAttrs (host: hosts: [ host ] ++ hosts) [ ] (mapAttrsToList
    (hostName: host: { ${host.config.deploy.target} = hostName; }) hosts);
}
