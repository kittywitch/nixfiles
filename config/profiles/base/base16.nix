{ config, ... }:

{
  base16 = {
    console = {
      enable = true;
      scheme = config.home-manager.users.kat.alias.default;
    };
  };
}
