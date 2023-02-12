_: let
  hostConfig = {HOSTCONFIG};
in {
  arch = "{ARCHITECTURE}";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
