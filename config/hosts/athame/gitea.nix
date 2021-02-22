{ config, pkgs, ... }:

{
  services.gitea = {
    enable = true;
    disableRegistration = true; # TODO change for initial setup
    domain = "git.kittywit.ch";
    rootUrl = "https://git.kittywit.ch";
  };
}
