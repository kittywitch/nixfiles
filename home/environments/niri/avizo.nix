{ config, ... }: {
  services.avizo = {
    enable = true;
    settings = {
      default = {
        block-count = 100;
        block-spacing = 0;
        border-radius = 8;
        border-width = 2;
        background = "rgba(${builtins.toString config.palette.mantle.rgb.r}, ${builtins.toString config.palette.mantle.rgb.g}, ${builtins.toString config.palette.mantle.rgb.b}, 1)";
        border-color = "rgba(${builtins.toString config.palette.${config.catppuccin.accent}.rgb.r}, ${
          builtins.toString config.palette.${config.catppuccin.accent}.rgb.g
        }, ${builtins.toString config.palette.${config.catppuccin.accent}.rgb.b}, 1)";
        bar-fg-color = "rgba(${builtins.toString config.palette.${config.catppuccin.accent}.rgb.r}, ${
          builtins.toString config.palette.${config.catppuccin.accent}.rgb.g
        }, ${builtins.toString config.palette.${config.catppuccin.accent}.rgb.b}, 1)";
        bar-bg-color = "rgba(${builtins.toString config.palette.mantle.rgb.r}, ${builtins.toString config.palette.mantle.rgb.g}, ${builtins.toString config.palette.mantle.rgb.b}, 1)";
      };
    };
  };
}
