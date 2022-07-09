{ config, lib, ... }: with lib; {
  options = {
    hardware.bamboo.display = mkOption {
      type = types.str;
    };
    home-manager.users = let
        userBambooExtend = { config, nixos, ... }: {
          config = mkIf config.wayland.windowManager.sway.enable {
            wayland.windowManager.sway.config.input = {
              "1386:215:Wacom_BambooPT_2FG_Small_Pen" = {
                map_to_output = nixos.hardware.bamboo.display;
              };
              "1386:215:Wacom_BambooPT_2FG_Small_Finger" = {
                natural_scroll = "enabled";
                middle_emulation = "enabled";
                tap = "enabled";
                dwt = "enabled";
                accel_profile = "flat";
                pointer_accel = "0.05";
              };
            };
          };
        };
      in mkOption {
      type = types.attrsOf (types.submoduleWith {
        modules = singleton userBambooExtend;
      });
    };
  };
}
