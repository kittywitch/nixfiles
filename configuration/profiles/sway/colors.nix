rec {
  base16 = {
    color0 = "#333333";
    color1 = "#ff3399";
    color2 = "#00ff99";
    color3 = "#ffcc33";
    color4 = "#00ccff";
    color5 = "#9977ff";
    color6 = "#3cd8d8";
    color7 = "#f8f8f2";

    color8 = "#707070";
    color9 = "#ff6699";
    color10 = "#99ff99";
    color11 = "#ffee66";
    color12 = "#99ccff";
    color13 = "#9977ff";
    color14 = "#78e4e4";
    color15 = "#f8f8f2";

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
