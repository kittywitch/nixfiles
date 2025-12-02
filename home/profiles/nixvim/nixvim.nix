{
  tree,
  std,
  ...
}: let
  stdarg = _: {
    _module.args = {
      inherit std;
    };
  };
in {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    imports = [
      stdarg
      tree.nixvim
    ];
  };
}
