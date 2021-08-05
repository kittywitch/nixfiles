{ config, pkgs, tf, ... }:

{
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "gitea" ];
    ensureUsers = [{
      name = "gitea";
      ensurePermissions."DATABASE gitea" = "ALL PRIVILEGES";
    }];
  };

  deploy.tf.variables.gitea_mail = {
    type = "string";
    value.shellCommand = "bitw get infra/gitea-mail -f password";
  };

  secrets.files.gitea_mail = {
    text = ''
      ${tf.variables.gitea_mail.ref};
    '';
    owner = "gitea";
    group = "gitea";
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
    mailerPasswordFile = config.secrets.files.gitea_mail.path;
    settings = {
      security = { DISABLE_GIT_HOOKS = false; };
      api = { ENABLE_SWAGGER = true; };
      mailer = {
        ENABLED = true;
        SUBJECT = "%(APP_NAME)s";
        HOST = "kittywit.ch:465";
        SEND_AS_PLAIN_TEXT = true;
        USE_SENDMAIL = false;
        FROM = "\"kittywitch git\" <gitea@${config.kw.dns.domain}>";
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

  deploy.tf.dns.records.kittywitch_git = {
    tld = config.kw.dns.tld;
    domain = "git";
    cname.target = "${config.networking.hostName}.${config.kw.dns.tld}";
  };
}
