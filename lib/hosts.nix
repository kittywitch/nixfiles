{ 
  pkgs, 
  hostsDir ? ../config/hosts, 
  privateHostsDir ? ../config/private/hosts, 
  commonImports ? [ ../config/common ../modules/nixos ], 
  pkgsPath ? ../pkgs,
  sources ? {},
  witch ? {}
}:

with pkgs.lib;

rec {
  hostNames = attrNames
    (filterAttrs (name: type: type == "directory") (builtins.readDir hostsDir));

  hostConfig = hostName: { config, ... }: {
    _module.args = {
      inherit hosts profiles;
    };
    imports = [
      (import (hostsDir + "/${hostName}/configuration.nix"))
      (import (privateHostsDir + "/${hostName}/configuration.nix"))
      ../modules/nixos/deploy
    ] ++ commonImports;
    networking = {
      inherit hostName;
    };
    nixpkgs.pkgs = import pkgsPath { inherit (config.nixpkgs) config; inherit sources; };
  };


  hosts = listToAttrs (
    map (
      hostName: nameValuePair hostName (
        import (pkgs.path + "/nixos/lib/eval-config.nix") {
          modules = [
            (hostConfig hostName)
            (if sources ? home-manager then sources.home-manager + "/nixos" else {})
          ];
          specialArgs = { inherit sources witch; };
        }
      )
    ) hostNames
  );

  profileNames = unique (concatLists
    (mapAttrsToList (name: host: host.config.deploy.profiles) hosts));

  profiles = listToAttrs (map (profileName:
    nameValuePair profileName
    (filter (host: elem profileName host.config.deploy.profiles)
      (attrValues hosts))) profileNames);
}
