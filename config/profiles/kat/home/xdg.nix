{ config, lib, ... }:

{
  config = lib.mkIf config.deploy.profile.kat {
    xdg.enable = true;
  };
}
