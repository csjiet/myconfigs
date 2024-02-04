-- Lua NeoVim guide: https://github.com/nanotee/nvim-lua-guide

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
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.g.mapleader = " "


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
	{
		"github/copilot.vim"	
	}
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
colors.setup({
	compile = false,             -- enable compiling the colorscheme
	undercurl = true,            -- enable undercurls
	commentStyle = { italic = true },
	functionStyle = {},
	keywordStyle = { italic = true},
	statementStyle = { bold = true },
	typeStyle = {},
	transparent = true,         -- do not set background color
	dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
	terminalColors = true,       -- define vim.g.terminal_color_{0,17}
	colors = {                   -- add/modify theme and palette colors
		palette = {},
		theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
	},
	overrides = function(colors) -- add/modify highlights
		return {}
	end,
	theme = "wave",              -- Load "wave" theme when 'background' option is not set
	background = {               -- map the value of 'background' option to a theme
		dark = "wave",           -- try "dragon" !
		light = "lotus"
	},
})

-- lightline status bar
vim.g.lightline = {
    colorscheme = 'wombat'
}

-------- Loading Plugins -------- 
vim.cmd("colorscheme kanagawa")


-------- Vim Keymaps for plugins -------- 
-- Telescope
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})

-- NERDTree
vim.keymap.set('n', '<C-n>', ':NERDTreeToggle<CR>')


