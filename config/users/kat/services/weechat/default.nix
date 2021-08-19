{ config, lib, superConfig, pkgs, tf, ... }:

{
  kw.secrets = [
    "matrix-pass"
    "znc-pass"
  ];

  secrets.files.weechat-sec = {
    text = ''
      #
      # weechat -- sec.conf
      #
      # WARNING: It is NOT recommended to edit this file by hand,
      # especially if WeeChat is running.
      #
      # Use /set or similar command to change settings in WeeChat.
      #
      # For more info, see: https://weechat.org/doc/quickstart
      #

      [crypt]
      cipher = aes256
      hash_algo = sha512
      salt = off

      [data]
      __passphrase__ = off
      znc = "${tf.variables.znc-pass.ref}"
      matrix = "${tf.variables.matrix-pass.ref}"
    '';
    owner = "kat";
    group = "users";
  };

  home.file = {
    ".local/share/weechat/sec.conf".source = config.lib.file.mkOutOfStoreSymlink config.secrets.files.weechat-sec.path;
  };

  services.weechat.enable = true;

  systemd.user.services.weechat-tmux = let scfg = config.services.weechat; in
    lib.mkForce {
      Unit = {
        Description = "Weechat tmux session";
        After = [ "network.target" ];
      };
      Service = {
        Type = "oneshot";
        Environment = [
          "TMUX_TMPDIR=%t"
          "WEECHAT_HOME=${toString config.programs.weechat.homeDirectory}"
        ];
        RemainAfterExit = true;
        X-RestartIfChanged = false;
        ExecStart = "${scfg.tmuxPackage}/bin/tmux -2 new-session -d -s ${scfg.sessionName} ${scfg.binary}";
        ExecStop = "${scfg.tmuxPackage}/bin/tmux kill-session -t ${scfg.sessionName}";
      };
      Install.WantedBy = [ "default.target" ];
    };

  programs.weechat = {
    enable = true;
    init = lib.mkBefore ''
      /server add softnet athame.kittywit.ch/5001 -ssl -autoconnect
      /server add liberachat athame.kittywit.ch/5001 -ssl -autoconnect
    '';
    scripts = with pkgs.weechatScripts; [
      weechat-notify-send
    ];
    config = {
      irc = {
        server = {
          softnet = {
            address = "athame.kittywit.ch/5001";
            password = "kat@${superConfig.networking.hostName}/softnet:\${sec.data.znc}";
            ssl = true;
            ssl_verify = false;
            autoconnect = true;
          };
          liberachat = {
            address = "athame.kittywit.ch/5001";
            password = "kat@${superConfig.networking.hostName}/liberachat:\${sec.data.znc}";
            ssl = true;
            ssl_verify = false;
            autoconnect = true;
          };
          espernet = {
            address = "athame.kittywit.ch/5001";
            password = "kat@${superConfig.networking.hostName}/espernet:\${sec.data.znc}";
            ssl = true;
            ssl_verify = false;
            autoconnect = true;
          };
        };
      };
      matrix = {
        server.kittywitch = {
          address = "kittywit.ch";
          device_name = "${superConfig.networking.hostName}/weechat";
          username = "kat";
          password = "\${sec.data.matrix}";
        };
      };
    };
  };
}
