set encoding=utf-8
scriptencoding utf-8
set list listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:✖
" Enable mouse
set mouse=a

set viminfo='100000,<100000,s1000,h,n~/.local/share/vim/viminfo'
set ts=2
set sw=2

" colors
let base16colorspace=256
autocmd vimenter * highlight Normal guibg=NONE ctermbg=NONE
autocmd SourcePost * highlight Normal     ctermbg=NONE guibg=NONE
			\ |    highlight LineNr     ctermbg=NONE guibg=NONE
			\ |    highlight SignColumn ctermbg=NONE guibg=NONE

" tabline
let g:airline#extensions#tabline#enabled = 1

" hexokinaise
let g:Hexokinase_highlighters = ['virtual']
let g:Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla,colour_names'

" lastplace
let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"

set undodir=$XDG_DATA_HOME/vim/undo
set directory=$XDG_DATA_HOME/vim/swap//
set backupdir=$XDG_DATA_HOME/vim/backup

set ttimeoutlen=100
set number
set hidden
set nobackup
set nowritebackup
set cmdheight=1
set updatetime=300
set cursorline
set colorcolumn=100
set linebreak showbreak=↪ " ↳
set hlsearch
set relativenumber
set completeopt=longest,menuone

command Spaces set expandtab
command Tabs set noexpandtab
