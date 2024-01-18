colo evening " Color 

syntax on

set number

set undofile

" Set <leader> = <" "> (spacebar) (Apr 19, 2023)
let g:mapleader = " "

" Normal mode: <space>yy yanks the whole line into system clipboard (Apr 19, 2023)
nnoremap <leader>yy "*yy

" Visual mode: <space>y yanks the highlighted into system clipboard (Unmapped <D-c> (cmd + c), replaced with) (Apr 19, 2023)
vnoremap <leader>y "*y
