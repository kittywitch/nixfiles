{
  std,
  lib,
  ...
}: let
  inherit (std) set;
  inherit (lib.attrsets) genAttrs;
in {
  vimAlias = true;
  opts = {
    mouse = "a";
    clipboard = "unnamedplus";
    completeopt = "longest,menuone";
    backup = false;
    writebackup = false;
    ttimeoutlen = 100;
    number = true;
    relativenumber = true;
    showmatch = true;
    foldmethod = "marker";
    colorcolumn = "80";
    splitright = true;
    splitbelow = true;
    ignorecase = true;
    smartcase = true;
    wrap = true;
    linebreak = true;
    showbreak = "↳";
    termguicolors = true;
    laststatus = 3;
    cursorline = true;
    cmdheight = 1;
    hlsearch = true;
    expandtab = true;
    shiftwidth = 2;
    tabstop = 2;
    smartindent = true;
    list = true;
    listchars = {
      tab = "» ";
      extends = "›";
      precedes = "‹";
      nbsp = "·";
      trail = "✖";
    };
    hidden = true;
    history = 1000;
    shada = "'1000,f1,<500,@500,/500";
    lazyredraw = true;
    synmaxcol = 240;
    updatetime = 700;
  };
  globals = {
    mapleader = " ";
    maplocalleader = ",";
  };
  plugins = let
    pluginsToGen = [
      "lastplace"
      "mini-animate"
      "mini-clue"
      "commentary"
      "treesitter"
      "treesitter-context"
      "nix-develop"
      "lualine"
      "startup"
      "lazygit"
      "web-devicons"
      "auto-session"
      "overseer"
      "twilight"
      "bufferline"
      "zk"
      "rainbow"
      "indent-blankline"
    ];
    basePlugin = {
      enable = true;
      autoLoad = true;
    };
  in
    set.merge [
      (genAttrs pluginsToGen (_: basePlugin))
      {
        mini-animate.settings = {
          scroll.enable = false;
        };
        indent-blankline = {
          luaConfig.pre = ''
              local highlight = {
                "RainbowRed",
                "RainbowYellow",
                "RainbowBlue",
                "RainbowOrange",
                "RainbowGreen",
                "RainbowViolet",
                "RainbowCyan",
              }

            local hooks = require "ibl.hooks"
              -- create the highlight groups in the highlight setup hook, so they are reset
              -- every time the colorscheme changes
              hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
                  end)

          '';
          settings = {
            exclude = {
              buftypes = [
                "terminal"
                "quickfix"
              ];
              filetypes = [
                ""
                "checkhealth"
                "help"
                "lspinfo"
                "packer"
                "TelescopePrompt"
                "TelescopeResults"
                "yaml"
              ];
            };
            indent = {
              char = "│";
              highlight.__raw = ''highlight'';
            };
            scope = {
              show_end = false;
              show_exact_scope = true;
              show_start = false;
            };
          };
        };
        auto-session.settings = {
          auto_save = true;
          auto_create = true;
          bypass_save_filetypes = ["startup"];
          close_filetypes_on_save = ["startup"];
        };
        twilight.settings = {
          context = 10;
          dimming.alpha = 0.5;
          expand = [
            "function"
            "method"
            "table"
            "if_statement"
          ];
        };
      }
    ];
}
