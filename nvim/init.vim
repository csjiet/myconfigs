:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set mouse=a

autocmd BufReadPost * set modifiable

syntax on

"====== VIM PLUGINS w/ VimPlug (Neovim plugin manager) ======
" The default plugin directory for Vim (Linux/macOS): '~/.vim/plugged'
call plug#begin() "start vimplug 
""Color scheme
Plug 'rebelot/kanagawa.nvim'

""Telescope dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

"Tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 

call plug#end() "end vimplug

"====== VIM Settings ======
" What does `let' do? - define variables (strings, numerals)
let mapleader = "\<Space>" " Set the leader key to the spacebar (for example)


""Colorscheme setting
colorscheme kanagawa 



""NetRW settings
let g:netrw_liststyle = 3 "Any click into a directory retains parent dir view 

"====== VIM KEYMAPS ======
""To specify keymaps in vim
""SYNTAX: nnoremap <key> {command}<CR>
""- nnoremap = Normal-mode NOn-REcursive MAPping
""- <CR> = makes Vim simulate pressing Enter to execute the command
"=========================

""NetRW remap
"No need for NERDTree when you have default NetRW and 2 lines of remap: Creds: https://www.youtube.com/watch?v=ID6ZcW6oMM0
inoremap <C-n> <Esc>:Lex<CR> :vertical resize 30<CR>
nnoremap <C-n> <Esc>:Lex<CR> :vertical resize 30<CR>

""Telescope plugin remap
nnoremap <leader>pf :Telescope find_files<CR>
nnoremap <leader>ps :Telescope grep_string<CR>



