{
lib,
config,
pkgs,
...
}:
let
  theme = pkgs.writeTextFile {
    name = "swayosd-css";
    text = ''
window#osd {
  padding: 12px 20px;
  border-radius: 999px;
  border: solid 2px ${config.palette.${config.catppuccin.accent}.hex};
  background: alpha(${config.palette.base.hex}, 0.99);
}

#container {
  margin: 16px;
}

image,
label {
  color: ${config.palette.text.hex};
}

progressbar:disabled,
image:disabled {
  opacity: 0.5;
}

progressbar {
  min-height: 6px;
  border-radius: 999px;
  background: transparent;
  border: none;
}

trough {
  min-height: inherit;
  border-radius: inherit;
  border: none;
  background: alpha(${config.palette.${config.catppuccin.accent}.hex},0.3);
}

progress {
  min-height: inherit;
  border-radius: inherit;
  border: none;
  background: ${config.palette.${config.catppuccin.accent}.hex};
}
    '';
  };
in
  {
  services.swayosd = {
    enable = true;
    stylePath = theme;
  };
}
