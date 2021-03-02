{ pkgs, hostsDir ? ../config/hosts,
privateHostsDir ? ../config/private/hosts
, commonImports ? [ ../config/common ../modules ], pkgsPath ? ../pkgs }:

with pkgs.lib;

rec {
  hostNames = attrNames
    (filterAttrs (name: type: type == "directory") (builtins.readDir hostsDir));

  hostConfig = hostName:
    { config, ... }: {
      _module.args = { inherit hosts profiles; };
      imports = [
        (import (hostsDir + "/${hostName}/configuration.nix"))
        (import (privateHostsDir + "/${hostName}/configuration.nix"))
        ../modules/deploy
      ] ++ commonImports;
      networking = { inherit hostName; };
      nixpkgs.pkgs = import pkgsPath { inherit (config.nixpkgs) config; };
    };

  hosts = listToAttrs (map (hostName:
    nameValuePair hostName
    (import (pkgs.path + "/nixos") { configuration = hostConfig hostName; }))
    hostNames);

  profileNames = unique (concatLists
    (mapAttrsToList (name: host: host.config.meta.deploy.profiles) hosts));

  profiles = listToAttrs (map (profileName:
    nameValuePair profileName
    (filter (host: elem profileName host.config.meta.deploy.profiles)
      (attrValues hosts))) profileNames);
}
