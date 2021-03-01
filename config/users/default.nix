{ pkgs, config, ... }:

{
  imports = [ ./kat ];

  users.users.root = {
    openssh.authorizedKeys.keys = with pkgs.lib; concatLists (mapAttrsToList (name: user: if elem "wheel" user.extraGroups then user.openssh.authorizedKeys.keys else []) config.users.users);
  };
}
