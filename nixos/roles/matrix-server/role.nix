{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkDefault;
  fqdn = "${config.networking.hostName}.${config.networking.domain}";
  clientConfig = {
    "m.homeserver".base_url = "https://${fqdn}";
    "m.identity_server".base_url = "https://vector.im";
  };
  serverConfig."m.server" = "${fqdn}:443";
  mkWellKnown = data: ''
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in {
  sops.secrets.matrix_shared_registration_secret = {
    format = "yaml";
    sopsFile = ./secrets.yaml;
  };

  scalpels = [
    ./scalpel.nix
  ];

  services.postgresql.enable = true;

  services.nginx = {
    virtualHosts = {
      "kittywit.ch" = {
        enableACME = true;
        forceSSL = true;
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
      "${fqdn}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".extraConfig = ''
          return 404;
        '';
        locations."/_matrix".proxyPass = "http://[::1]:8008";
        locations."/_synapse/client".proxyPass = "http://[::1]:8008";
        extraConfig = ''
          http2_max_requests 100000;
          keepalive_requests 100000;
        '';
      };
    };
  };

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
      enable_metrics = mkDefault false;
      report_stats = mkDefault false;
      dynamic_thumbnails = mkDefault true;
      registration_shared_secret = "!!MATRIX_SHARED_REGISTRATION_SECRET!!";
      allow_guest_access = mkDefault true;
      suppress_key_server_warning = mkDefault true;
      listeners = [
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

  security.acme = {
    email = "acme@inskip.me";
    acceptTerms = true;
  };
}
