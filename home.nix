{ pkgs, config, lib, ... }:

{
  imports = [ ./modules/home ./private/profile/home ];
}

