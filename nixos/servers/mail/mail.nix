{config, ...}: {
  sops.secrets.kat-password = {
    sopsFile = ./secrets.yaml;
  };
  mailserver = {
    enable = true;
    stateVersion = 3;
    fqdn = "rinnosuke.inskip.me";
    domains = ["dork.dev" "kittywit.ch" "inskip.me" "katsli.me"];

    fullTextSearch.enable = true;

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "kat@dork.dev" = {
        hashedPasswordFile = config.sops.secrets.kat-password.path;
        aliases = [
          "@dork.dev"
          "@inskip.me"
          "@kittywit.ch"
          "@katsli.me"
        ];
        catchAll = [
          "dork.dev"
          "inskip.me"
          "kittywit.ch"
          "katsli.me"
        ];
      };
    };
    x509.useACMEHost = "rinnosuke.inskip.me";
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@inskip.me";

  services.roundcube = {
    enable = true;
    # this is the url of the vhost, not necessarily the same as the fqdn of
    # the mailserver
    hostName = "webmail.dork.dev";
    extraConfig = ''
      $config['imap_host'] = "ssl://${config.mailserver.fqdn}";
      $config['smtp_host'] = "ssl://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };

  
  services.nginx.enable = true;

  networking.firewall.allowedTCPPorts = [80 443];
}
