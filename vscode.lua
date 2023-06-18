print("Welcome Simon! How are you doing today?")

vim.g.mapleader = " "

-- vim.g.go_debug_windows = {
--       vars = 'rightbelow 50vnew',
--       stack ='rightbelow 10new',
-- }

require("packer").startup(function(use)
	use { "wbthomason/packer.nvim" }
	use { "ellisonleao/gruvbox.nvim" }
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

--
-- local function notify(cmd)
--     return string.format("<cmd>call VSCodeNotify('%s')<CR>", cmd)
-- end
--
-- local function v_notify(cmd)
--     return string.format("<cmd>call VSCodeNotifyVisual('%s', 1)<CR>", cmd)
-- end

-- split screen and navigation


-- some
vim.keymap.set("n", "<M-b>", ":Ex<CR>")

vim.keymap.set('n', 'd', '"_d', { nowait = true, desc = 'Delete Line without cut'})
vim.keymap.set('v', 'd', '"_d', { nowait = true, desc = 'Delete Line without cut'})

-- vim.keymap.set('n', '<Leader>v', notify 'workbench.action.splitEditorRight', { silent = true }) -- language references
-- vim.keymap.set('n', '<Leader>l', notify 'workbench.action.focusNextGroup', { silent = true }) -- language references
-- vim.keymap.set('n', '<Leader>h', notify 'workbench.action.focusPreviousGroup', { silent = true }) -- language references
-- vim.keymap.set('n', '<Leader>xr', notify 'references-view.findReferences', { silent = true }) -- language references
-- vim.keymap.set('n', '<Leader>xd', notify 'workbench.actions.view.problems', { silent = true }) -- language diagnostics
-- vim.keymap.set('n', 'gd', notify 'editor.action.goToReferences', { silent = true })
-- vim.keymap.set('n', '<Leader>rn', notify 'editor.action.rename', { silent = true })
-- vim.keymap.set('n', '<Leader>fm', notify 'editor.action.formatDocument', { silent = true })
-- vim.keymap.set('n', '<Leader>ca', notify 'editor.action.refactor', { silent = true }) -- language code actions
--
-- vim.keymap.set('n', '<Leader>f', notify 'actions.find', { silent = true }) -- language code actions
--
-- vim.keymap.set('n', '<Leader>p', notify 'workbench.action.quickOpen', { silent = true }) -- search file
-- vim.keymap.set('n', '<Leader>rg', notify 'workbench.action.findInFiles', { silent = true }) -- use ripgrep to search files
-- vim.keymap.set('n', '<Leader>ts', notify 'workbench.action.toggleSidebarVisibility', { silent = true })
-- vim.keymap.set('n', '<Leader>th', notify 'workbench.action.toggleAuxiliaryBar', { silent = true }) -- toggle docview (help page)
-- vim.keymap.set('n', '<Leader>tp', notify 'workbench.action.togglePanel', { silent = true })
-- vim.keymap.set('n', '<Leader>fc', notify 'workbench.action.showCommands', { silent = true }) -- find commands
-- vim.keymap.set('n', '<Leader>tw', notify 'workbench.action.terminal.toggleTerminal', { silent = true }) -- terminal window
--
-- vim.keymap.set('v', '<Leader>fm', v_notify 'editor.action.formatSelection', { silent = true })
-- vim.keymap.set('v', '<Leader>ca', v_notify 'editor.action.refactor', { silent = true })
-- vim.keymap.set('v', '<Leader>fc', v_notify 'workbench.action.showCommands', { silent = true })
--

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


