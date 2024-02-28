set number relativenumber
set viminfofile=~/.config/vim/.viminfo
syntax on

call plug#begin()

Plug 'chriskempson/base16-vim'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }

call plug#end()

colorscheme base16-twilight
highlight clear LineNr


hi NonText ctermbg=none
hi Normal guibg=NONE ctermbg=NONE
