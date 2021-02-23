{ config, pkgs, ... }:

{
  services.gitea = {
    enable = true;
    disableRegistration = true;
    domain = "git.kittywit.ch";
    rootUrl = "https://git.kittywit.ch";
  };
}
