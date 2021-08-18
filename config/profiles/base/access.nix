{ config, lib, pkgs, ... }:

{
  security.sudo.wheelNeedsPassword = lib.mkForce false;

  users.users.root = {
    hashedPassword =
      "$6$i28yOXoo$/WokLdKds5ZHtJHcuyGrH2WaDQQk/2Pj0xRGLgS8UcmY2oMv3fw2j/85PRpsJJwCB2GBRYRK5LlvdTleHd3mB.";
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
