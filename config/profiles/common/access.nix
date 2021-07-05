{ config, lib, pkgs, ... }:

{
  security.sudo.wheelNeedsPassword = lib.mkForce false;

  users.users.root = {
    openssh.authorizedKeys.keys = with pkgs.lib;
      concatLists (mapAttrsToList
        (name: user:
          if elem "wheel" user.extraGroups then
            user.openssh.authorizedKeys.keys
          else
            [ ])
        config.users.users);
  };
}
