call plug#begin('$HOME/.vim/plugged')
Plug 'mg979/vim-visual-multi'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'AndrewRadev/splitjoin.vim'

Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'karb94/neoscroll.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
call plug#end()

"==== for appearence
silent! color catppuccin_latte
let g:VM_theme             = 'iceblue'
let g:airline_theme        = 'angr'
hi Normal ctermfg=252 ctermbg=none

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
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

""==== for cpp-lsp
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'whitelist': ['cpp'],
        \ })
endif

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

set autochdir
set backspace=indent,eol,start
set cursorline
set expandtab tabstop=4 shiftwidth=4 softtabstop=4 autoindent
set incsearch ignorecase smartcase
set list listchars=tab:\|\ ,trail:▫
set number relativenumber
set scrolloff=4
set wrap mouse=a

silent !mkdir -p $HOME/.vim/tmp/backup
silent !mkdir -p $HOME/.vim/tmp/undo
set backupdir=$HOME/.vim/tmp/backup,.
set directory=$HOME/.vim/tmp/backup,.

let mapleader=" "
noremap ; :

"==== speacial for Windows (CRLF)
map <LEADER>Y :w !clip.exe<CR><CR>

func! SearchPlaceHolder()
    call search("<++>", 'w')
    :norm zz<CR>
endfunc
map <LEADER><LEADER> <ESC>:call SearchPlaceHolder()<CR>c4l
map <LEADER>m mko<++><ESC>`k:delmarks k<CR>

noremap r :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    exec "!g++ % -std=c++23 -Ofast -g -Wall -Wextra -o %< && ./%< && rm -f ./%<"
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
