_: let
  hostConfig = {tree, ...}: {
    imports = with tree.home.profiles; [
      common
      neovim
      ci
    ];
  };
in {
  arch = "x86_64";
  type = "Home";
  ci.enable = true; # TODO: fix arcnmx/nixexprs overlay issue???
  modules = [
    hostConfig
  ];
}
