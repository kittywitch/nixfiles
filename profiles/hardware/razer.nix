{ config, lib, ... }: with lib; {
  options = {
    home-manager.users = let
        userRazerExtend = { config, nixos, ... }: {
          config = mkIf (config.wayland.windowManager.sway.enable && nixos.hardware.openrazer.enable) {
            wayland.windowManager.sway.config.input = {
              "5426:103:Razer_Razer_Naga_Trinity" = {
                accel_profile = "adaptive";
                pointer_accel = "-0.5";
              };
            };
          };
        };
      in mkOption {
      type = types.attrsOf (types.submoduleWith {
        modules = singleton userRazerExtend;
      });
    };
  };
}
