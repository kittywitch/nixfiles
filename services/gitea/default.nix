{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "gitea" ];
    ensureUsers = [
      { name = "gitea";
        ensurePermissions."DATABASE gitea" = "ALL PRIVILEGES";
      }
    ];
  };

  services.gitea = {
    enable = true;
    disableRegistration = true;
    domain = "git.kittywit.ch";
    rootUrl = "https://git.kittywit.ch";
    httpAddress = "127.0.0.1";
    appName = "kittywitch git";
    ssh = { clonePort = 62954; };
    settings = {
      security = { DISABLE_GIT_HOOKS = false; };
      database = {
        type = "postgres";
        name = "gitea";
        user = "gitea";
      };
      mailer = {
        ENABLED = true;
        MAILER_TYPE = "sendmail";
        FROM = "gitea@kittywit.ch";
        SENDMAIL_PATH = "${pkgs.system-sendmail}/bin/sendmail";
      };
      ui = {
        THEMES = "gitea,arc-green,kittywitch";
        DEFAULT_THEME = "gitea";
        THEME_COLOR_META_TAG = "#222222";
      };
    };
  };

  systemd.services.gitea.preStart = ''
    ${pkgs.coreutils}/bin/ln -sfT ${./public} /var/lib/gitea/custom/public
    ${pkgs.coreutils}/bin/ln -sfT ${./templates} /var/lib/gitea/custom/templates
  '';

  services.nginx.virtualHosts."git.kittywit.ch" = {
    enableACME = true;
    forceSSL = true;
    locations = { "/".proxyPass = "http://127.0.0.1:3000"; };
  };

  deploy.tf.dns.records.kittywitch_git = {
    tld = "kittywit.ch.";
    domain = "git";
    cname.target = "athame.kittywit.ch.";
  };
}
