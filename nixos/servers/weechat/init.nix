{lib, ...}: let
  inherit (lib.modules) mkMerge mkBefore mkAfter;
in {
  home-manager.users.kat = {config, ...}: {
    sops.secrets = let
      common = {
        sopsFile = ./secrets.yaml;
      };
    in {
      weechat-secret = common;
      liberachat-cert = common;
      espernet-cert = common;
      softnet-cert = common;
    };

    programs.weechat = {
      init = mkMerge [
        (mkBefore ''
          /matrix server add kittywitch yukari.gensokyo.zone
          /matrix server add kittywitch-discord yukari.gensokyo.zone
          /matrix server add kittywitch-telegram yukari.gensokyo.zone
          /matrix server add kittywitch-whatsapp yukari.gensokyo.zone
          /matrix server add kittywitch-signal yukari.gensokyo.zone
          /exec -sh -norc -oc cat ${config.sops.secrets.weechat-secret.path}
          /set irc.server.liberachat.tls_cert ${config.sops.secrets.liberachat-cert.path}
          /set irc.server.espernet.tls_cert ${config.sops.secrets.espernet-cert.path}
          /set irc.server.softnet.tls_cert ${config.sops.secrets.softnet-cert.path}
          /key bind meta-g /go
          /key bind meta-v /input jump_last_buffer_displayed
          /key bind meta-c /buffer close
          /key bind meta-n /bar toggle nicklist
          /key bind meta-b /bar toggle buflist
          /relay add weechat 9000
        '')
        (mkAfter ''
          /matrix connect kittywitch
          /matrix connect kittywitch-discord
          /matrix connect kittywitch-telegram
          /matrix connect kittywitch-whatsapp
          /matrix connect kittywitch-signal
        '')
      ];
    };
  };
}
