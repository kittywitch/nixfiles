{ config, pkgs, root, ... }: {
  runners.lazy = {
    file = root;
    args = [ "--show-trace" ];
  };
  deploy.targets.dummy.enable = false;
}
