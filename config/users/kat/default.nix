let katUser = { lib }: let
  userImport = profile: { config, ... }: {
  config.home-manager.users.kat = {
    imports = [
      (./. + "/${profile}")
    ];
  };
}; profileNames = [
  "gui"
  "sway"
  "dev"
  "media"
  "personal"
]; userProfiles = with userProfiles;
  lib.genAttrs profileNames userImport // {
  base = { imports = [ ./nixos.nix (userImport "base") ];  };
  server = { imports = [ personal ]; };
  guiFull = { imports = [ gui sway dev media personal ]; };
}; in userProfiles;
in { __functor = self: katUser; isModule = false; }
