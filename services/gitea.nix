{ config, pkgs, ... }:

{
  services.gitea = {
    enable = true;
    disableRegistration = true;
    domain = "git.kittywit.ch";
    rootUrl = "https://git.kittywit.ch";
    httpAddress = "127.0.0.1";
    ssh = { clonePort = 62954; };
    settings = {
      security = { DISABLE_GIT_HOOKS = false; };
      mailer = {
        ENABLED = true;
        MAILER_TYPE = "sendmail";
        FROM = "gitea@kittywit.ch";
        SENDMAIL_PATH = "${pkgs.system-sendmail}/bin/sendmail";
      };
    };
  };

  services.nginx.virtualHosts."git.kittywit.ch" = {
    enableACME = true;
    forceSSL = true;
    locations = { "/".proxyPass = "http://127.0.0.1:3000"; };
  };
}
