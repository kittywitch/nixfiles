{ pkgs, config, lib, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    pulseaudio = true;
  };
}
