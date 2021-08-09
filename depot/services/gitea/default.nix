{ config, pkgs, tf, ... }:

{
  kw.secrets = [
    "gitea-mail-pass"
  ];

  secrets.files.gitea-mail-passfile = {
    text = ''
      ${tf.variables.gitea-mail-pass.ref};
    '';
    owner = "gitea";
    group = "gitea";
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "gitea" ];
    ensureUsers = [{
      name = "gitea";
      ensurePermissions."DATABASE gitea" = "ALL PRIVILEGES";
    }];
  };

  services.gitea = {
    enable = true;
    disableRegistration = true;
    domain = "git.${config.kw.dns.domain}";
    rootUrl = "https://git.${config.kw.dns.domain}";
    httpAddress = "127.0.0.1";
    appName = "kittywitch git";
    ssh = { clonePort = 62954; };
    database = {
      type = "postgres";
      name = "gitea";
      user = "gitea";
    };
    mailerPasswordFile = config.secrets.files.gitea-mail-passfile.path;
    settings = {
      security = { DISABLE_GIT_HOOKS = false; };
      api = { ENABLE_SWAGGER = true; };
      mailer = {
        ENABLED = true;
        SUBJECT = "%(APP_NAME)s";
        HOST = "athame.kittywit.ch:465";
        USER = "gitea@kittywit.ch";
        #SEND_AS_PLAIN_TEXT = true;
        USE_SENDMAIL = false;
        FROM = "\"kittywitch git\" <gitea@${config.kw.dns.domain}>";
      };
      service = {
        NO_REPLY_ADDRESS = "kittywit.ch";
        REGISTER_EMAIL_CONFIRM = true;
        ENABLE_NOTIFY_MAIL = true;
      };
      ui = {
        THEMES = "gitea,arc-green";
        DEFAULT_THEME = "gitea";
        THEME_COLOR_META_TAG = "#222222";
      };
    };
  };

  systemd.services.gitea.preStart = ''
    ${pkgs.coreutils}/bin/ln -sfT ${./public} /var/lib/gitea/custom/public
    ${pkgs.coreutils}/bin/ln -sfT ${./templates} /var/lib/gitea/custom/templates
  '';

  services.nginx.virtualHosts."git.${config.kw.dns.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations = { "/".proxyPass = "http://127.0.0.1:3000"; };
  };

  deploy.tf.dns.records.services_gitea = {
    tld = config.kw.dns.tld;
    domain = "git";
    cname.target = "${config.networking.hostName}.${config.kw.dns.tld}";
  };
}
