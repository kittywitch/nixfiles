{ pkgs, lib, ... }: {
    home-manager.users.kat.programs.weechat = {
        plugins = {
            perl = {
                enable = true;
            };
        };
        scripts = with pkgs.weechatScripts; [
            highmon
            parse_relayed_msg
        ];
        config.plugins.var.perl = {
          highmon = {
            short_names = "on";
            output = "buffer";
            merge_private = "on";
            alignment = "nchannel,nick";
          };
          parse_relayed_msg = {
            servername = "espernet";
            supported_bot_names = "cord";
          };
        };
    };
}