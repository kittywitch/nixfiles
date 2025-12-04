{config, ...}: {
  sops.secrets.kat-password = {
    sopsFile = ./secrets.yaml;
  };
  mailserver = {
    enable = true;
    stateVersion = 3;
    fqdn = "rinnosuke.inskip.me";
    domains = ["dork.dev"];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "kat@dork.dev" = {
        hashedPasswordFile = config.sops.secrets.kat-password.path;
        aliases = [
          "@dork.dev"
        ];
        catchAll = [
          "dork.dev"
        ];
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
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
