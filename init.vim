call plug#begin('$HOME/.config/nvim/plugged')
Plug 'mg979/vim-visual-multi'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'AndrewRadev/splitjoin.vim'

Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'karb94/neoscroll.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'rhysd/vim-clang-format'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

Plug 'sphamba/smear-cursor.nvim'
call plug#end()

"==== for appearence
silent! color catppuccin_macchiato
let g:VM_theme             = 'iceblue'
let g:airline_theme        = 'angr'
set termguicolors
hi Normal ctermbg=none

"==== for lsp
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

"==== for cpp-lsp
let g:lsp_diagnostics_enabled = 0
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'whitelist': ['cpp'],
        \ })
endif


"==== for clang-format
let g:clang_format#code_style = "google"
let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "Standard" : "c++17"}
let g:clang_format#auto_format_on_insert_leave = 0
au FileType c,cpp ClangFormatAutoEnable
au FileType c,cpp nnoremap <buffer><Leader>f :<C-u>ClangFormat<CR>
au FileType c,cpp vnoremap <buffer><Leader>f :ClangFormat<CR>
" temporarily disable auto format
nmap <Leader>F :ClangFormatAutoToggle<CR>

"==== move line up/down
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <ESC>:m .+1<CR>==gi
inoremap <C-k> <ESC>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

"==== for screens split
noremap s <nop>
noremap sk :set nosplitbelow<CR>:split<CR>:set splitbelow<CR>
noremap sj :set splitbelow<CR>:split<CR>
noremap sh :set nosplitright<CR>:vsplit<CR>:set splitright<CR>
noremap sl :set splitright<CR>:vsplit<CR>
noremap <UP> :res +5<CR>
noremap <DOWN> :res -5<CR>
noremap <LEFT> :vertical resize-5<CR>
noremap <RIGHT> :vertical resize+5<CR>

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
au TextChanged,TextChangedI <buffer> if &readonly == 0 && filereadable(bufname('%')) | silent write | endif
au BufNewFile *.cpp exec ":0r ~/.config/nvim/cppfile/code.cpp"

set autochdir
set backspace=indent,eol,start
set cursorline
set expandtab tabstop=4 shiftwidth=4 softtabstop=4 autoindent
set incsearch ignorecase smartcase
set list listchars=tab:\|\ ,trail:▫
set number relativenumber
set scrolloff=4
set wrap mouse=a

set fileencodings=utf-8,gb2312,gbk,gb18030
set termencoding=utf-8
set encoding=utf-8

silent !mkdir -p $HOME/.vim/tmp/backup
silent !mkdir -p $HOME/.vim/tmp/undo
set backupdir=$HOME/.vim/tmp/backup,.
set directory=$HOME/.vim/tmp/backup,.

let mapleader=" "
noremap ; :

"==== speacial for Windows (CRLF)
map <LEADER>Y :w !clip.exe<CR><CR>
vmap <LEADER>Y :'<,'>w !clip.exe<CR><CR>

func! SearchPlaceHolder()
    call search("<++>", 'w')
    :norm zz<CR>
endfunc
map <LEADER><LEADER> <ESC>:call SearchPlaceHolder()<CR>c4l
map <LEADER>m mko<++><ESC>`k:delmarks k<CR>

noremap r :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    set splitbelow
    :sp
    term g++ % -std=c++2a -O2 -g -Wall -fsanitize=undefined -o %< && ./%< && rm -f ./%<
endfunc

noremap <LEADER><CR> :nohlsearch<CR>

"==== NERDCommenter
let g:NERDSpaceDelims			= 1
let g:NERDCompactSexyComs		= 1
let g:NERDDefaultAlign		   = 'left'
let g:NERDAltDelims_java		 = 1
let g:NERDCustomDelimiters	   = {
            \ 'php': { 'left': '/*','right': '*/' },
            \ 'html': { 'left': '<!--','right': '-->' },
            \ 'py': { 'left': '#' },
            \ 'sh': { 'left': '#' } }
let g:NERDCommentEmptyLines	  = 1
let g:NERDTrimTrailingWhitespace = 1

"==== sticky line highlight
highlight LineHighlight ctermbg=gray guibg=black
nnoremap <silent> <LEADER>x :call matchadd('LineHighlight', '\%'.line('.').'l')<CR>
nnoremap <silent> <LEADER>X :call clearmatches()<CR>

"==== fzf config
map <LEADER>f <ESC>:FZF<CR>


" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'query':   ['fg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history
" - History files will be stored in the specified directory
" - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
"   'previous-history' instead of 'down' and 'up'.
let g:fzf_history_dir = '~/.local/share/fzf-history'

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
