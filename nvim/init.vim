:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set mouse=a
:set modifiable

:set noma 
syntax on

"====== VIM PLUGINS w/ VimPlug (Neovim plugin manager) ======
" The default plugin directory for Vim (Linux/macOS): '~/.vim/plugged'
call plug#begin() "vimplug 
"Color scheme
Plug 'rebelot/kanagawa.nvim'

"NerdTree
Plug 'preservim/nerdtree'

"Telescope dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
call plug#end()

"====== VIM PLUGIN Settings ======
"Colorscheme setting
colorscheme kanagawa 

let NERDTreeShowHidden=1

" let - define variables (strings, numerals)
let mapleader = "\<Space>" " Set the leader key to the spacebar (for example)

"====== VIM KEYMAPS ======
"To specify keymaps in vim
"SYNTAX: nnoremap <key> {command}<CR>
"- nnoremap = Normal-mode NOn-REcursive MAPping
"- <CR> = makes Vim simulate pressing Enter to execute the command
nnoremap <C-n> :NERDTreeToggle<CR> "ctrl+n
nnoremap <leader>pf :Telescope find_files<CR>
nnoremap <leader>pg :Telescope grep_string<CR>

" Normal mode: <space>yy yanks the whole line into system clipboard (Apr 19, 2023)
nnoremap <leader>yy "*yy

" Visual mode: <space>y yanks the highlighted into system clipboard (Unmapped <D-c> (cmd + c), replaced with) (Apr 19, 2023)
vnoremap <leader>y "*y
