{ config, std, inputs, lib, ... }: let
    inherit (std) list set;
in {
    home-manager.users.kat = {
        services.weechat.enable = true;
        programs.weechat = {
            enable = true;
            config.weechat = with config.base16.defaultScheme.map.ansiStr; {
                look = {
                    mouse = true;
                    separator_horizontal = "";
                    read_marker_string = "─";
                    prefix_same_nick = "↳";
                    highlight_disable_regex = "signal|discord|telegram|whatsapp";
                    highlight = "kat,kittywitch";
                };
                # color overrides
                color = {
                    chat_nick_self = base0E;
                    separator = base06;
                    chat_read_marker = base0B;
                    chat_read_marker_bg = base03;
                };
                # bars config
                bar = {
                    buflist = {
                        size_max = 24;
                        color_delim = base0E;
                    };
                    input = {
                        items = "[input_prompt]+(away),[input_search],[input_paste],input_text,[vi_buffer]";
                        color_delim = base0E;
                        conditions = "\${window.buffer.full_name} != perl.highmon";
                    };
                    nicklist = {
                        size_max = 18;
                        color_delim = base0E;
                    };
                    status = {
                        color_bg = base02;
                        color_fg = base06;
                        color_delim = base0E;
                        items = "[time],mode_indicator,[buffer_last_number],[buffer_plugin],buffer_number+:+buffer_name+(buffer_modes)+{buffer_nicklist_count}+matrix_typing_notice+buffer_zoom+buffer_filter,scroll,[lag],[hotlist],completion,cmd_completion";
                        conditions = "\${window.buffer.full_name} != perl.highmon";
                    };
                    title = {
                        color_bg = base02;
                        color_fg = base06;
                        color_delim = base0E;
                        conditions = "\${window.buffer.full_name} != perl.highmon";
                    };
                };
            };
        };
     };
}