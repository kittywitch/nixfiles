{ config, ... }:

{
  base16 = {
    inherit (config.home-manager.users.kat.base16) schemes alias;
    console = {
      enable = true;
      scheme = config.home-manager.users.kat.base16.alias.default;
    };
  };
}
