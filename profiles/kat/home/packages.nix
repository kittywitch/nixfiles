{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.deploy.profile.kat {
    home.packages = with pkgs; [ kitty.terminfo hyperfine hexyl tokei ];
  };
}
