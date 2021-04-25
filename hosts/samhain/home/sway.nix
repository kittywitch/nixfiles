{ config, pkgs, ... }: {
  wayland.windowManager.sway.config.startup =
    [{ command = "${pkgs.ckb-next}/bin/ckb-next -b"; }];
}
