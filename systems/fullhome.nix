_: let
  hostConfig = {tree, ...}: {
    imports = with tree.home.profiles; [
      common
      devops
      graphical
      neovim
      shell
    ];
  };
in {
  arch = "x86_64";
  type = "Home";
  ci.enable = false; # TODO: fix arcnmx/nixexprs overlay issue???
  modules = [
    hostConfig
  ];
}
