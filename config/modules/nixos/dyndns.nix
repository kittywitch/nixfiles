{ config, pkgs, lib, tf, ... }:

with lib;

{
  options = {
    network.dns.dynamic = mkEnableOption "Enable Glauca Dynamic DNS Updater";
  };

  config = mkIf (config.network.dns.dynamic) {
    kw.secrets = [
      "hexdns-key"
      "hexdns-secret"
      "hexdns-host"
    ];

    secrets.files.kat-glauca-dns = {
      text = ''
        user="${tf.variables.hexdns-key.ref}"
        pass="${tf.variables.hexdns-secret.ref}"
        hostname="${tf.variables.hexdns-host.ref}"
      '';
    };

    systemd.services.kat-glauca-dns =
      let updater = pkgs.writeShellScriptBin "glauca-dyndns" ''
        #!/usr/bin/env bash
        set -eu

        ip4=$(${pkgs.curl}/bin/curl -s --ipv4 https://dns.glauca.digital/checkip)
        ip6=$(${pkgs.curl}/bin/curl -s --ipv6 https://dns.glauca.digital/checkip)
        source $passFile
        echo "$ip4, $ip6"
          ${pkgs.curl}/bin/curl -u ''${user}:''${pass} --data-urlencode "hostname=''${hostname}" --data-urlencode "myip=''${ip4}" "https://dns.glauca.digital/nic/update"
        echo ""
          ${pkgs.curl}/bin/curl -u ''${user}:''${pass} --data-urlencode "hostname=''${hostname}" --data-urlencode "myip=''${ip6}" "https://dns.glauca.digital/nic/update"
      ''; in
      {
        serviceConfig = {
          ExecStart = "${updater}/bin/glauca-dyndns";
        };
        environment = { passFile = config.secrets.files.kat-glauca-dns.path; };
        wantedBy = [ "default.target" ];
      };

    systemd.timers.kat-glauca-dns = {
      timerConfig = {
        Unit = "kat-glauca-dns.service";
        OnBootSec = "5m";
        OnUnitActiveSec = "1h";
      };
      wantedBy = [ "default.target" ];
    };
  };
}
