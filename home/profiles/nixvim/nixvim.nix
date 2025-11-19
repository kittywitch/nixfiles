{
  lib,
  tree,
  std,
  ...
}: let
  inherit (std) set;
  inherit (lib.attrsets) genAttrs;
in {
  programs.nixvim = {
    enable = true;
    imports = [
      tree.home.profiles.nixvim.plugins
    ];
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
      ];
      basePlugin = {
        enable = true;
        autoLoad = true;
      };
    in
      set.merge [
        (genAttrs pluginsToGen (_: basePlugin))
        {
          auto-session.settings = {
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
  };
}
