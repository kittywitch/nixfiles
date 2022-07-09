local api = vim.api
local cmp = require'cmp'

-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------

-- nvim-cmp
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
