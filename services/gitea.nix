{ config, pkgs, ... }:

{
  services.gitea = {
    enable = true;
    disableRegistration = true;
    domain = "git.kittywit.ch";
    rootUrl = "https://git.kittywit.ch";
    httpAddress = "127.0.0.1";
  };

  services.nginx.virtualHosts."git.kittywit.ch" = {
    enableACME = true;
    forceSSL = true;
    locations = { "/".proxyPass = "http://127.0.0.1:3000"; };
  };
}
