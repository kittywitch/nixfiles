{ pkgs, config, lib, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    mumble.speechdSupport = true;
    pulseaudio = true;
  };
}
