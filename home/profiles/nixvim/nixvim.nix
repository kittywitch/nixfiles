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
  xdg.mimeApps.defaultApplications = {
    "text/plain" = "nvim.desktop";
  };
  programs.nixvim = {
    enable = true;
    defaultEditor = false;
    imports = [
      stdarg
      tree.nixvim
    ];
  };
}
