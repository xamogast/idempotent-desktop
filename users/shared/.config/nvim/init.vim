" https://idempotent-desktop.netlify.app/vim.html
" https://github.com/ksevelyar/idempotent-desktop/blob/master/packages/nvim.nix

" Plugins
call plug#begin()

Plug 'rbgrouleff/bclose.vim'
Plug 'tpope/vim-surround'
Plug 'alvan/vim-closetag'

Plug 'majutsushi/tagbar'

Plug 'easymotion/vim-easymotion'

Plug 'junegunn/vim-easy-align'

Plug 'tpope/vim-endwise'
Plug 'valloric/MatchTagAlways'

Plug 'janko-m/vim-test'

Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled=1

Plug 'tpope/vim-obsession'

Plug 'dhruvasagar/vim-prosession'
let g:prosession_dir = '~/.config/nvim/session/'

Plug 'airblade/vim-rooter'
let g:rooter_silent_chdir = 1

Plug 'tpope/vim-abolish'

Plug 'brooth/far.vim'
let g:far#source = 'rg'

Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

" Navigation 
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }
let NERDTreeMinimalUI=1
let NERDTreeWinSize=40
let NERDTreeShowHidden=1
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  Limelight
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
  Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Color Themes 
Plug 'ksevelyar/joker.vim'
" Plug '/c/joker.vim'

Plug 'rafalbromirski/vim-aurora'
Plug 'dracula/vim'
Plug 'whatyouhide/vim-gotham'
Plug 'arcticicestudio/nord-vim'
Plug 'cocopon/iceberg.vim'

Plug 'ryanoasis/vim-devicons'
Plug 'luochen1990/rainbow'
Plug 'tpope/vim-scriptease'

Plug 'itchyny/lightline.vim' " :h lightline
let g:lightline = {
\ 'active': {
\   'left':[[ 'filename', ], [ 'gitbranch', 'modified', 'readonly', 'paste']],
\   'right':[[ 'fileformat', 'fileencoding', 'filetype' ]],
\ },
\ 'inactive': {
\ 'left': [[ 'filename', 'modified' ]],
\ 'right': [],
\ },
\ 'component_function': {
\   'modified': 'LightlineModified',
\   'readonly': 'LightlineReadonly',
\   'gitbranch': 'LightlineFugitive'
\ }
\ }

function! LightlineModified()
  let modified = &modified ? '+' : ''
  return &readonly ? '' : modified
endfunction

function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction

function! LightlineFugitive()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = {  'left': '', 'right': '' }
let g:lightline.colorscheme = 'joker'

Plug '907th/vim-auto-save'
let g:auto_save = 0

" Dev
Plug 'ruanyl/vim-gh-line'
Plug 'tomtom/tcomment_vim'
let g:tcomment_maps = 0

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

Plug 'tpope/vim-fugitive'
Plug 'slashmili/alchemist.vim'
Plug 'LnL7/vim-nix'
Plug 'elixir-editors/vim-elixir'
Plug 'neovimhaskell/haskell-vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'dag/vim-fish'
Plug 'pangloss/vim-javascript'
Plug 'othree/yajs.vim'

Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0

Plug 'chr4/nginx.vim'

Plug 'sirtaj/vim-openscad'

Plug 'Yggdroot/indentLine'
let g:indentLine_fileType = ['nix', 'html', 'vue']
let g:indentLine_char = '┊'
let g:indentLine_color_gui = "#3f3b52"

Plug 'posva/vim-vue'
let g:vue_pre_processors = ['pug', 'sass', 'scss']
Plug 'digitaltoad/vim-pug'

Plug 'jsfaint/gen_tags.vim'
let g:gen_tags#ctags_auto_gen = 0

Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
      \ 'coc-vetur', 'coc-json', 'coc-html', 'coc-css', 'coc-eslint', 'coc-tsserver',
      \ 'coc-elixir', 'coc-yaml', 'coc-tag', 
      \ 'coc-vimlsp', 'coc-sh', 'coc-git', 'coc-highlight'
      \ ]

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" if &rtp =~ 'coc.nvim'
  " set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" endif

call plug#end()

" -------------------------------------------------------------------------------------------------
" Autocommands
" -------------------------------------------------------------------------------------------------
" Install Vim Plug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * silent! PlugInstall
endif

" Automatically install missing plugins on startup
autocmd VimEnter * silent!
      \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \| PlugInstall --sync | q
      \| endif

" sane terminal
au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
au TermOpen * setlocal nonumber
au FileType fzf tunmap <buffer> <Esc>

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup cocnvim
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end


" -------------------------------------------------------------------------------------------------
" Core Settings
" -------------------------------------------------------------------------------------------------
set conceallevel=0

set splitbelow
set splitright

syntax on
filetype plugin on " to use filetype plugin
filetype indent on " to use filetype indent
set updatetime=200
set laststatus=2
set signcolumn=yes
set hidden
set path+=** " type gf to open file under cursor
set number
set colorcolumn=100

