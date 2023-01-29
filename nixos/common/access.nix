{ config, pkgs, lib, ... }: let
# TODO: solve lib usage
inherit (lib.lists) concatLists elem;
inherit (lib.attrsets) mapAttrsToList;
in {
  users.users.root = {
    shell = pkgs.zsh;
    hashedPassword =
      "$6$i28yOXoo$/WokLdKds5ZHtJHcuyGrH2WaDQQk/2Pj0xRGLgS8UcmY2oMv3fw2j/85PRpsJJwCB2GBRYRK5LlvdTleHd3mB.";
    openssh.authorizedKeys.keys = concatLists (mapAttrsToList
          (name: user:
           if elem "wheel" user.extraGroups then
           user.openssh.authorizedKeys.keys
           else
           [ ])
          config.users.users);
  };
   }
