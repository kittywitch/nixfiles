@inity@

-----------------------------------------------------------
-- Variables
-----------------------------------------------------------
local g = vim.g       -- Global variables
local opt = vim.opt   -- Set options (global/buffer/windows-scoped)
local wo = vim.wo     -- Window local variables
local api = vim.api   -- Lua API

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = 'a'                        -- Enable mouse support
opt.clipboard = 'unnamedplus'          -- Copy/paste to system clipboard
opt.completeopt = 'longest,menuone'    -- Autocomplete options
opt.backup = false                     -- Disable backup
opt.writebackup = false                -- Disable backup
opt.ttimeoutlen = 100                  -- Mapping timeout

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true                             -- Show line number
opt.relativenumber = true                     -- Relative line numbers
opt.showmatch = true                          -- Highlight matching parenthesis
opt.foldmethod = 'marker'                     -- Enable folding (default 'foldmarker')
opt.colorcolumn = '80'                        -- Line length marker at 80 columns
opt.splitright = true                         -- Vertical split to the right
opt.splitbelow = true                         -- Horizontal split to the bottom
opt.ignorecase = true                         -- Ignore case letters when search
opt.smartcase = true                          -- Ignore lowercase for the whole pattern
opt.wrap = true                               -- Wrap on word boundary
opt.linebreak = true                          -- Wrap on word boundary
opt.showbreak = " ↳"                          -- Character to use to display word boundary
opt.termguicolors = true                     -- Enable 24-bit RGB colors
opt.laststatus = 3                            -- Set global statusline
opt.cursorline = true                         -- Highlight cursor screenline
opt.cmdheight = 1                             -- Command entry line height
opt.hlsearch = true                           -- Highlight matches with last search pattern
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true       -- Use spaces instead of tabs
opt.shiftwidth = 2          -- Shift 2 spaces when tab
opt.tabstop = 2             -- 1 tab == 2 spaces
opt.smartindent = true      -- Autoindent new lines
opt.list = true             -- List chars
opt.listchars = {
	tab = '» ',
	extends = '›',
	precedes= '‹',
	nbsp = '·',
	trail = '✖'
}

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true           -- Enable background buffers
opt.history = 1000           -- Remember N lines in history
opt.shada = "'1000,f1,<500,@500,/500"
opt.lazyredraw = true       -- Faster scrolling
opt.synmaxcol = 240         -- Max column for syntax highlight
opt.updatetime = 700        -- ms to wait for trigger an event

-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------

-- Remove perl
g.loaded_perl_provider = 0

-- Hexokinaise
g.Hexokinase_highlighters = {'virtual'}
g.Hexokinase_optInPatterns = {
	'full_hex',
	'rgb',
	'rgba',
	'hsl',
	'hsla',
	'colour_names'
}

-- Lastplace
g.lastplace_ignore = 'gitcommit,gitrebase,svn,hgcommit'

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------

-- Disable builtins plugins
local disabled_built_ins = {
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"gzip",
	"zip",
	"zipPlugin",
	"tar",
	"tarPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"logipat",
	"rrhelper",
	"spellfile_plugin",
	"matchit"
}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end

-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------

-- lualine
require('lualine').setup({
  options = {
    theme = bubbles_theme,
    component_separators = '',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
    lualine_b = { 'filename', 'branch', 'diff' },
    lualine_c = {
      '%=', --[[ add your center components here in place of this comment ]]
    },
    lualine_x = { 'overseer' },
    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {},
})

-- nvim-cmp
vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = true,
  underlines = true
})

local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

      -- For `mini.snippets` users:
      -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
      -- insert({ body = args.body }) -- Insert at cursor
      -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
      -- require("cmp.config").set_onetime({ sources = {} })
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
      { name = 'buffer' },
    })
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup()

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
      { name = 'cmdline' }
    }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.inlay_hint.enable();

-- neorg
require('neorg').setup {
	-- Tell Neorg what modules to load
	load = {
		['core.defaults'] = {}, -- Load all the default modules
		['core.concealer'] = {}, -- Allows for use of icons
		['core.dirman'] = { -- Manage your directories with Neorg
			config = {
				workspaces = {
					notes = '~/Notes',
				},
				default_workspace = "notes",
			}
		}
	},
}

-- overseer
require("overseer").setup()

-- auto-session
require("auto-session").setup({})

-- telescope
local telescope = require('telescope.builtin')

vim.keymap.set("n", "<leader>ff", function()
	telescope.find_files()
end, { silent = true })

vim.keymap.set("n", "<leader>fg", function()
	telescope.live_grep()
end, { silent = true })

vim.keymap.set("n", "<leader>fb", function()
	telescope.buffers()
end, { silent = true })

vim.keymap.set("n", "<leader>fh", function()
	telescope.help_tags()
end, { silent = true })

-- treesitter
require('nvim-treesitter.configs').setup {
	-- A list of parser names, or "all"
	ensure_installed = {
	},

	sync_install = false,
	auto_install = false,
	ignore_install = {},

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
	rainbow = {
		enable = true,
		extended_mode = true
	},
}

-- twilight
require("twilight").setup {
	dimming = {
		alpha = 0.5,
	},
	context = 10,
	expand = {
		"function",
		"method",
		"table",
		"if_statement",
	},
}

-- Aerial overview (skimming and quick nav)
require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

-- bufferline
require('bufferline').setup {
	options = {
		mode = "buffers", -- set to "tabs" to only show tabpages instead
		numbers = "ordinal",
		close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
		right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
		left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
		middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
		indicator = {
      icon = '▎',
      style = 'icon',
    },
		buffer_close_icon = '',
		modified_icon = '●',
		close_icon = '',
		left_trunc_marker = '',
		right_trunc_marker = '',
		name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
			-- remove extension from markdown files for example
			if buf.name:match('%.md') then
				return vim.fn.fnamemodify(buf.name, ':t:r')
			end
		end,
		max_name_length = 18,
		max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
		tab_size = 18,
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		color_icons = true,
		show_buffer_icons = true, -- disable filetype icons for buffers
		show_buffer_close_icons = true,
		show_close_icon = false,
		show_tab_indicators = true,
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		separator_style = "slant",
		always_show_bufferline = true,
	}
}

--local barColor = base16.base00;

local highlightItems = {
	BufferLineFill = "bg",
	BufferLineBackground = "bg",
	BufferLineSeparator = "fg",
	BufferLineSeparatorSelected = "fg",
	BufferLineSeparatorVisible = "fg",
}

local commandString = ""

--for item, ground in pairs(highlightItems) do
--	commandString = "highlight " .. item .. " cterm" .. ground .. "=" .. barColor .. " | " .. commandString
--end

--api.nvim_create_autocmd("ColorScheme", {
--	command = commandString;
--})

-- hop
local hop = require('hop')
local directions = require("hop.hint").HintDirection
hop.setup()

vim.keymap.set("", "t", function()
	hop.hint_words()
end, {})

vim.keymap.set("", "T", function()
	hop.hint_lines_skip_whitespace()
end, {remap=true})

vim.keymap.set("", "f", function()
	hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})

vim.keymap.set("", "F", function()
	hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})

-- https://github.com/zk-org/zk-nvim
require("zk").setup({
      -- Can be "telescope", "fzf", "fzf_lua", "minipick", "snacks_picker",
      -- or select" (`vim.ui.select`).
      picker = "telescope",

      lsp = {
        -- `config` is passed to `vim.lsp.start(config)`
        config = {
          name = "zk",
          cmd = { "zk", "lsp" },
          filetypes = { "markdown" },
          -- on_attach = ...
          -- etc, see `:h vim.lsp.start()`
        },

        -- automatically attach buffers in a zk notebook that match the given filetypes
        auto_attach = {
          enabled = true,
        },
      },
  })
