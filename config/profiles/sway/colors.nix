rec {
  base16 = {
    color0 = "#2e3440";
    color1 = "#bf616a";
    color2 = "#a3be8c";
    color3 = "#ebcb8b";
    color4 = "#81a1c1";
    color5 = "#b48ead";
    color6 = "#88c0d0";
    color7 = "#e5e9f0";

    color8 = "#4c566a";
    color9 = "#d08770";
    color10 = "#3b4252";
    color11 = "#434c5e";
    color12 = "#d8dee9";
    color13 = "#eceff4";
    color14 = "#5e81ac";
    color15 = "#8fbcbb";

    color16 = "#fd971f";
    color17 = "#cc6633";
    color18 = "#383830";
    color19 = "#49483e";
    color20 = "#a59f85";
    color21 = "#f5f4f1";
  };

  black = base16.color0;
  red = base16.color1;
  green = base16.color2;
  yellow = base16.color3;
  blue = base16.color4;
  purple = base16.color5;
  cyan = base16.color6;
  white = base16.color7;

  normal.black = base16.color0;
  normal.red = base16.color1;
  normal.green = base16.color2;
  normal.yellow = base16.color3;
  normal.blue = base16.color4;
  normal.purple = base16.color5;
  normal.cyan = base16.color6;
  normal.white = base16.color7;

  bright.black = base16.color8;
  bright.red = base16.color9;
  bright.green = base16.color10;
  bright.yellow = base16.color11;
  bright.blue = base16.color12;
  bright.purple = base16.color13;
  bright.cyan = base16.color14;
  bright.white = base16.color15;
}
