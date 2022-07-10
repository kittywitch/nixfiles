local g = vim.g       -- Global variables
local opt = vim.opt   -- Set options (global/buffer/windows-scoped)
local api = vim.api   -- Lua API

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = 'a'                                                        -- Enable mouse support
opt.clipboard = 'unnamedplus'                                          -- Copy/paste to system clipboard
opt.completeopt = 'longest,menuone'                                    -- Autocomplete options
opt.backup = false                                                     -- Disable backup
opt.writebackup = false                                                -- Disable backup
opt.ttimeoutlen = 100                                                  -- Mapping timeout

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
vim.cmd("colorscheme base16-default-dark")                                      -- Color scheme
opt.number = true                                                               -- Show line number
opt.relativenumber = true                                                       -- Relative line numbers
opt.showmatch = true                                                            -- Highlight matching parenthesis
opt.foldmethod = 'marker'                                                       -- Enable folding (default 'foldmarker')
opt.colorcolumn = '80'                                                          -- Line length marker at 80 columns
opt.splitright = true                                                           -- Vertical split to the right
opt.splitbelow = true                                                           -- Horizontal split to the bottom
opt.ignorecase = true                                                           -- Ignore case letters when search
opt.smartcase = true                                                            -- Ignore lowercase for the whole pattern
opt.linebreak = true                                                            -- Wrap on word boundary
opt.showbreak = " ↳"                                                            -- Character to use to display word boundary
opt.termguicolors = true                                                        -- Enable 24-bit RGB colors
opt.laststatus = 3                                                              -- Set global statusline
opt.listchars = 'tab:» ,extends:›,precedes:‹,nbsp:·,trail:✖'                    -- Set listmode options
opt.cursorline = true                                                           -- Highlight cursor screenline
opt.cmdheight = 1                                                               -- Command entry line height
opt.hlsearch = true                                                             -- Highlight matches with last search pattern

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = false       -- Use spaces instead of tabs
opt.shiftwidth = 4          -- Shift 4 spaces when tab
opt.tabstop = 4             -- 1 tab == 4 spaces
opt.smartindent = true      -- Autoindent new lines

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

-- nvim-cmp
local cmp = require'cmp'

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
require'lspconfig'.terraformls.setup{}
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
api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true, silent = true })

-- hop
vim.api.nvim_set_keymap('', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('', 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", {})
vim.api.nvim_set_keymap('', 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>", {})
