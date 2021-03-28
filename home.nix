{ pkgs, config, lib, witch, ... }:

{
  imports = [ ./modules/home ./private/profile/home ];
}

