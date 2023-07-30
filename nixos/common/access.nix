{
  config,
  std,
  ...
}: let
  inherit (std) list set;
  commonUser = {
    openssh.authorizedKeys.keys = list.concat (set.mapToValues
      (_: user:
        if list.elem "wheel" user.extraGroups
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
