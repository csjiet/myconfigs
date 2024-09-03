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
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter", 
		build = ":TSUpdate"
	},

	{
		"rebelot/kanagawa.nvim"
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

	-- SLOW for big files!
	-- { 
	-- 	"lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} 
	-- },
	{
		'stevearc/oil.nvim',
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
	}

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

-- Indent blankline plugin
-- local blankline = require("ibl")
-- blankline.setup()

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



-- oil.nvim file explorer
require("oil").setup({
	-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
	-- Set to false if you still want to use netrw.
	default_file_explorer = true,
	-- Id is automatically added at the beginning, and name at the end
	-- See :help oil-columns
	columns = {
		"icon",
		-- "permissions",
		-- "size",
		-- "mtime",
	},
	-- Buffer-local options to use for oil buffers
	buf_options = {
		buflisted = false,
		bufhidden = "hide",
	},
	-- Window-local options to use for oil buffers
	win_options = {
		wrap = false,
		signcolumn = "no",
		cursorcolumn = false,
		foldcolumn = "0",
		spell = false,
		list = false,
		conceallevel = 3,
		concealcursor = "nvic",
	},
	-- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
	delete_to_trash = false,
	-- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
	skip_confirm_for_simple_edits = false,
	-- Selecting a new/moved/renamed file or directory will prompt you to save changes first
	-- (:help prompt_save_on_select_new_entry)
	prompt_save_on_select_new_entry = true,
	-- Oil will automatically delete hidden buffers after this delay
	-- You can set the delay to false to disable cleanup entirely
	-- Note that the cleanup process only starts when none of the oil buffers are currently displayed
	cleanup_delay_ms = 2000,
	lsp_file_methods = {
		-- Time to wait for LSP file operations to complete before skipping
		timeout_ms = 1000,
		-- Set to true to autosave buffers that are updated with LSP willRenameFiles
		-- Set to "unmodified" to only save unmodified buffers
		autosave_changes = false,
	},
	-- Constrain the cursor to the editable parts of the oil buffer
	-- Set to `false` to disable, or "name" to keep it on the file names
	constrain_cursor = "editable",
	-- Set to true to watch the filesystem for changes and reload oil
	experimental_watch_for_changes = false,
	-- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
	-- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
	-- Additionally, if it is a string that matches "actions.<name>",
	-- it will use the mapping at require("oil.actions").<name>
	-- Set to `false` to remove a keymap
	-- See :help oil-actions for a list of all available actions
	keymaps = {
		["g?"] = "actions.show_help",
		["<CR>"] = "actions.select",
		["<C-s>"] = "actions.select_vsplit",
		["<C-h>"] = "actions.select_split",
		["<C-t>"] = "actions.select_tab",
		["<C-p>"] = "actions.preview",
		["<C-u>"] = "actions.preview_scroll_up",
		["<C-d>"] = "actions.preview_scroll_down",
		["<C-r>"] = "actions.rename",
		["<C-r>"] = "actions.refresh",
		["<C-c>"] = "actions.close",
		["<C-l>"] = "actions.refresh",
		["-"] = "actions.parent",
		["_"] = "actions.open_cwd",
		["`"] = "actions.cd",
		["~"] = "actions.tcd",
		["gs"] = "actions.change_sort",
		["gx"] = "actions.open_external",
		["g."] = "actions.toggle_hidden",
		["g\\"] = "actions.toggle_trash",
	},
	-- Set to false to disable all of the above keymaps
	use_default_keymaps = true,
	view_options = {
		-- Show files and directories that start with "."
		show_hidden = false,
		-- This function defines what is considered a "hidden" file
		is_hidden_file = function(name, bufnr)
			return vim.startswith(name, ".")
		end,
		-- This function defines what will never be shown, even when `show_hidden` is set
		is_always_hidden = function(name, bufnr)
			return false
		end,
		-- Sort file names in a more intuitive order for humans. Is less performant,
		-- so you may want to set to false if you work with large directories.
		natural_order = true,
		sort = {
			-- sort order can be "asc" or "desc"
			-- see :help oil-columns to see which columns are sortable
			{ "type", "asc" },
			{ "name", "asc" },
		},
	},
	-- Extra arguments to pass to SCP when moving/copying files over SSH
	extra_scp_args = {},
	-- EXPERIMENTAL support for performing file operations with git
	git = {
		-- Return true to automatically git add/mv/rm files
		add = function(path)
			return false
		end,
		mv = function(src_path, dest_path)
			return false
		end,
		rm = function(path)
			return false
		end,
	},
	-- Configuration for the floating window in oil.open_float
	float = {
		-- Padding around the floating window
		padding = 2,
		max_width = 100,
		max_height = 50,
		border = "rounded",
		win_options = {
			winblend = 0,
		},
		-- This is the config that will be passed to nvim_open_win.
		-- Change values here to customize the layout
		override = function(conf)
			return conf
		end,
	},
	-- Configuration for the actions floating preview window
	preview = {
		-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		-- min_width and max_width can be a single value or a list of mixed integer/float types.
		-- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
		max_width = 0.9,
		-- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
		min_width = { 40, 0.4 },
		-- optionally define an integer/float for the exact width of the preview window
		width = nil,
		-- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		-- min_height and max_height can be a single value or a list of mixed integer/float types.
		-- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
		max_height = 0.9,
		-- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
		min_height = { 5, 0.1 },
		-- optionally define an integer/float for the exact height of the preview window
		height = nil,
		border = "rounded",
		win_options = {
			winblend = 0,
		},
		-- Whether the preview window is automatically updated when the cursor is moved
		update_on_cursor_moved = true,
	},
	-- Configuration for the floating progress window
	progress = {
		max_width = 0.9,
		min_width = { 40, 0.4 },
		width = nil,
		max_height = { 10, 0.9 },
		min_height = { 5, 0.1 },
		height = nil,
		border = "rounded",
		minimized_border = "none",
		win_options = {
			winblend = 0,
		},
	},
	-- Configuration for the floating SSH window
	ssh = {
		border = "rounded",
	},
	-- Configuration for the floating keymaps help window
	keymaps_help = {
		border = "rounded",
	},
})


-- nvim cmp (auto completion)
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "luasnip" }, -- For luasnip users.
		-- { name = "orgmode" },
		}, {
			{ name = "buffer" },
			{ name = "path" },
	}),
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
		}, {
			{ name = "cmdline" },
	}),
})



-------- Loading Plugins -------- 
vim.cmd("colorscheme kanagawa")


-------- Vim Keymaps for plugins -------- 
---YANK! Choose one depending on usage ---
-- OSC52: REMOTE yank into local system clipboard
-- vim.keymap.set('n', '<leader>y', osc52.copy_operator, {expr = true})
-- vim.keymap.set('n', '<leader>yy', '<leader>c_', {remap = true})
-- vim.keymap.set('v', '<leader>y', osc52.copy_visual)

-- LOCAL yank into local system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Telescope
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ls', ":Telescope buffers<CR>", {}) -- Or: vim.keymap.set('n', '<leader>fb', builtin.buffers, {})


-- NERDTree
-- vim.keymap.set('n', '<C-n>', ':NERDTreeToggle<CR>')

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

-- Oil
vim.keymap.set('n', '<C-n>', ':Oil<CR>')
-- vim.keymap.set("n", "<C-n>", ":lua require('oil').open_float()<CR>") -- floating window
