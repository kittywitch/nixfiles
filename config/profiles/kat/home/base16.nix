{ config, ... }:

{
  config = lib.mkIf config.deploy.profile.kat {
    base16 = {
      shell.enable = true;
      schemes = [ "rebecca.rebecca" ];
    };
    #  home.base16-shell = {
    #    enable = true;
    #    defaultTheme = "rebecca.rebecca";
    #  };
  };
}
