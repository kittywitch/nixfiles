{ config, lib, pkgs, tf, ... }:

with lib;

let
  cfg = config.services.murmur;
  forking = (cfg.logFile != null);
in
{
  network.firewall = {
    public = {
      tcp.ports = singleton 64738;
      udp.ports = singleton 64738;
    };
  };

  kw.secrets.variables = {
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
      sslCert=/var/lib/acme/services_murmur/fullchain.pem
      sslKey=/var/lib/acme/services_murmur/key.pem
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
      ExecStart = "${cfg.package}/bin/murmurd -ini ${config.secrets.files.murmur-config.path}";
      Restart = "always";
      RuntimeDirectory = "murmur";
      RuntimeDirectoryMode = "0700";
      User = "murmur";
      Group = "murmur";
    };
  };

  # Certs

  network.extraCerts.services_murmur = "voice.${config.network.dns.domain}";
  users.groups."voice-cert".members = [ "nginx" "murmur" ];
  security.acme.certs.services_murmur = {
    group = "voice-cert";
    postRun = "systemctl restart murmur";
    extraDomainNames = [ config.network.dns.domain ];
  };

  # DNS

  deploy.tf.dns.records = {
    services_murmur = {
      inherit (config.network.dns) zone;
      domain = "voice";
      cname = { inherit (config.network.addresses.public) target; };
    };

    services_murmur_tcp_srv = {
      inherit (config.network.dns) zone;
      domain = "@";
      srv = {
        service = "mumble";
        proto = "tcp";
        priority = 0;
        weight = 5;
        port = 64738;
        target = "voice.${config.network.dns.zone}";
      };
    };

    services_murmur_udp_srv = {
      inherit (config.network.dns) zone;
      domain = "@";
      srv = {
        service = "mumble";
        proto = "udp";
        priority = 0;
        weight = 5;
        port = 64738;
        target = "voice.${config.network.dns.zone}";
      };
    };
  };
}
