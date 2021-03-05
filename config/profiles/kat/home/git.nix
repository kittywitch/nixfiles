{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.deploy.profile.kat {
    home.packages = with pkgs; [ git-crypt gitAndTools.gitRemoteGcrypt ];

    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "kat witch";
      userEmail = "kat@kittywit.ch";
      extraConfig = { protocol.gcrypt.allow = "always"; };
      signing = {
        key = "01F50A29D4AA91175A11BDB17248991EFA8EFBEE";
        signByDefault = true;
      };
    };
  };
}
