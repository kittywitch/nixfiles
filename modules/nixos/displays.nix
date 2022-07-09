{ config, lib, ... }: with lib; {
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
}
