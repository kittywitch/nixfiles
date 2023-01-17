{modulesPath, ...}: {
  disabledModules = map (x: /. + "${toString modulesPath}/${x}") ["programs/neovim.nix"];
}
