_: {
  plugins = let
    basePlugin = {
      enable = true;
      autoLoad = true;
    };
  in {
    startup =
      basePlugin
      // {
        settings = {
          colors = {
            background = "#1f2227";
            folded_section = "#56b6c2";
          };
          mappings = {
            execute_command = "<CR>";
            open_file = "o";
            open_file_split = "<c-o>";
            open_help = "?";
            open_section = "<TAB>";
          };
          header = {
            type = "text";
            oldfiles_directory = false;
            align = "center";
            fold_section = false;
            title = "Header";
            margin = 5;
            highlight = "Statement";
            default_color = "";
            oldfiles_amount = 0;
            content = [
              "█        █                                  █                  █     "
              "█               █      █                           █           █     "
              "█               █      █                           █           █     "
              "█  ▒█  ███    █████  █████  █░  █ █░    █ ███    █████   ▓██▒  █▒██▒ "
              "█ ▒█     █      █      █    ▓▒ ▒▓ ▓▒   ▒█   █      █    ▓█  ▓  █▓ ▒█ "
              "█▒█      █      █      █    ▒█ █▒ ░█ █ █▒   █      █    █░     █   █ "
              "██▓      █      █      █     █ █   █▒█▒█    █      █    █      █   █ "
              "█░█░     █      █      █     █▓▓   █████    █      █    █░     █   █ "
              "█ ░█     █      █░     █░    ▓█▒   ▒█▒█▒    █      █░   ▓█  ▓  █   █ "
              "█  ▒█  █████    ▒██    ▒██   ▒█     █ █   █████    ▒██   ▓██▒  █   █ "
              "                             ▒█                                      "
              "                             █▒                                      "
              "                            ██                                       "
            ];
          };
          body = {
            type = "mapping";
            oldfiles_directory = false;
            align = "center";
            fold_section = false;
            title = "Basic Commands";
            margin = 5;
            content = [
              [" Find File" "Telescope find_files" "<leader>ff"]
              ["󰍉 Find Word" "Telescope live_grep" "<leader>lg"]
              [" Recent Files" "Telescope oldfiles" "<leader>of"]
              [" File Browser" "Telescope file_browser" "<leader>fb"]
              [" New File" "lua require'startup'.new_file()" "<leader>nf"]
            ];
            highlight = "String";
            default_color = "";
            oldfiles_amount = 0;
          };
          footer = {
            type = "text";
            oldfiles_directory = false;
            align = "center";
            fold_section = false;
            title = "Footer";
            margin = 5;
            content = ["waow sleepy girl"];
            highlight = "Number";
            default_color = "";
            oldfiles_amount = 0;
          };
          options = {
            after = null;
            cursor_column = 0.5;
            disable_statuslines = true;
            empty_lines_between_mappings = true;
            mapping_keys = true;
            paddings = [1 3 3 0];
          };
          parts = [
            "header"
            "body"
            "footer"
          ];
        };
      };
  };
}
