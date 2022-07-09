{ config, lib, nixos, ... }: with lib; {
  options.hardware.displays = mkOption {
    type = with types; attrsOf (submodule ({ config, ... }: {
      options = {
        pos = mkOption {
          type = types.str;
        };
        res = mkOption {
          type = types.str;
        };
      };
    }));
  };
  config = mkMerge [
    {
      hardware.displays = nixos.hardware.displays;
    }
    (mkIf config.wayland.windowManager.sway.enable {
      wayland.windowManager.sway.config.output = config.hardware.displays;
    })
  ];
}
