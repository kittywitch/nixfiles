{ pkgs, ... }: {
    home-manager.users.kat.programs.weechat = {
        scripts = with pkgs.weechatScripts; [
            weechat-matrix
        ];
        plugins = {
            python = {
              packages = [ "weechat-matrix" ];
            };
        };
        config.matrix = {
            network = {
                max_backlog_sync_events = 30;
                lazy_load_room_users = true;
                autoreconnect_delay_max = 5;
                lag_min-show = 1000;
            };
            look = {
                server_buffer = "independent";
                redactions = "notice";
            };
        };
    };
}
