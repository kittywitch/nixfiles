{ config, lib, pkgs, ... }:

{
    home.packages = with pkgs; [ kitty.terminfo hyperfine hexyl tokei ];
}
