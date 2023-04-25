{
  config,
  lib,
  ...
}: let
  # TODO: solve lib usage
  inherit (lib.lists) concatLists elem;
  inherit (lib.attrsets) mapAttrsToList;
  commonUser = {
    openssh.authorizedKeys.keys = concatLists (mapAttrsToList
      (_: user:
        if elem "wheel" user.extraGroups
        then user.openssh.authorizedKeys.keys
        else [])
      config.users.users);
  };
in {
  security.sudo.extraRules = [
    {
      users = ["deploy"];
      commands = [
        {
          command = "ALL";
          options = [
            "NOPASSWD"
            "SETENV"
          ];
        }
      ];
    }
  ];
  users.users = {
    root = commonUser;
    deploy =
      commonUser
      // {
        isNormalUser = true;
      };
  };
}
