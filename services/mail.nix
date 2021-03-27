{ config, pkgs, witch, sources, ... }:

{
  imports = [ sources.nixos-mailserver.outPath ];

  mailserver = {
    enable = true;
    fqdn = "athame.kittywit.ch";
    domains = [ "kittywit.ch" "dork.dev" ];

    # A list of all login accounts. To create the password hashes, use
    # nix run nixpkgs.apacheHttpd -c htpasswd -nbB "" "super secret password" | cut -d: -f2
    loginAccounts = {
      "kat@kittywit.ch" = {
        hashedPasswordFile = config.secrets.files.kat_mail_hash.path;

        aliases = [ "postmaster@kittywit.ch" ];

        # Make this user the catchAll address for domains kittywit.ch and
        # example2.com
        catchAll = [ "kittywit.ch" "dork.dev" ];
      };
    };

    # Extra virtual aliases. These are email addresses that are forwarded to
    # loginAccounts addresses.
    extraVirtualAliases = {
      # address = forward address;
      "abuse@kittywit.ch" = "kat@kittywit.ch";
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = 3;

    # Enable IMAP and POP3
    enableImap = true;
    enablePop3 = true;
    enableImapSsl = true;
    enablePop3Ssl = true;

    # Enable the ManageSieve protocol
    enableManageSieve = true;

    # whether to scan inbound emails for viruses (note that this requires at least
    # 1 Gb RAM for the server. Without virus scanning 256 MB RAM should be plenty)
    virusScanning = false;
  };
}
