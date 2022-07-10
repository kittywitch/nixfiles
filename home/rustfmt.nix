{ config, pkgs, ... }:

{
  programs.rustfmt = {
    enable = true;
    config = {
      hard_tabs = true;
      imports_granularity = "One";
    };
  };
}
