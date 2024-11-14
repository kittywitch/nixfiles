{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkDefault;
  fqdn = "${config.networking.hostName}.inskip.me";
in {
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "kittywit.ch";
      max_upload_size = "512M";
      rc_messages_per_second = mkDefault 0.1;
      rc_message_burst_count = mkDefault 25;
      public_baseurl = "https://${fqdn}";
      url_preview_enabled = true;
      enable_registration = false;
      enable_metrics = true;
      report_stats = false;
      dynamic_thumbnails = true;
      registration_shared_secret = "!!MATRIX_SHARED_REGISTRATION_SECRET!!";
      allow_guest_access = true;
      suppress_key_server_warning = true;
      use_appservice_legacy_authorization = true;
      /*
        app_service_config_files = [
        "/var/lib/matrix-synapse/discord-registration.yaml"
        "/var/lib/matrix-synapse/whatsapp-registration.yaml"
        "/var/lib/matrix-synapse/telegram-registration.yaml"
      ];
      */
      log_config = pkgs.writeText "nya.yaml" ''
        version: 1
        formatters:
          precise:
            format: '%(asctime)s - %(name)s - %(lineno)d - %(levelname)s - %(request)s - %(message)s'
        filters:
          context:
            (): synapse.util.logcontext.LoggingContextFilter
            request: ""
        handlers:
          console:
            class: logging.StreamHandler
            formatter: precise
            filters: [context]
        loggers:
          synapse:
            level: WARNING
          synapse.storage.SQL:
            # beware: increasing this to DEBUG will make synapse log sensitive
            # information such as access tokens.
            level: WARNING
        root:
          level: WARNING
          handlers: [console]
      '';
      listeners = [
        {
          port = 8009;
          bind_addresses = ["::1"];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = ["metrics"];
              compress = true;
            }
          ];
        }
        {
          port = 8008;
          bind_addresses = ["::1"];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = ["client" "federation"];
              compress = true;
            }
          ];
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    synapse-cleanup
  ];
}
