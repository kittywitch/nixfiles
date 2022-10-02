{ config, lib, pkgs, tf, ... }:

with lib;

let
  cfg = config.services.murmur;
  forking = (cfg.logFile != null);
in
{
  networks.internet = {
    tcp = singleton 64738;
    udp = singleton 64738;
  };

  secrets.variables = {
    murmur-password = {
      path = "social/mumble";
      field = "password";
    };
    murmur-ice = {
      path = "social/mumble";
      field = "ice";
    };
  };

  secrets.files.murmur-config = {
    text = ''
      database=/var/lib/murmur/murmur.sqlite
      dbDriver=QSQLITE
      autobanAttempts=${toString cfg.autobanAttempts}
      autobanTimeframe=${toString cfg.autobanTimeframe}
      autobanTime=${toString cfg.autobanTime}
      logfile=${optionalString (cfg.logFile != null) cfg.logFile}
      ${optionalString forking "pidfile=/run/murmur/murmurd.pid"}
      welcometext="${cfg.welcometext}"
      port=${toString cfg.port}
      ${if cfg.password == "" then "" else "serverpassword="+cfg.password}
      bandwidth=${toString cfg.bandwidth}
      users=${toString cfg.users}
      textmessagelength=${toString cfg.textMsgLength}
      imagemessagelength=${toString cfg.imgMsgLength}
      allowhtml=${boolToString cfg.allowHtml}
      logdays=${toString cfg.logDays}
      bonjour=${boolToString cfg.bonjour}
      sendversion=${boolToString cfg.sendVersion}
      ${if cfg.registerName     == "" then "" else "registerName="+cfg.registerName}
      ${if cfg.registerPassword == "" then "" else "registerPassword="+cfg.registerPassword}
      ${if cfg.registerUrl      == "" then "" else "registerUrl="+cfg.registerUrl}
      ${if cfg.registerHostname == "" then "" else "registerHostname="+cfg.registerHostname}
      certrequired=${boolToString cfg.clientCertRequired}
      ${if cfg.sslCert == "" then "" else "sslCert="+cfg.sslCert}
      ${if cfg.sslKey  == "" then "" else "sslKey="+cfg.sslKey}
      ${if cfg.sslCa   == "" then "" else "sslCA="+cfg.sslCa}
      ${cfg.extraConfig}
    '';
    owner = "murmur";
    group = "murmur";
  };

  # Config to Template
  services.murmur = {
    hostName = "voice.${config.network.dns.domain}";
    bandwidth = 130000;
    welcometext = "mew!";
    package = pkgs.murmur.override (old: { iceSupport = true; });
    password = tf.variables.murmur-password.ref;
    extraConfig = ''
      sslCert=${config.networks.internet.cert_path}
      sslKey=${config.networks.internet.key_path}
      ice="tcp -h 127.0.0.1 -p 6502"
      icesecretread=${tf.variables.murmur-ice.ref}
      icesecretwrite=${tf.variables.murmur-ice.ref}
    '';
  };

  # Service Replacement
  users.users.murmur = {
    description = "Murmur Service user";
    home = "/var/lib/murmur";
    createHome = true;
    uid = config.ids.uids.murmur;
    group = "murmur";
  };
  users.groups.murmur = {
    gid = config.ids.gids.murmur;
  };

  systemd.services.murmur = {
    description = "Murmur Chat Service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      # murmurd doesn't fork when logging to the console.
      Type = if forking then "forking" else "simple";
      PIDFile = mkIf forking "/run/murmur/murmurd.pid";
      EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
      ExecStart = "${cfg.package}/bin/mumble-server -ini ${config.secrets.files.murmur-config.path}";
      Restart = "always";
      RuntimeDirectory = "murmur";
      RuntimeDirectoryMode = "0700";
      User = "murmur";
      Group = "murmur";
    };
  };

  networks.internet = {
    extra_domains = [
      "voice.kittywit.ch"
    ];
  };

  users.groups."domain-auth".members = [ "murmur" ];
  # Certs
/*
  network.extraCerts.services_murmur = "voice.${config.net";
  users.groups."voice-cert".members = [ "nginx" "murmur" ];
  security.acme.certs.services_murmur = {
    group = "voice-cert";
    postRun = "systemctl restart murmur";
    extraDomainNames = [ config.networks.internet.dn ];
  };*/

  deploy.tf.dns.records = {
    services_murmur_tcp_srv = {
      inherit (config.networks.internet) zone;
      domain = "@";
      srv = {
        service = "mumble";
        proto = "tcp";
        priority = 0;
        weight = 5;
        port = 64738;
        inherit (config.networks.internet) target;
      };
    };

    services_murmur_udp_srv = {
      inherit (config.networks.internet) zone;
      domain = "@";
      srv = {
        service = "mumble";
        proto = "udp";
        priority = 0;
        weight = 5;
        port = 64738;
        inherit (config.networks.internet) target;
      };
    };
  };
}
