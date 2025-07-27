{
lib,
config,
pkgs,
...
}:
#let
  #   theme = with config.lib.stylix.colors.withHashtag; pkgs.writeTextFile {
  #    name = "swayosd-css";
  #    text = ''
  #window#osd {
  #  padding: 12px 20px;
  #  border-radius: 999px;
  #  border: solid 2px ${base0D};
  #  background: alpha(${base01}, 0.99);
  #}
  #
  ##container {
  #  margin: 16px;
  #}
  #
  #image,
  #label {
  #  color: ${base05};
  #}
  #
  #progressbar:disabled,
  #image:disabled {
  #  opacity: 0.5;
  #}
  #
  #progressbar {
  #  min-height: 6px;
  #  border-radius: 999px;
  #  background: transparent;
  #  border: none;
  #}
  #
  #trough {
  #  min-height: inherit;
  #  border-radius: inherit;
  #  border: none;
  #  background: alpha(${base01},0.3);
  #}
  #
  #progress {
  #  min-height: inherit;
  #  border-radius: inherit;
  #  border: none;
  #  background: ${base01};
  #}
  #    '';
#};
#in
  {
  services.swayosd = {
    enable = true;
    #stylePath = theme;
  };
}
