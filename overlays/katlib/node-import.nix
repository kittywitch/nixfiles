{ lib }: { nixosImports, homeImports, users, hostName, profiles }: with lib;

let
  importLists = {
    nixos = nixosImports;
    home = homeImports;
  };
  replacedLists = mapAttrs
    (_: fileList:
      map (builtins.replaceStrings [ "HN" ] [ "${hostName}" ]) fileList
    )
    importLists;
  homeScaffold = user: {
    home-manager.users.${user} = {
      imports = filter builtins.pathExists replacedLists.home;
    };
  };
  scaffoldedUsers = map homeScaffold users;
  baseProfile = if builtins.isAttrs profiles.base then profiles.base.imports else singleton profiles.base;
in
filter builtins.pathExists replacedLists.nixos ++ baseProfile ++ scaffoldedUsers
