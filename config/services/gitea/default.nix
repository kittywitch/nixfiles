{ config, lib, pkgs, tf, ... }:

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
    domain = "git.${config.network.dns.domain}";
    rootUrl = "https://git.${config.network.dns.domain}";
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
        FROM = "\"kittywitch git\" <gitea@${config.network.dns.domain}>";
      };
      service = {
        NO_REPLY_ADDRESS = "kittywit.ch";
        REGISTER_EMAIL_CONFIRM = true;
        ENABLE_NOTIFY_MAIL = true;
      };
      ui = {
        THEMES = "gitea";
        DEFAULT_THEME = "gitea";
        THEME_COLOR_META_TAG = "#222222";
      };
    };
  };

  systemd.services.gitea.serviceConfig.ExecStartPre =
    let
      themePark = pkgs.fetchFromGitHub {
        owner = "GilbN";
        repo = "theme.park";
        rev = "009a7b703544955f8a29197597507d9a1ae40d63";
        sha256 = "1axqivwkmw6rq0ffwi1mm209bfkvv4lyld2hgyq2zmnl7mj3fifc";
      };
      binder = pkgs.writeText "styles.css" ''
        @import url("/assets/css/gitea-base.css");
        @import url("/assets/css/overseerr.css");
        :root {
          --color-code-bg: transparent;
        }
        .markup input[type="checkbox"] {
          appearance: auto !important;
          -moz-appearance: auto !important;
          -webkit-appearance: auto !important;
        }
      '';
    in
    [
      "${pkgs.coreutils}/bin/ln -sfT ${pkgs.runCommand "gitea-public" {
    } ''
    ${pkgs.coreutils}/bin/mkdir -p $out/{css,img}
    ${pkgs.coreutils}/bin/cp ${themePark}/CSS/themes/gitea/gitea-base.css $out/css
    ${pkgs.coreutils}/bin/cp ${themePark}/CSS/variables/overseerr.css $out/css
    ${pkgs.coreutils}/bin/cp ${binder} $out/css/styles.css
    ${pkgs.coreutils}/bin/cp -r ${./public}/* $out/
    ''} /var/lib/gitea/custom/public"
      "${pkgs.coreutils}/bin/ln -sfT ${./templates} /var/lib/gitea/custom/templates"
    ];

  services.nginx.virtualHosts."git.${config.network.dns.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations = { "/".proxyPass = "http://127.0.0.1:3000"; };
  };

  deploy.tf.dns.records.services_gitea = {
    tld = config.network.dns.tld;
    domain = "git";
    cname.target = "${config.networking.hostName}.${config.network.dns.tld}";
  };
}
