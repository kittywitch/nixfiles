{ config, pkgs, lib, tf, ... }: {
  options = with lib; let
    origin = "https://id.gensokyo.zone";
  in {
    services.vouch-proxy = {
      settings = {
        vouch = {
          cookie = {
            domain = mkOption {
              type = types.nullOr types.str;
              default = "gensokyo.zone";
            };
          };
          port = mkOption {
            type = lib.types.port;
            default = 30746;
          };
          listen = mkOption {
            type = types.nullOr types.str;
            default = config.networks.tailscale.ipv4;
          };
          allowAllUsers = mkOption {
            type = types.bool;
            default = true;
          };
        };
        oauth = {
          auth_url = mkOption {
            type = types.str;
            default = "${origin}/ui/oauth2";
          };
          token_url = mkOption {
            type = types.str;
            default = "${origin}/oauth2/token";
          };
          user_info_url = mkOption {
            type = types.str;
            default = "${origin}/oauth2/openid/vouch/userinfo";
          };
          scopes = mkOption {
            type = types.listOf types.str;
            default = [ "openid" "email" "profile" ];
          };
          callback_url = mkOption {
            type = types.str;
            default = "https://login.gensokyo.zone/auth";
          };
          provider = mkOption {
            type = types.nullOr types.str;
            default = "oidc";
          };
        code_challenge_method = mkOption {
          type = types.str;
          default = "S256";
        };
          client_id = mkOption {
            type = types.str;
            default = "vouch";
          };
        };
      };
    };
  };
  config = {
    secrets.variables.gensokyo-id = {
      path = "secrets/id.gensokyo.zone";
      field = "client_secret";
    };

    secrets.variables.gensokyo-jwt = {
      path = "secrets/id.gensokyo.zone";
      field = "jwt";
    };
    secrets.files.vouch-config = let
      recursiveMergeAttrs = listOfAttrsets: lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) {} listOfAttrsets;
    in {
      text = builtins.toJSON (recursiveMergeAttrs [
          config.services.vouch-proxy.settings
          { oauth.client_secret = tf.variables.gensokyo-id.ref; vouch.jwt.secret = tf.variables.gensokyo-jwt.ref; }
        ]);
        owner = "vouch-proxy";
      group = "vouch-proxy";
    };

    systemd.services.vouch-proxy = {
      description = "Vouch-proxy";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart =
          ''
          ${pkgs.vouch-proxy}/bin/vouch-proxy -config ${config.secrets.files.vouch-config.path}
        '';
        Restart = "on-failure";
        RestartSec = 5;
        WorkingDirectory = "/var/lib/vouch-proxy";
        StateDirectory = "vouch-proxy";
        RuntimeDirectory = "vouch-proxy";
        User = "vouch-proxy";
        Group = "vouch-proxy";
        StartLimitBurst = 3;
      };
    };

    users.users.vouch-proxy = {
      isSystemUser = true;
      group = "vouch-proxy";
    };

    users.groups.vouch-proxy = { };
  };
}
