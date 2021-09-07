{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.dht22-exporter;
in
{
  options.services.dht22-exporter.socat = {
    enable = mkEnableOption "socat service";
    package = mkOption {
      type = types.package;
      default = pkgs.socat;
    };
    addresses = mkOption {
      type = with types; coercedTo str singleton (listOf str);
      default = singleton "::1";
    };
  };
  config = {
    systemd.services = mkIf cfg.socat.enable {
      dht22-exporter-socat =
        let
          scfg = cfg.socat;
          service = singleton "dht22-exporter.service";
        in
        {
          after = service;
          bindsTo = service;
          serviceConfig = {
            DynamicUser = true;
          };
          script =
            let
              port = toString (if cfg.port == null then 8001 else cfg.port);
              addresser = addr: "${scfg.package}/bin/socat TCP6-LISTEN:${port},bind=${addr},fork TCP4:localhost:${port}";
              lines = map addresser scfg.addresses;
            in
            ''
              ${concatStringsSep "\n" lines}
            '';
        };
    };

    users.users.dht22-exporter = {
      isSystemUser = true;
    };

    services.dht22-exporter = {
      enable = true;
      platform = "pi";
      address = "127.0.0.1";
      socat = {
        enable = true;
      };
      user = "dht22-exporter";
      group = "gpio";
    };
  };
}
