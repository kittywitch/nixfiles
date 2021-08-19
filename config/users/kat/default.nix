let katUser = { lib }:
  let
    trustedImport = {
      config.home-manager.users.kat = {
        imports = lib.optional (builtins.pathExists ../../trusted/users/kat) (import ../../trusted/users/kat/home.nix);
      };
    };
    userImport = profile: { config, ... }: {
      config.home-manager.users.kat = {
        imports = [
          (./. + "/${profile}")
        ];
      };
    };
    serviceImport = profile: { config, ... }: {
      config.home-manager.users.kat = {
        imports = [
          (./services + "/${profile}")
        ];
      };
    };
    profileNames = lib.folderList ./. [ "base" "services" ];
    serviceNames = lib.folderList ./services [ ];
    userProfiles = with userProfiles;
      lib.genAttrs profileNames userImport // {
        services = lib.genAttrs serviceNames serviceImport;
        base = { imports = [ ./nixos.nix (userImport "base") trustedImport ]; };
        server = { imports = [ personal ]; };
        guiFull = { imports = [ gui sway dev media personal ]; };
      };
  in
  userProfiles;
in { __functor = self: katUser; isModule = false; }
