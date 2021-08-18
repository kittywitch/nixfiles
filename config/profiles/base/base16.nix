{ config, ... }:

{
  base16 = {
    console = {
      enable = true;
      scheme = config.home-manager.users.kat.base16.alias.default;
    };
  };
}
