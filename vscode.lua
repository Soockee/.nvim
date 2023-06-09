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
}
end)


local function notify(cmd)
    return string.format("<cmd>call VSCodeNotify('%s')<CR>", cmd)
end

local function v_notify(cmd)
    return string.format("<cmd>call VSCodeNotifyVisual('%s', 1)<CR>", cmd)
end

-- split screen and navigation

-- vim.keymap.set('n', '<Leader>v', ':vsplit<CR><C-w>l', {noremap =true, silent = true }) -- language references


vim.keymap.set('n', '<Leader>v', notify 'workbench.action.splitEditorRight', { silent = true }) -- language references
vim.keymap.set('n', '<Leader>l', notify 'workbench.action.focusNextGroup', { silent = true }) -- language references
vim.keymap.set('n', '<Leader>h', notify 'workbench.action.focusPreviousGroup', { silent = true }) -- language references
vim.keymap.set('n', '<Leader>xr', notify 'references-view.findReferences', { silent = true }) -- language references
vim.keymap.set('n', '<Leader>xd', notify 'workbench.actions.view.problems', { silent = true }) -- language diagnostics
vim.keymap.set('n', 'gr', notify 'editor.action.goToReferences', { silent = true })
vim.keymap.set('n', '<Leader>rn', notify 'editor.action.rename', { silent = true })
vim.keymap.set('n', '<Leader>fm', notify 'editor.action.formatDocument', { silent = true })
vim.keymap.set('n', '<Leader>ca', notify 'editor.action.refactor', { silent = true }) -- language code actions

vim.keymap.set('n', '<Leader>rg', notify 'workbench.action.findInFiles', { silent = true }) -- use ripgrep to search files
vim.keymap.set('n', '<Leader>ts', notify 'workbench.action.toggleSidebarVisibility', { silent = true })
vim.keymap.set('n', '<Leader>th', notify 'workbench.action.toggleAuxiliaryBar', { silent = true }) -- toggle docview (help page)
vim.keymap.set('n', '<Leader>tp', notify 'workbench.action.togglePanel', { silent = true })
vim.keymap.set('n', '<Leader>fc', notify 'workbench.action.showCommands', { silent = true }) -- find commands
vim.keymap.set('n', '<Leader>ff', notify 'workbench.action.quickOpen', { silent = true }) -- find files
vim.keymap.set('n', '<Leader>tw', notify 'workbench.action.terminal.toggleTerminal', { silent = true }) -- terminal window

vim.keymap.set('v', '<Leader>fm', v_notify 'editor.action.formatSelection', { silent = true })
vim.keymap.set('v', '<Leader>ca', v_notify 'editor.action.refactor', { silent = true })
vim.keymap.set('v', '<Leader>fc', v_notify 'workbench.action.showCommands', { silent = true })



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

-- VSCode-Color Change on mode
vim.api.nvim_exec([[
    " THEME CHANGER
    function! SetCursorLineNrColorInsert(mode)
        " Insert mode: blue
        if a:mode == "i"
            call VSCodeNotify('nvim-theme.insert')

        " Replace mode: red
        elseif a:mode == "r"
            call VSCodeNotify('nvim-theme.replace')
        endif
    endfunction

    augroup CursorLineNrColorSwap
        autocmd!
        autocmd ModeChanged *:[vV\x16]* call VSCodeNotify('nvim-theme.visual')
        autocmd ModeChanged *:[R]* call VSCodeNotify('nvim-theme.replace')
        autocmd InsertEnter * call SetCursorLineNrColorInsert(v:insertmode)
        autocmd InsertLeave * call VSCodeNotify('nvim-theme.normal')
        autocmd CursorHold * call VSCodeNotify('nvim-theme.normal')
    augroup END
]], false)


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


