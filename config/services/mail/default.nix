{ ... }: {
  imports = [
    ./dns.nix
    ./rspamd.nix
    ./postfix.nix
    ./dovecot.nix
    ./opendkim.nix
    ./autoconfig.nix
  ];
}
