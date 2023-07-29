{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkDefault;
  fqdn = "${config.networking.hostName}.${config.networking.domain}";
in {
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "kittywit.ch";
      max_upload_size = "512M";
      rc_messages_per_second = mkDefault 0.1;
      rc_message_burst_count = mkDefault 25;
      public_baseurl = "https://${fqdn}";
      url_preview_enabled = mkDefault true;
      enable_registration = mkDefault false;
      enable_metrics = mkDefault true;
      report_stats = mkDefault false;
      dynamic_thumbnails = mkDefault true;
      registration_shared_secret = "!!MATRIX_SHARED_REGISTRATION_SECRET!!";
      allow_guest_access = mkDefault true;
      suppress_key_server_warning = mkDefault true;
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
