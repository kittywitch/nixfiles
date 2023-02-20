{pkgs, ...}: {
  services.spacebar = {
    enable = true;
    package = pkgs.spacebar;
    config = {
      # bar characteristics
      position = "top";
      display = "main";
      height = "26";

      # modules
      spaces = "on";
      space_icon_strip = "       8 9 10 11 12 13 14 15 16 17 18 19 20 21 22";
      spaces_for_all_displays = "on";
      title = "off";
      clock = "on";
      clock_icon = "";
      clock_format = ''"%F %R %Z"'';
      power = "on";
      dnd = "on";
      dnd_icon = "";
      power_icon_strip = " ";

      # display
      padding_left = 20;
      padding_right = 20;
      spacing_left = 15;
      spacing_right = 15;

      # text
      text_font = ''"Iosevka:Regular:12.0"'';
      icon_font = ''"Font Awesome 6 Free:Solid:12.0"'';
    };
  };
}
