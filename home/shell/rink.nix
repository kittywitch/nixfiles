{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    #rink-readline TODO: wait for fix
    rink
  ];

  xdg.configFile."rink/config.toml".text = lib.toTOML {
    colors = {
      enabled = true;
      theme = "my_theme";
    };
    currency = {
      cache_duration = "1h";
      enabled = true;
      endpoint = "https://rinkcalc.app/data/currency.json";
      timeout = "2s";
    };
    rink = {
      long_output = true;
      prompt = "> ";
    };
    themes = {
      my_theme = {
        date_time = "default";
        doc_string = "italic";
        error = "red";
        number = "default";
        plain = "default";
        pow = "default";
        prop_name = "cyan";
        quantity = "dimmed cyan";
        unit = "cyan";
        user_input = "bold";
      };
    };
  };
}
