{ pkgs, config, lib, ... }:

{
  imports = [ ./modules/home ]
  ++ lib.optional (builtins.pathExists (./private/profile/home)) (import ./private/profile/home);
}

