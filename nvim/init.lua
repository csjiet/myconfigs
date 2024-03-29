-- Lua NeoVim guide: https://github.com/nanotee/nvim-lua-guide
-- Pattern of adding plugins:
-- 1. Add the plugin in the plugins table (local plugins = {})
-- 2. Setup the plugin by calling the setup function (require("plugin_name".setup({})))

---------- Vim keymaps ---------- 
vim.cmd("set number") -- vim script to lua conversion
vim.cmd("set relativenumber")
vim.cmd("set autoindent")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set smarttab")
vim.cmd("set mouse=a")
vim.cmd("set termguicolors")
vim.cmd("syntax on")
vim.opt.scrolloff = 8 -- screen estate during scrolling always keeps 8 lines below 
vim.opt.termguicolors = true
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.g.mapleader = " "

-- Adjust size of pane 
vim.keymap.set("n", "<C-w>+", ":resize +10<CR>")
vim.keymap.set("n", "<C-w>-", ":resize -10<CR>")
vim.keymap.set("n", "<C-w><", ":vertical resize -10<CR>")
vim.keymap.set("n", "<C-w>>", ":vertical resize +10<CR>")

-- Creds: https://www.youtube.com/watch?v=w7i4amO_zaE&t
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- downward half page scroll keeps cursor in middle
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- upward half page scroll keeps cursor in middle
vim.keymap.set("n", "n", "nzzzv") -- jumping to next search term which is kept in the middle 
vim.keymap.set("n", "N", "Nzzzv") -- jumping to previous search term which is kept in the middle

-- Copy/yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")


-- Exit from vim terminal mode (Creds: https://www.reddit.com/r/neovim/comments/yg2d9v/how_do_i_exit_the_terminal_mode/)
vim.keymap.set("t", "<leader>et", "<C-\\><C-n>") 


-- NetRW remap to mimic NERDTREE/ NEOTree (Creds: https://www.youtube.com/watch?v=ID6ZcW6oMM0)
-- vim.keymap.set("i", "<C-n>", "<Esc>:Lex<CR> :vertical resize 30<CR>")
-- vim.keymap.set("n", "<C-n>", "<Esc>:Lex<CR> :vertical resize 30<CR>")
-- -- NetRW config (Creds: "https://www.youtube.com/watch?v=nDGhjk4Eqbc&t")
-- vim.g.netrw_liststyle = 3
-- vim.g.netrw_browse_split = 4 -- :help g:netrw_browse_split 


---------- Meta-Installations ---------- 
-- Adding scripts: Install
-- Removing scripts: Auto-detect absence and Uninstall
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- If path to lazy is not found, clone repo
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)


--------- Install Plugins --------- 
local plugins = {
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		"nvim-treesitter/nvim-treesitter", 
		build = ":TSUpdate"
	},

	{
		"rebelot/kanagawa.nvim"
	}, 

	-- file system explorer
	{
		"preservim/nerdtree"
	},
	-- statusbar 
	{
		"itchyny/lightline.vim"	
	},

	-- git fugitive: Git command integration in vim
	{
		"tpope/vim-fugitive"	
	},
	-- git gutter: shows a git diff in the sign column. It shows which lines have been added, modified, or removed. (Creds for intro: https://www.youtube.com/watch?v=gfa2_6OeOkk)
	{
		"airblade/vim-gitgutter"	
	},

	-- markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},
	-- Github copilot
--	{
--		"github/copilot.vim"	
--	},
	-- LSPs  (Language Server Protocol)
	{
		-- Mason (manage external editor tooling such as LSP servers, DAP servers, linters, and formatters)
		"williamboman/mason.nvim", 
		-- Mason lspconfig (closes some gaps that exist between mason.nvim and lspconfig)
		"williamboman/mason-lspconfig.nvim",
	},
	-- NeoVim LSP Client
	{
		'neovim/nvim-lspconfig'
	},
	-- Codeium (Ai code completion)
	-- 1) Install Codeium
	-- 2) `:Codeium Auth`
	{
		'Exafunction/codeium.vim', 
		event = 'BufEnter'

	},

}

local opts = {}


-------- Call and Define (Plugins) Setup for Lua script libraries -------- 
require("lazy").setup(plugins, opts)


-- Telescope
local builtin = require('telescope.builtin')

-- Treesitter
local config = require('nvim-treesitter.configs')
config.setup({
	ensure_installed = {"lua", "python", "markdown"},
	hightlight = {enable = true},
	indent = {enable = true}

})

-- Color Scheme
local colors = require('kanagawa')
colors.setup({})

-- NERDTree
vim.g.NERDTreeShowHidden = 1

-- lightline status bar
vim.g.lightline = {
	colorscheme = 'wombat'
}

-- Mason
local mason = require('mason')
mason.setup()

-- Mason lspconfig
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({ ensure_installed = { "lua_ls", "pyright", "marksman" }})

-- Setup language servers.
local lspconfig = require('lspconfig')
-- setup each language server
lspconfig.pyright.setup({})
lspconfig.lua_ls.setup({})
lspconfig.marksman.setup({})

-------- Loading Plugins -------- 
vim.cmd("colorscheme kanagawa")


-------- Vim Keymaps for plugins -------- 
-- Telescope
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})

-- NERDTree
vim.keymap.set('n', '<C-n>', ':NERDTreeToggle<CR>')

-- Nvim lspconfig
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
