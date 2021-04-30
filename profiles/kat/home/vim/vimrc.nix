{ config, pkgs }:

''
  " Enable mouse 
  set mouse=a

  " colors
  let base16colorspace=256
  colorscheme base16-default-dark

  " tabline
  let g:airline#extensions#tabline#enabled = 1

  " notmuch! 
  let g:notmuch_config_file='${config.xdg.configHome}/notmuch/notmuchrc'
  let g:notmuch_folders_count_threads=0
  let g:notmuch_date_format='%y-%m-%d %H:%M'
  let g:notmuch_datetime_format='%y-%m-%d %H:%M'
  let g:notmuch_show_date_format='%Y/%m/%d  %H:%M'
  let g:notmuch_search_date_format='%Y/%m/%d  %H:%M'
  let g:notmuch_html_converter='${pkgs.elinks}/bin/elinks --dump'

  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
      \ quit | endif
  autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
      \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
  nnoremap <leader>n :NERDTreeFocus<CR>
  nnoremap <C-n> :NERDTree<CR>
  nnoremap <C-t> :NERDTreeToggle<CR>
  nnoremap <C-f> :NERDTreeFind<CR>

  let g:coc_node_path='${pkgs.nodejs}/bin/node'

  set undodir=$XDG_DATA_HOME/vim/undo
  set directory=$XDG_DATA_HOME/vim/swap//
  set backupdir=$XDG_DATA_HOME/vim/backup

  set number
  set hidden
  set nobackup
  set nowritebackup
  set cmdheight=2
  set updatetime=300
  set cursorline
  set colorcolumn=100
  set linebreak showbreak=↪ " ↳
  set hlsearch
  set relativenumber
  set completeopt=longest,menuone

'' + (if config.deploy.profile.sway then ''
  noremap "+y y:call system("wl-copy", @")<CR>
  nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', ''', 'g')<CR>p
  nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', ''', 'g')<CR>p
'' else
  "")
