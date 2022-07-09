{ config, lib, pkgs, tf, ... }: {
  home.sessionVariables = {
    HEDGEDOC_SERVER = "https://md.kittywit.ch";
    HEDGEDOC_CONFIG_DIR = "${config.home.homeDirectory}/.config/hedgedoc";
  };

  home.packages = with pkgs; [
    hedgedoc-cli
  ];
}
