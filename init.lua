print("Welcome Simon! How are you doing today?")

vim.g.mapleader = " "

-- vim.g.go_debug_windows = {
--       vars = 'rightbelow 50vnew',
--       stack ='rightbelow 10new',
-- }

require("packer").startup(function(use)
	use { "wbthomason/packer.nvim" }
	use { "ellisonleao/gruvbox.nvim" }
	-- debugger
	use {'leoluz/nvim-dap-go'}
	use { 
		"rcarriga/nvim-dap-ui", 
		requires = {"mfussenegger/nvim-dap"} 
	}

	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
	use {'theHamsta/nvim-dap-virtual-text'}
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		 requires = { {'nvim-lua/plenary.nvim'} }
	}
	use {
	  'nvim-lualine/lualine.nvim',
	   requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}
	use { "fatih/vim-go" }
		use {
		'VonHeikemen/lsp-zero.nvim',
  		branch = 'v1.x',
  		requires = {
		{'neovim/nvim-lspconfig'},             -- Required
		{'williamboman/mason.nvim'},           -- Optional
		{'williamboman/mason-lspconfig.nvim'}, -- Optional
		{'hrsh7th/nvim-cmp'},         -- Required
		{'hrsh7th/cmp-nvim-lsp'},     -- Required
		{'hrsh7th/cmp-buffer'},       -- Optional
		{'hrsh7th/cmp-path'},         -- Optional
		{'saadparwaiz1/cmp_luasnip'}, -- Optional
		{'hrsh7th/cmp-nvim-lua'},     -- Optional
		{'L3MON4D3/LuaSnip'},             -- Required
		{'rafamadriz/friendly-snippets'}, -- Optional
  	},
	use {"akinsho/toggleterm.nvim", tag = '*' },
	use {
  	    "folke/which-key.nvim",
  	    config = function()
	    	vim.o.timeout = true
   	 	vim.o.timeoutlen = 300
    		require("which-key").setup {
     	 	-- your configuration comes here
     	 	-- or leave it empty to use the default settings
     	 	-- refer to the configuration section below
    		}
  	     end
	},
	use "jhlgns/naysayer88.vim",
	use "terrortylor/nvim-comment",
	use "CreaturePhil/vim-handmade-hero"
}
end)

-- some
vim.keymap.set("n", "<M-b>", ":Ex<CR>")

-- split screen and navigation
vim.keymap.set("n", "<leader>v", ":vsplit<CR><C-w>l", { noremap = true })
vim.keymap.set("n", "<leader>h", ":wincmd h<CR>", { noremap = true })
vim.keymap.set("n", "<leader>l", ":wincmd l<CR>", { noremap = true })

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>f', function()
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
  		previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>p', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<M-p>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', 'd', '"_d', { nowait = true, desc = 'Delete Line without cut'})
vim.keymap.set('v', 'd', '"_d', { nowait = true, desc = 'Delete Line without cut'})

-- TREESITTER
require'nvim-treesitter.configs'.setup {
	ensure_installed = {"c", "lua", "vim", "go", "javascript", "typescript", "rust"},
	highlight = {
		enable = true,
	}
}

-- GRUVBOX
require("gruvbox").setup({
	contrast = "hard",
	palette_overrides = {
		gray = "#2ea542",
	}
})

-- LUALINE
require("lualine").setup{
	options = {
		icons_enabled = false,
		theme = "onedark",
		component_separators = "|",
		section_separators = "",
	},
}

-- LSP
local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
	"tsserver",
	"gopls",
	"eslint",
	"rust_analyzer",
})

lsp.set_preferences({
	sign_icons = {}
})

lsp.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}
	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
end)

lsp.setup()

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		signs = false,
		virtual_text = true,
		underline = false,
	}
)

-- Debugger
require("dapui").setup()
require('dap-go').setup()

-- COMMENT
require("nvim_comment").setup({
	operator_mapping = "<leader>/"
})

-- TERMINAL SETUP
require("toggleterm").setup{
	direction = "horizontal",
	size = 15,
	open_mapping = [[<M-j>]]
}


-- COLORSCHEME
vim.cmd("colorscheme gruvbox")
-- Adding the same comment color in each theme
vim.cmd([[
	augroup CustomCommentCollor
		autocmd!
		autocmd VimEnter * hi Comment guifg=#2ea542
	augroup END
]])

-- Open Dap-UI automatically on Debug session
local dap, dapui =require("dap"),require("dapui")
dap.listeners.after.event_initialized["dapui_config"]=function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"]=function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"]=function()
  dapui.close()
end

-- nicer icons for debug
vim.fn.sign_define('DapBreakpoint',{ text ='🟥', texthl ='', linehl ='', numhl =''})
vim.fn.sign_define('DapStopped',{ text ='▶️', texthl ='', linehl ='', numhl =''})

-- debug keymaps
local dap = require('dap')
local dapgo = require('dap-go')
vim.keymap.set('n', '<F5>', dap.continue)
vim.keymap.set('n', '<F10>', dap.step_over)
vim.keymap.set('n', '<F11>', dap.step_into)
vim.keymap.set('n', '<F12>', dap.step_out)
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>t', dapgo.debug_test, { silent = true })


-- Disable annoying match brackets and all the jaz
vim.cmd([[
	augroup CustomHI
		autocmd!
		autocmd VimEnter * NoMatchParen 
	augroup END
]])

vim.o.background = "dark"

vim.keymap.set("i", "jj", "<Esc>")

vim.opt.guicursor = "i:block"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = false
vim.opt.relativenumber = true
vim.opt.swapfile = false

vim.o.hlsearch = true
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
--vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true
