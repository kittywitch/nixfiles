{ config, ... }:

{
  deploy.profile.hardware.laptop = true;

  imports = [
    ./light.nix
  ];
}
