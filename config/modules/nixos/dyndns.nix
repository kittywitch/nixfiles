{ config, pkgs, lib, tf, ... }:

with lib;

{
  options = {
    kw.dns.dynamic = mkEnableOption "Enable Glauca Dynamic DNS Updater";
  };

  config = mkIf (config.kw.dns.dynamic) {
    deploy.tf.variables.dyn_username = {
      type = "string";
      value.shellCommand = "bitw get infra/hexdns-dynamic -f username";
    };

    deploy.tf.variables.dyn_password = {
      type = "string";
      value.shellCommand = "bitw get infra/hexdns-dynamic -f password";
    };

    deploy.tf.variables.dyn_hostname = {
      type = "string";
      value.shellCommand = "bitw get infra/hexdns-dynamic -f hostname";
    };

    secrets.files.kat-glauca-dns = {
      text = ''
        user="${tf.variables.dyn_username.ref}"
        pass="${tf.variables.dyn_password.ref}"
        hostname="${tf.variables.dyn_hostname.ref}"
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
      ''; in {
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
