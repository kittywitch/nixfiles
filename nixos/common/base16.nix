{config, ...}: {
  base16 = {
    inherit (config.home-manager.users.kat.base16) defaultSchemeName defaultScheme schemes;
    console = {
      enable = false;
      getty.enable = false;
    };
  };
}
