{ config, pkgs, ... }:

{
    gitea = {
      enable = true;
      disableRegistration = true; # TODO change for initial setup
      domain = "git.dork.dev";
      rootUrl = "https://git.dork.dev";
    };
}