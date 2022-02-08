{ config, pkgs, lib, ... }:

let
  postfixCfg = config.services.postfix;
  rspamdCfg = config.services.rspamd;
  rspamdSocket = "rspamd.service";
in
{
  config = {
    services.rspamd = {
      enable = true;
      locals = {
          "milter_headers.conf" = { text = ''
              extended_spam_headers = yes;
          ''; };
          "redis.conf" = { text = ''
              servers = "127.0.0.1:${toString config.services.redis.servers.rspamd.port}";
          ''; };
          "classifier-bayes.conf" = { text = ''
              cache {
                backend = "redis";
              }
          ''; };
          "dkim_signing.conf" = { text = ''
              # Disable outbound email signing, we use opendkim for this
              enabled = false;
          ''; };
      };

      overrides = {
        "milter_headers.conf" = {
          text = ''
            extended_spam_headers = true;
          '';
        };
      };

      workers.rspamd_proxy = {
        type = "rspamd_proxy";
        bindSockets = [{
          socket = "/run/rspamd/rspamd-milter.sock";
          mode = "0664";
        }];
        count = 1; # Do not spawn too many processes of this type
        extraConfig = ''
          milter = yes; # Enable milter mode
          timeout = 120s; # Needed for Milter usually

          upstream "local" {
            default = yes; # Self-scan upstreams are always default
            self_scan = yes; # Enable self-scan
          }
        '';
      };
      workers.controller = {
        type = "controller";
        count = 1;
        bindSockets = [{
          socket = "/run/rspamd/worker-controller.sock";
          mode = "0666";
        }];
        includes = [];
        extraConfig = ''
          static_dir = "''${WWWDIR}"; # Serve the web UI static assets
        '';
      };

    };

    services.redis.servers.rspamd.enable = true;

    systemd.services.rspamd = {
      requires = [ "redis.service" ];
      after = [ "redis.service" ];
    };

    systemd.services.postfix = {
      after = [ rspamdSocket ];
      requires = [ rspamdSocket ];
    };

    users.extraUsers.${postfixCfg.user}.extraGroups = [ rspamdCfg.group ];
  };
}

