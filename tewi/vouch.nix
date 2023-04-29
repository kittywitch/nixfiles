{
  config,
  utils,
  pkgs,
  lib,
  ...
}: {
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
            secure = mkOption {
              type = types.bool;
              default = true;
            };
          };
          port = mkOption {
            type = lib.types.port;
            default = 30746;
          };
          listen = mkOption {
            type = types.nullOr types.str;
            default = "127.0.0.1";
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
            default = ["openid" "email" "profile"];
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
    services.vouch-proxy.settings = {
      vouch.cookie.secure = false;
    };

    sops.secrets = {
      vouch-jwt.owner = "vouch-proxy";
      vouch-client-secret.owner = "vouch-proxy";
    };

    systemd.services.vouch-proxy = {
      description = "Vouch-proxy";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = let
          recursiveMergeAttrs = listOfAttrsets: lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) {} listOfAttrsets;
          settings = recursiveMergeAttrs [
            config.services.vouch-proxy.settings
            {
              oauth.client_secret._secret = config.sops.secrets.vouch-client-secret.path;
              vouch.jwt.secret._secret = config.sops.secrets.vouch-jwt.path;
            }
          ];
        in
          pkgs.writeShellScript "vouch-proxy-start" ''
            ${utils.genJqSecretsReplacementSnippet settings "/run/vouch-proxy/vouch-config.json"}
            ${pkgs.vouch-proxy}/bin/vouch-proxy -config /run/vouch-proxy/vouch-config.json
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

    users.groups.vouch-proxy = {};
  };
}
