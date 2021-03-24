{ pkgs, hostsDir ? ../hosts, privateHostsDir ? ../private/hosts
, commonImports ? [ ../nixos.nix ../modules/nixos ], pkgsPath ? ../pkgs
, sources ? { }, witch ? { } }:

with pkgs.lib;

rec {
  hostNames = attrNames
    (filterAttrs (name: type: type == "directory") (builtins.readDir hostsDir));

  hostConfig = hostName:
    { config, ... }: {
      _module.args = { inherit hosts groups; };
      imports = [
        (import (hostsDir + "/${hostName}/nixos"))
        (import (privateHostsDir + "/${hostName}/nixos"))
        ../modules/nixos/deploy
      ] ++ commonImports;
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
      specialArgs = { inherit sources witch hostName; };
    })) hostNames);

  groupNames = unique (concatLists
    (mapAttrsToList (name: host: host.config.deploy.groups) hosts));

  groups = listToAttrs (map (groupName:
    nameValuePair groupName
    (filter (host: elem groupName host.config.deploy.groups)
      (attrValues hosts))) groupNames);
}
