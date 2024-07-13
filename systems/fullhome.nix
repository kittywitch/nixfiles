_: let
  hostConfig = {
    lib,
    tree,
    modulesPath,
    ...
  }: let
    inherit (lib.modules) mkDefault;
  in {
    imports =
      with tree.home.profiles; [
        common
      ];
    home-manager.users.kat = {
        imports = with tree.home.profiles; [
        devops
        graphical
        neovim
        shell
        ];
    };
  };
in {
  arch = "x86_64";
  type = "Home";
  modules = [
    hostConfig
  ];
}