set encoding=utf-8
set fileformat=unix

set title
" set shortmess+=c

" set timeoutlen=2000

" Disable annoying sound on errors
set noerrorbells
set novisualbell

" UI ----------------------------------------------------------------------------------------------
set mouse=a
set shortmess=AI

set wildmenu
set wildmode=list:longest,full

if (has("termguicolors"))
  set termguicolors
endif

" neovim-qt
if exists('g:GuiLoaded')
  GuiTabline 0
  GuiPopupmenu 0
  GuiLinespace 2
  GuiFont! Terminus:h16
endif

" :Colors to change theme
silent! colorscheme joker

" tree view for netrw
let g:netrw_liststyle = 3

" Clipboard ---------------------------------------------------------------------------------------
set noshowmode
set clipboard=unnamedplus " sync vim clipboard with linux clipboard

" Backups -----------------------------------------------------------------------------------------
if isdirectory($HOME . '/.config/nvim/undo') == 0
  :silent !mkdir -p ~/.config/nvim/undo > /dev/null 2>&1
endif
if isdirectory($HOME . '/.config/nvim/backup') == 0
  :silent !mkdir -p ~/.config/nvim/backup > /dev/null 2>&1
endif

set history=1000
set undodir=~/.config/nvim/undo//
set noswapfile

set backup
set backupdir=~/.config/nvim/backup//
set writebackup "Make backup before overwriting the current buffer
set backupcopy=yes "Overwrite the original backup file

"Meaningful backup name, ex: filename@2015-04-05.14
au BufWritePre * let &bex = 'gh' . '@' . strftime("%F.%H") . '.bac'

set undofile
set undolevels=999
set display+=lastline
set nojoinspaces

" Format ------------------------------------------------------------------------------------------
" Do not automatically insert a comment leader after an enter
autocmd FileType * setlocal formatoptions-=ro

set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

set list
set listchars=nbsp:¬,tab:>•,extends:»,precedes:«

" Search ------------------------------------------------------------------------------------------
set ignorecase
set smartcase

set incsearch
set inccommand=split
set gdefault


" Switch between the last two files:
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
set so=2 " Set 2 lines to the cursor - when moving vertically using j/k

" -------------------------------------------------------------------------------------------------
" Key Mappings
" -------------------------------------------------------------------------------------------------
let g:mapleader = " "

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

" coc.nvim ----------------------------------------------------------------------------------------
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nmap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nmap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
" nnoremap <silent> <space>p  :<C-u>CocListRsume<CR>

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Symbol renaming.
nnoremap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nnoremap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nnoremap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nnoremap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nnoremap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nnoremap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[g` and `]g` to navigate git chunks
nmap [c <Plug>(coc-git-prevchunk)
nmap ]c <Plug>(coc-git-nextchunk)

nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Mappings using CoCList:
" Show all diagnostics.

nnoremap <silent> <space>a  :AutoSaveToggle<cr>
" Manage extensions.

map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

nnoremap <C-J> <C-W><C-J> " navigate down
nnoremap <C-K> <C-W><C-K> " navigate up
nnoremap <C-L> <C-W><C-L> " navigate right
nnoremap <C-H> <C-W><C-H> " navigate left

nmap <leader>c :TComment<cr>
xmap <leader>c :TComment<cr>
nnoremap <silent> <Leader>. :Files <C-r>=expand("%:h")<CR>/<CR>
nnoremap <silent> <Leader>g :GFiles?<CR>
nnoremap <silent> <Leader>\  :Commits<CR>
nnoremap <silent> <Leader>b :BCommits<CR>
nnoremap <silent> <Leader>i :IndentLinesToggle<CR>

nnoremap <silent> <Leader>]  :Tags<CR>
nnoremap <silent> <Leader>b] :BTags<CR>

nnoremap <leader>v <C-w>v<CR>
nnoremap <leader>h <C-w>s<CR>

nnoremap <leader><leader> :Files<CR>
nnoremap <leader>r :Rg<cr>
nnoremap <leader>m <C-w>:History<CR>

nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>t :NERDTreeToggle<cr>
nnoremap <leader>f :NERDTreeFind<cr>
nnoremap <silent><leader>w :w<cr>
nnoremap <leader>s :TagbarToggle<cr>

nnoremap <silent>\ :Goyo<cr>

" copy curent buffer filepath
nnoremap <silent> <leader>p :let @+=expand("%:p")<CR>
"command! SW :execute ':silent w !sudo tee % > /dev/null' | :edit!
cmap w!! w !sudo tee % >/dev/null<Up>

" Enable/Disable paste mode, where data won't be autoindented
set pastetoggle=<C-F1>
set spelllang=en_us
nnoremap <leader>o :set spell!<CR>

" copy / paste
" vmap <C-C> "+y
imap <C-V> <esc>"+pi

nnoremap ; :
" Shift+V d for cut
nnoremap d "_d

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk
