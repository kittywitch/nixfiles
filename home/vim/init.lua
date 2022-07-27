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
vim.cmd("colorscheme base16-default-dark")    -- Color scheme
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
opt.termguicolors = true                      -- Enable 24-bit RGB colors
opt.laststatus = 3                            -- Set global statusline
opt.cursorline = true                         -- Highlight cursor screenline
opt.cmdheight = 1                             -- Command entry line height
opt.hlsearch = true                           -- Highlight matches with last search pattern

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = false       -- Use spaces instead of tabs
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
opt.history = 100           -- Remember N lines in history
opt.lazyredraw = true       -- Faster scrolling
opt.synmaxcol = 240         -- Max column for syntax highlight
opt.updatetime = 700        -- ms to wait for trigger an event

-----------------------------------------------------------
-- Base16
-----------------------------------------------------------
vim.base16colorspace=256

api.nvim_create_autocmd("vimenter", {
	command = "highlight Normal guibg=NONE ctermbg=NONE"
})
api.nvim_create_autocmd("SourcePost", {
	command = "highlight Normal     ctermbg=NONE guibg=NONE | " ..
		"highlight LineNr     ctermbg=NONE guibg=NONE | " ..
		"highlight SignColumn ctermbg=NONE guibg=NONE"
})

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
		theme = "base16",
	},
})

-- nvim-cmp
local cmp = require('cmp')

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		['<C-y>'] = cmp.mapping.confirm({ select = true }),
	},
	sources = {
		{ name = 'neorg' },
	}
})

-- lspconfig
require('lspconfig').terraformls.setup{}

api.nvim_create_autocmd('BufWritePre', {
	pattern = '*.tf',
	command = 'lua vim.lsp.buf.formatting_sync()'
})

-- neorg
require('neorg').setup {
	-- Tell Neorg what modules to load
	load = {
		['core.defaults'] = {}, -- Load all the default modules
		['core.norg.concealer'] = {}, -- Allows for use of icons
		['core.norg.dirman'] = { -- Manage your directories with Neorg
			config = {
				engine = 'nvim-cmp',
				workspaces = {
					home = '~/neorg'
				}
			}
		}
	},
}

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
		"c",
		"lua",
		"rust",
		"bash",
		"css",
		"dockerfile",
		"go",
		"hcl",
		"html",
		"javascript",
		"markdown",
		"nix",
		"norg",
		"python",
		"regex",
		"scss",
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

-- bufferline
require('bufferline').setup {
	options = {
		mode = "buffers", -- set to "tabs" to only show tabpages instead
		numbers = "ordinal",
		close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
		right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
		left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
		middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
		indicator_icon = '▎',
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
		separator_style = "padded_slant",
		always_show_bufferline = true,
	}
}

local barColor = base16.base00;

local highlightItems = {
	BufferLineFill = "bg",
	BufferLineBackground = "bg",
	BufferLineSeparator = "fg",
	BufferLineSeparatorSelected = "fg",
	BufferLineSeparatorVisible = "fg",
}

local commandString = ""

for item, ground in pairs(highlightItems) do
	commandString = "highlight " .. item .. " gui" .. ground .. "=" .. barColor .. " | " .. commandString
end

api.nvim_create_autocmd("ColorScheme", {
	command = commandString;
})

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
