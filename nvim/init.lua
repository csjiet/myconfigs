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
vim.cmd("set mouse=v") -- Allows mouse highlight and copy in terminal shell. Credits: https://superuser.com/questions/436890/cant-copy-to-clipboard-from-vim 
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

-- show vim buffer and type buffer number to switch to that buffer (Creds: https://www.reddit.com/r/vim/comments/u2v0fi/how_do_you_manage_buffers/)
vim.keymap.set("n", "<leader>ls", ":ls<CR>:b<space>")

-- Rotate split buffers (Creds: https://stackoverflow.com/questions/1269603/to-switch-from-vertical-split-to-horizontal-split-fast-in-vim)
-- vim.keymap.set("n", "<leader>rh", "<C-w>t<C-w>K")
-- vim.keymap.set("n", "<leader>rv", "<C-w>t<C-w>H")


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
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
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
	-- OSC52 --- yank and paste in remote development (Creds: https://github.com/ojroques/nvim-osc52)
	-- Super legendary plugin allows us to travel through the clouds
	{
		'ojroques/nvim-osc52',
	},

}

local opts = {}


-------- Call and Define (Plugins) Setup for Lua script libraries -------- 
require("lazy").setup(plugins, opts)


-- Telescope
local builtin = require('telescope.builtin')
--- Delete buffers from within Telescope. Creds: https://www.reddit.com/r/neovim/comments/qspemc/close_buffers_with_telescope/
local tele = require('telescope')
tele.setup({
	defaults = {
		-- Default configuration for telescope goes here:
		-- config_key = value,
		mappings = {
			n = {
				['<c-x>'] = require('telescope.actions').delete_buffer
			}, -- n
			i = {
				["<C-h>"] = "which_key",
				['<c-x>'] = require('telescope.actions').delete_buffer
			} -- i
		} -- mappings
	}, -- defaults
})

-- OSC52 remote yank and paste
local osc52 = require('osc52')
osc52.setup()

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
-- vim.g.lightline = {
-- 	colorscheme = 'wombat',
-- }

local lualine = require('lualine')
lualine.setup {
	options = { icons_enabled = true,
		theme = 'auto', },
	sections = { lualine_a = {
		{'filename',file_status = true, -- Displays file status (readonly status, modified status) newfile_status = false,
			-- Display new file status (new file means no write after created)
			path = 1,
			-- 0: Just the filename
			-- 1: Relative path
			-- 2: Absolute path
			-- 3: Absolute path, with tilde as the home directory
			-- 4: Filename and parent dir, with tilde as the home directory
			shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
			-- for other components. (terrible name, any suggestions?)
			symbols = {
				modified = '[+]',      -- Text to show when the file is modified.
				readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
				unnamed = '[No Name]', -- Text to show for unnamed buffers.
				newfile = '[New]',     -- Text to show for newly created file before first write
			}
		}
		}
	}
}

local function get_filepath(hl_grps)
	local cur_path = vim.fn.expand("%:p")
	local home = vim.fs.find(".git", {
		path = cur_path,
		upward = true,
		type = "directory"
	})[1]

	if home == nil then
		return cur_path
	end

	home = vim.fs.dirname(home)

	local root = table.concat({
		hl_grps["Muted"],
		vim.fs.dirname(home),
		'/',
		"%*"
	})

	local trunk = table.concat({
		hl_grps["Warn"],
		vim.fs.basename(home),
		'/',
		"%*",
		vim.fn.expand("%r"),
	})

	return root .. trunk
end


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
-- OSC52
vim.keymap.set('n', '<leader>y', osc52.copy_operator, {expr = true})
vim.keymap.set('n', '<leader>yy', '<leader>c_', {remap = true})
vim.keymap.set('v', '<leader>y', osc52.copy_visual)

-- Telescope
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ls', ":Telescope buffers<CR>", {}) -- Or: vim.keymap.set('n', '<leader>fb', builtin.buffers, {})


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
