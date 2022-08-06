" Standard config
set clipboard+=unnamed    " クリップボード連携
set cursorline            " カーソル行にラインを表示
set expandtab             " タブ入力を複数の空白入力に置き換える
set mouse=a               " 全てのモードでマウス操作を有効化
set shiftwidth=2          " インデント幅を指定
set smartindent           " 改行時のインデントを自動化
set tabstop=2             " タブ幅を指定
set updatetime=100        " ファイルの読み込み更新頻度
set number                " 行番号を表示
set ignorecase            " 大文字小文字を区別しない
set smartcase             " 大文字検索時、大文字小文字を区別する
set wrapscan              " 検索結果が最後までいったら最初に戻る
set fileencoding=utf-8    " ファイル書き込み時の文字コードをutf-8にする
set nobackup              " ファイル変更後に保存されるバックアップの~ファイルを作成しない
set noswapfile            " ファイル編集中に保存されるバックアップの.swpファイルを作成しない
set autoread              " ファイルを自動更新
let loaded_matchparen = 1 " 括弧のハイライトを非表示

" For ESC key mapping
inoremap <silent> jj <ESC>

" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Config for Neovim
let g:python3_host_prog = '/usr/local/bin/python3'

" 他のウィンドウ・アプリでの変更を反映する
au FocusGained,BufEnter * checktime

" Add plugIn by dein
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('Shougo/deoplete.nvim')

  " Syntax highlight of Languages
  call dein#add('derekwyatt/vim-scala')       " Scala
  call dein#add('gre/play2vim')               " Play
  call dein#add('leafgarland/typescript-vim') " Typescript
  call dein#add('fatih/vim-go')               " Go
  call dein#add('digitaltoad/vim-pug')        " Pug

  " coc.nvim
  call dein#add('neoclide/coc.nvim', {'branch': 'release'})
  call dein#add('antoinemadec/coc-fzf')

  " defx
  call dein#add('Shougo/defx.nvim')
  call dein#add('kristijanhusak/defx-git')

  " vim-airline
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')

  " fzf
  call dein#add('junegunn/fzf', {'build': './install --all'})
  call dein#add('junegunn/fzf.vim')

  " indent line
  call dein#add('Yggdroot/indentLine')

  " traces
  call dein#add('markonm/traces.vim')

  " easy align
  call dein#add('junegunn/vim-easy-align')
  
  " fugitive
  call dein#add('tpope/vim-fugitive')

  " auto pairs
  call dein#add('jiangmiao/auto-pairs')

  " closetag
  call dein#add('alvan/vim-closetag')

  " gitgutter
  call dein#add('airblade/vim-gitgutter')

  " material
  call dein#add('kaicataldo/material.vim', { 'branch': 'main' })

  " markdown preview
  call dein#add('iamcco/markdown-preview.nvim', {'on_ft': ['markdown', 'pandoc.markdown', 'rmd'],
					\ 'build': 'sh -c "cd app && yarn install"' })

  " easy motion
  call dein#add('easymotion/vim-easymotion')

  " rainbow parentheses
  call dein#add('junegunn/rainbow_parentheses.vim')

  " vim silicon
  call dein#add('segeljakt/vim-silicon')

  call dein#end()
  call dein#save_state()
endif

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

" For defx
" Key mapping of defx
autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  " 【o】 ファイルを表示／非表示する
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('open_or_close_tree')
  " 【CR】 ファイルを開く
  nnoremap <silent><buffer><expr> <CR>
  \ defx#is_directory() ?
  \   defx#do_action('open_tree_recursive') :
  \   defx#do_action('multi', ['drop', 'quit'])
  " 【i】 ウィンドウを水平分割してファイルを開く
  nnoremap <silent><buffer><expr> i
  \ defx#do_action('multi', [['drop', 'split'], 'quit'])
  " 【s】 ウィンドウを垂直分割してファイルを開く
  nnoremap <silent><buffer><expr> s
  \ defx#do_action('multi', [['drop', 'vsplit'], 'quit'])
  " 【c】 ファイルをコピーする
  nnoremap <silent><buffer><expr> c
  \ defx#do_action('copy')
  " 【m】 ファイルを移動する
  nnoremap <silent><buffer><expr> m
  \ defx#do_action('move')
  " 【p】 ファイルを貼り付ける
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  " 【n】 新しいファイルを作成する
  nnoremap <silent><buffer><expr> n
  \ defx#do_action('new_file')
  " 【N】 新しいディレクトリを作成する
  nnoremap <silent><buffer><expr> N
  \ defx#do_action('new_directory')
  " 【d】 ファイルを削除する
  nnoremap <silent><buffer><expr> d
  \ defx#do_action('remove')
  " 【r】 ファイル名を変更する
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')
  " 【yy】 ファイル/ディレクトリのパスをコピーする
  nnoremap <silent><buffer><expr> yy
  \ defx#do_action('yank_path')
  " 【.】 隠しファイルを表示/非表示する
  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')
  " 【..】 親ディレクトリに移動する
  nnoremap <silent><buffer><expr> ..
  \ defx#do_action('cd', ['..'])
  " 【j】 カーソルを下に移動する
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  " 【k】 カーソルを上に移動する
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'
endfunction

" Display window of defx
nnoremap <silent><C-e> :Defx<CR>

" Config for defx
call defx#custom#option('_', {
  \ 'winwidth': 120,
  \ 'split': 'floating',
  \ 'show_ignored_files': 1,
  \ 'buffer_name': 'exlorer',
  \ 'toggle': 1,
  \ 'resume': 1,
  \ 'columns': 'indent:git:icon:filename',
  \ })

call defx#custom#column('icon', {
    \ 'directory_icon': '▸',
    \ 'opened_icon': '▾',
    \ 'root_icon': ' ',
    \ })

" Config for defx-git
call defx#custom#column('git', 'indicators', {
  \ 'Modified'  : '✹',
  \ 'Staged'    : '✚',
  \ 'Untracked' : '✭',
  \ 'Renamed'   : '➜',
  \ 'Unmerged'  : '═',
  \ 'Ignored'   : '☒',
  \ 'Deleted'   : '✖',
  \ 'Unknown'   : '?'
  \ })

" Auto redraw of defx
autocmd BufWritePost * call defx#redraw()
autocmd BufEnter * call defx#redraw()

" Color scheme
set termguicolors
autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight LineNr ctermbg=none
let g:material_theme_style = 'darker'
colorscheme material

" For vim-scala
let g:scala_scaladoc_indent = 1

" Config of vim-airline
let g:airline_theme='material'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Change cursor by vim mode
if has('vim_starting')
  let &t_SI .= "\e[6 q" " For Insert Mode
  let &t_EI .= "\e[2 q" " For Normal Mode
endif

" For coc.nvim
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <c-space> coc#refresh()

" code jump to define
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" For indent line
let g:indentLine_char = '¦'

" For easy align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" For markdown preview
nmap <C-p> <Plug>MarkdownPreviewToggle

" For rainbow parentheses
let g:rainbow#pairs = [['(', ')'], ['{', '}']]
autocmd VimEnter * RainbowParentheses
let g:rainbow#blacklist = [15, 152, 231, 248]
