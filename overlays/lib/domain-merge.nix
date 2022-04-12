{ lib }: { folder, defaultFile ? "default.nix", folderPaths ? [ ] }: with lib; let
  defaultFileFinal =
    if (defaultFile == "default.nix" && folder == "hosts") then
      "nixos.nix"
    else defaultFile;
  folderModLists = map
    (folderPath: modList {
      modulesDir = folderPath;
      defaultFile = defaultFileFinal;
    })
    (filter builtins.pathExists folderPaths);
in
foldl modListMerge { } folderModLists
