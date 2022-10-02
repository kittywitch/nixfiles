{ config, lib, meta, ... }: with lib; {
  secrets.variables = lib.mkMerge (mapAttrsToList (username: user: user.secrets.variables) config.home-manager.users);
}
