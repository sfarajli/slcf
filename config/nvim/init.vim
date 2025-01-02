" Suleyman's minimal vim config for servers
" at https://git.farajli.net/slcf

let mapleader = " "
set number
set scrolloff=5 			" Smooth scroll
set clipboard=unnamedplus		" Use system clipboard
set shortmess+=I 			" Deactivate intro text
set fillchars=eob:\  			" Remove "~" for empty lines (`eob:\` must end with a trailing space)
:set nowrap				" Disable wrapping
autocmd BufwritePost * %s/\s\+$//e 	" Remove useless trailing spaces when saving
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o " Disable autocomments

" Different cursor shapes for insert and normal modes
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
set ttimeout
set ttimeoutlen=1
set ttyfast

" Normal mode maps
map <leader><leader> :w!<CR>
map <leader>q :wqa!<CR>
map <C-t> :tabnew<CR>
map <C-w> :tabclose!<CR>
map J :tabn <CR>
map K :tabp <CR>

" Insert mode maps
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> <C-o>gj
inoremap <C-k> <C-o>gk
inoremap <C-o> <C-o>o

set background=dark
