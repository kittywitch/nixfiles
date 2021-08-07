{ lib }: { folder, defaultFile ? "default.nix" }: with lib; let
  folderNames = [ (../../config + "/${folder}") (../../config/trusted + "/${folder}") ];
  folderModLists = map (folderName: modList {
    modulesDir = folderName;
    inherit defaultFile;
  }) (filter builtins.pathExists folderNames);
in foldl modListMerge { } folderModLists
