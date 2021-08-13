{ lib }: { folder, defaultFile ? "default.nix", folderPaths ? [ (../depot + "/${folder}") (../depot/trusted + "/${folder}") ] }: with lib; let
  defaultFileFinal = if (defaultFile == "default.nix" && folder == "hosts") then
    "meta.nix"
  else defaultFile;
  folderModLists = map (folderPath: modList {
    modulesDir = folderPath;
    defaultFile = defaultFileFinal;
  }) (filter builtins.pathExists folderPaths);
in foldl modListMerge { } folderModLists
