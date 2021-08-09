{ lib }: { folder, defaultFile ? "default.nix" }: with lib; let
  folderNames = [ (../../depot + "/${folder}") (../../depot/trusted + "/${folder}") ];
  defaultFileFinal = if (defaultFile == "default.nix" && folder == "hosts") then
    "meta.nix"
  else defaultFile;
  folderModLists = map (folderName: modList {
    modulesDir = folderName;
    defaultFile = defaultFileFinal;
  }) (filter builtins.pathExists folderNames);
in foldl modListMerge { } folderModLists
