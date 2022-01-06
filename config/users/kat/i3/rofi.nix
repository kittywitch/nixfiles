{ config, base16, lib, pkgs, ... }: with lib; {
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    font = "${config.kw.theme.font.name} 9";
    theme = let
  # Use `mkLiteral` for string-like values that should show without
  # quotes, e.g.:
  # {
  #   foo = "abc"; => foo: "abc";
  #   bar = mkLiteral "abc"; => bar: abc;
  # };
  inherit (config.lib.formats.rasi) mkLiteral;
  base = base16.map (c: "rgba (${toString c.red.byte}, ${toString c.green.byte}, ${toString c.blue.byte}, ${toString (c.alpha.dec * 100)} % )");
  baset = base16.map (c: "rgba (${toString c.red.byte}, ${toString c.green.byte}, ${toString c.blue.byte}, 70% )");
    in {
      "*" = {
        red = mkLiteral base.variable;
        blue = mkLiteral base.function;
        lightfg = mkLiteral base.foreground_alt;
        lightbg = mkLiteral base.background_light;
        foreground = mkLiteral base.foreground;
        background = mkLiteral base.background;
        background-color = mkLiteral baset.background;
        separatorcolor = mkLiteral "@foreground";
        border-color = mkLiteral "@foreground";
        selected-normal-foreground = mkLiteral "@lightbg";
        selected-normal-background = mkLiteral "@lightfg";
        selected-active-foreground = mkLiteral "@background";
        selected-active-background = mkLiteral "@blue";
        selected-urgent-foreground = mkLiteral "@background";
        selected-urgent-background = mkLiteral "@red";
        normal-foreground = mkLiteral "@foreground";
        normal-background = mkLiteral "@background";
        active-foreground = mkLiteral "@blue";
        active-background = mkLiteral "@background";
        urgent-foreground = mkLiteral "@red";
        urgent-background = mkLiteral "@background";
        alternate-normal-foreground = mkLiteral "@foreground";
        alternate-normal-background = mkLiteral "@lightbg";
        alternate-active-foreground = mkLiteral "@blue";
        alternate-active-background = mkLiteral "@lightbg";
        alternate-urgent-foreground = mkLiteral "@red";
        alternate-urgent-background = mkLiteral "@lightbg";
      };
      window = {
        background-color = mkLiteral "@background";
        border = mkLiteral "1";
        padding = mkLiteral "5";
      };
      mainbox = {
        border = mkLiteral "0";
        padding = mkLiteral "0";
      };
      message = {
        border = mkLiteral "1px dash 0px 0px";
        border-color = mkLiteral "@separatorcolor";
        padding = mkLiteral "1px";
      };
      textbox = {
        text-color = mkLiteral "@foreground";
      };
      listview = {
        fixed-height = mkLiteral "0";
        border = mkLiteral "2px dash 0px 0px";
        border-color = mkLiteral "@separatorcolor";
        spacing = mkLiteral "2px";
        scrollbar = mkLiteral "true";
        padding = mkLiteral "2px 0px 0px";
      };
      "element-text, element-icon" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      element = {
        border = mkLiteral "0";
        padding = mkLiteral "1px";
      };
      "element normal.normal"= {
        background-color = mkLiteral "@normal-background";
        text-color = mkLiteral "@normal-foreground";
      };
      "element normal.urgent" = {
        background-color = mkLiteral "@urgent-background";
        text-color = mkLiteral "@urgent-foreground";
      };
      "element normal.active" = {
        background-color = mkLiteral "@active-background";
        text-color = mkLiteral "@active-foreground";
      };
      "element selected.normal" = {
        background-color = mkLiteral "@selected-normal-background";
        text-color = mkLiteral "@selected-normal-foreground";
      };
      "element selected.urgent" = {
        background-color = mkLiteral "@selected-urgent-background";
        text-color = mkLiteral "@selected-urgent-foreground";
      };
      "element selected.active" = {
        background-color = mkLiteral "@selected-active-background";
        text-color = mkLiteral "@selected-active-foreground";
      };
      "element alternate.normal" = {
        background-color = mkLiteral "@alternate-normal-background";
        text-color = mkLiteral "@alternate-normal-foreground";
      };
      "element alternate.urgent" = {
        background-color = mkLiteral "@alternate-urgent-background";
        text-color = mkLiteral "@alternate-urgent-foreground";
      };
      "element alternate.active" = {
        background-color = mkLiteral "@alternate-active-background";
        text-color = mkLiteral "@alternate-active-foreground";
      };
      scrollbar = {
        width = mkLiteral "4px";
        border = mkLiteral "0";
        handle-color = mkLiteral "@normal-foreground";
        handle-width = mkLiteral "8px";
        padding = mkLiteral "0";
      };
      sidebar = {
        border = mkLiteral "2px dash 0px 0px";
        border-color = mkLiteral "@separatorcolor";
      };
      button = {
        spacing = mkLiteral "0";
        text-color = mkLiteral "@normal-foreground";
      };
      "button selected" = {
        background-color = mkLiteral "@selected-normal-background";
        text-color = mkLiteral "@selected-normal-foreground";
      };
      inputbar = {
        spacing = mkLiteral "0px";
        text-color = mkLiteral "@normal-foreground";
        padding = mkLiteral "1px";
        children = map mkLiteral [ "prompt" "textbox-prompt-colon" "entry" "case-indicator" ];
      };
      case-indicator = {
        spacing = mkLiteral "0";
        text-color = mkLiteral "@normal-foreground";
      };
      entry = {
        spacing = mkLiteral "0";
        text-color = mkLiteral "@normal-foreground";
      };
      prompt = {
        spacing = mkLiteral "0";
        text-color = mkLiteral "@normal-foreground";
      };
      textbox-prompt-colon = {
        expand = mkLiteral "false";
        str = mkLiteral ''":"'';
        margin = mkLiteral "0px 0.3000em 0.0000em 0.0000em";
        text-color = mkLiteral "inherit";
      };
    };
  };
}
