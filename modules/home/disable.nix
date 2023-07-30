{modulesPath, ...}: {
  disabledModules = map (x: /. + "${toString modulesPath}/${x}") [];
}
