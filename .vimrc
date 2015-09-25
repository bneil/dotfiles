"
"       \        /
"        \      /
"         \____/
"         /  __\     Welcome to Ben's Vimrc File
"        |  / ..\      <ben@neil-concepts.com>
"        |  \_/\/
"      __|   ___\
"     /   \      \
"    / |   \      |
" (( \__\________/
"
"
set backup

if has("win32") || has("win64")
  set directory=$TMP
  set backupdir=$TMP
  set backupskip=$TMP
else
  set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
  set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
  set backupskip=/tmp/*,/private/tmp/*
end

call pathogen#infect()
call pathogen#helptags()

set noautochdir
set writebackup
set autoread
set showmode
set nowrap
set ffs=unix,dos
set go-=m go-=T go-=r
set tags=./tags,~/src/tags,~/src/scala/appthis/proof/tags;
set runtimepath^=~/.vim/bundle/ctrlp.vim
set directory+=,~/tmp,$TMP
set virtualedit=all
set wildignore+=*.o,*.obj,.git,target/*
set clipboard^=unnamed

" Windows Optional Ruby Path
let s:ruby_path = 'C:\Ruby192\bin'

let g:rct_completion_use_fri = 1
let g:Tex_ViewRule_pdf = "kpdf"

filetype plugin indent on
syntax on
"{{{Auto Commands
let mapleader = ","
au BufRead,BufNewFile *.scala set filetype=scala
au BufRead,BufNewFile *.as set filetype=actionscript
au BufRead,BufNewFile *.tt set filetype=html

" ,cd changes the current directory to here!
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>

" Restore cursor position to where it was before
autocmd BufWritePre * :%s/\s\+$//e
augroup JumpCursorOnEdit
  au!
  autocmd BufReadPost *
        \ if expand("<afile>:p:h") !=? $TEMP |
        \   if line("'\"") > 1 && line("'\"") <= line("$") |
        \     let JumpCursorOnEdit_foo = line("'\"") |
        \     let b:doopenfold = 1 |
        \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
        \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
        \        let b:doopenfold = 2 |
        \     endif |
        \     exe JumpCursorOnEdit_foo |
        \   endif |
        \ endif
  " Need to postpone using "zv" until after reading the modelines.
  autocmd BufWinEnter *
        \ if exists("b:doopenfold") |
        \   exe "normal zv" |
        \   if(b:doopenfold > 1) |
        \       exe  "+".1 |
        \   endif |
        \   unlet b:doopenfold |
        \ endif
augroup END

"}}}

"{{{Misc Settings

" Necesary  for lots of cool vim things
set nocompatible

" Sets history to be the boss
set history=1000

" This shows what you are typing as a command.  I love this!
set showcmd

" Folding Stuffs
set foldmethod=marker

" Needed for Syntax Highlighting and stuff
filetype on
filetype plugin on
syntax enable
set grepprg=grep\ -nH\ $*
set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\
" Who doesn't like autoindent?
set autoindent

" Spaces are better than a tab character
set expandtab
set smarttab

" Who wants an 8 character tab?  Not me!
set shiftwidth=2
set softtabstop=2

" Use english for spellchecking, but don't spellcheck by default
if version >= 700
  set spl=en spell
  set nospell
endif

" Real men use gcc
"compiler gcc

" Cool tab completion stuff
set wildmenu
set wildmode=list:longest,full

" Enable mouse support in console
set mouse=a

" Got backspace?
set backspace=2

" Line Numbers PWN!
set number

" Ignoring case is a fun trick
set ignorecase

" And so is Artificial Intellegence!
set smartcase

" This is totally awesome - remap jj to escape in insert mode.  You'll never type jj anyway, so it's great!
inoremap jj <Esc>

nnoremap JJJJ <Nop>

" Incremental searching is sexy
set incsearch

" Highlight things that we find with the search
set hlsearch

" Since I use linux, I want this
let g:clipbrdDefaultReg = '+'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" When I close a tab, remove the buffer
set nohidden

" Set off the other paren
highlight MatchParen ctermbg=4

" fix the behavior of centering
vnoremap <silent> zz :<C-u>call setpos('.',[0,(line("'>")-line("'<"))/2+line("'<"),0,0])<Bar>normal! zzgv<CR>
vnoremap <silent> zt :<C-u>call setpos('.',[0,line("'<"),0,0])<Bar>normal! ztgv<CR>
vnoremap <silent> zb :<C-u>call setpos('.',[0,line("'>"),0,0])<Bar>normal! zbgv<CR>

" }}}

"{{{Look and Feel

" Favorite Color Scheme
"Terminus is AWESOME
set guifont=Ubuntu\ Mono\ 10
set guioptions-=T
colorscheme desert
set background=dark

"Status line gnarliness - powerline
set laststatus=2
let g:Powerline_symbols = 'fancy'

" }}}

"{{{ Functions

"{{{ Open URL in browser

function! Browser ()
  let line = getline (".")
  let line = matchstr (line, "http[^   ]*")
  exec "!konqueror ".line
endfunction

"}}}

"{{{Theme Rotating
let themeindex=0
function! RotateColorTheme()
  let y = -1
  while y == -1
    let colorstring = "inkpot#ron#blue#elflord#evening#koehler#murphy#pablo#desert#torte#"
    let x = match( colorstring, "#", g:themeindex )
    let y = match( colorstring, "#", x + 1 )
    let g:themeindex = x + 1
    if y == -1
      let g:themeindex = 0
    else
      let themestring = strpart(colorstring, x + 1, y - x - 1)
      return ":colorscheme ".themestring
    endif
  endwhile
endfunction
" }}}

"{{{ Paste Toggle
let paste_mode = 0 " 0 = normal, 1 = paste

func! Paste_on_off()
  if g:paste_mode == 0
    set paste
    let g:paste_mode = 1
  else
    set nopaste
    let g:paste_mode = 0
  endif
  return
endfunc
"}}}

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif"}}}

" Toggle relative/absolute numbering"{{{
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc "}}}

" Grep function {{{
function! SearchCurrentDirectory()
  let s:pat=input("Grep: ")
  let s:path=input("Path to search (ENTER for pwd): ", "", "dir")
  let s:ext=input("File extension (ENTER for all files): ")
  if s:ext==""
    let s:ext="*"
  endif
  if s:path==""
    let s:path="."
  endif
  if s:pat!=""
    execute("vimgrep /".s:pat."/gj ".s:path."/**/*.".s:ext)
    copen
  endif
endfunction


" }}} End Grep

"{{{ Mappings

" Open Url on this line with the browser \w
map <Leader>w :call Browser ()<CR>

" Open Lusty Juggler
nnoremap <Leader>l :LustyJuggler<CR>


" Open the Project Plugin
nnoremap <silent> <Leader>pal  :Project .vimproject<CR>

" Open the Project Plugin <F2>
nnoremap <silent> <F2> :noh<CR>

" take bufter and paste to new window
nnoremap <silent> <F3> :redir @a<CR>:g//<CR>:redir END<CR>:new<CR>:put! a<CR><CR>

" Grep for whatever
nnoremap <silent> <F4> :execute SearchCurrentDirectory()<CR>

" Switch Windows
nnoremap <silent> <C-Right> <c-w>l
nnoremap <silent> <C-Left> <c-w>h
nnoremap <silent> <C-Up> <c-w>k
nnoremap <silent> <C-Down> <c-w>j

" Switch Tabs
nnoremap <A-Left> :tabprevious<CR>
nnoremap <A-Right> :tabnext<CR>
nnoremap <A-Up> :tn<CR>
nnoremap <A-Down> :tp<CR>:redraw<CR>

" Rotate Color Scheme <F8>
nnoremap <silent> <F8> :execute RotateColorTheme()<CR>

" Paste Mode!  Dang! <F10>
nnoremap <silent> <F10> :call Paste_on_off()<CR>
set pastetoggle=<F10>

" Edit vimrc \ev
nnoremap <silent> <Leader>ev :tabnew<CR>:e ~/.vimrc<CR>

" Edit gvimrc \gv
nnoremap <silent> <Leader>gv :tabnew<CR>:e ~/.gvimrc<CR>

" Up and down are more logical with g..
nnoremap <silent> k gk
nnoremap <silent> j gj
inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja

" Good call Benjie (r for i)
nnoremap <silent> <Home> i <Esc>r
nnoremap <silent> <End> a <Esc>r

" Create Blank Newlines and stay in Normal mode
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>

" Space will toggle folds!
nnoremap <space> za

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
map N Nzz
map n nzz

" Testing
set completeopt=longest,menuone,preview

inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
inoremap <expr> <c-n> pumvisible() ? "\<lt>c-n>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"
inoremap <expr> <m-;> pumvisible() ? "\<lt>c-n>" : "\<lt>c-x>\<lt>c-o>\<lt>c-n>\<lt>c-p>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"

" Swap ; and :  Convenient.
nnoremap ; :
nnoremap : ;

nnoremap <C-L> :call NumberToggle()<cr>



" Fix email paragraphs
nnoremap <leader>par :%s/^>$//<CR>

"make the middle mouse button paste
map <MiddleButton> "*p

"}}}

"{{{Taglist configuration
"let Tlist_Use_Right_Window = 1
"let Tlist_Enable_Fold_Column = 0
"let Tlist_Exit_OnlyWindow = 1
"let Tlist_Use_SingleClick = 1
"let Tlist_Inc_Winwidth = 0
"}}}

"{{{Set the default autocomplete
highlight Pmenu ctermfg=green ctermbg=black
highlight PmenuSel ctermfg=green ctermbg=grey
"}}}

set guioptions+=LlRrb
set guioptions-=LlRrb
let g:syntastic_perl_lib_path = './lib,/home/bneil/perl5/lib/perl5'
if has("unix")
    set runtimepath+=~/.vim/xpt-personal
endif


"-----------------------------------------------------------------------------
" Fugitive
"-----------------------------------------------------------------------------
" Thanks to Drew Neil
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \ noremap <buffer> .. :edit %:h<cr> |
  \ endif
autocmd BufReadPost fugitive://* set bufhidden=delete

nnoremap ,gs :Gstatus<cr>
nnoremap ,ge :Gedit<cr>
nnoremap ,gw :Gwrite<cr>
nnoremap ,gr :Gread<cr>

" Wipe out all buffers
nnoremap <silent> ,wa :1,9000bwipeout<cr>

" Maps to make handling windows a bit easier
noremap <silent> <C-F9>  :vertical resize -10<CR>
noremap <silent> <C-F10> :resize +10<CR>
noremap <silent> <C-F11> :resize -10<CR>
noremap <silent> <C-F12> :vertical resize +10<CR>
noremap <silent> ,s8 :vertical resize 83<CR>
noremap <silent> ,cj :wincmd j<CR>:close<CR>
noremap <silent> ,ck :wincmd k<CR>:close<CR>
noremap <silent> ,ch :wincmd h<CR>:close<CR>
noremap <silent> ,cl :wincmd l<CR>:close<CR>
noremap <silent> ,cc :close<CR>
noremap <silent> ,cw :cclose<CR>
noremap <silent> ,ml <C-W>L
noremap <silent> ,mk <C-W>K
noremap <silent> ,mh <C-W>H
noremap <silent> ,mj <C-W>J
noremap <silent> <C-7> <C-W>>
noremap <silent> <C-8> <C-W>+
noremap <silent> <C-9> <C-W>+
noremap <silent> <C-0> <C-W>>

" Edit the vimrc file
nnoremap <silent> ,ev :e $MYVIMRC<CR>
nnoremap <silent> ,sv :so $MYVIMRC<CR>

" Add a GUID to the current line
imap <C-J>d <C-r>=substitute(system("uuidgen"), '.$', '', 'g')<CR>

" Toggle fullscreen mode
nnoremap <silent> <F3> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>

" Underline the current line with '='
nnoremap <silent> ,u= :t.\|s/./=/g\|:nohls<cr>
nnoremap <silent> ,u- :t.\|s/./-/g\|:nohls<cr>
nnoremap <silent> ,u~ :t.\|s/./\\~/g\|:nohls<cr>

" Shrink the current window to fit the number of lines in the buffer.  Useful
" for those buffers that are only a few lines
nnoremap <silent> ,sw :execute ":resize " . line('$')<cr>

"-----------------------------------------------------------------------------
" CtrlP Settings
"-----------------------------------------------------------------------------
let g:ctrlp_switch_buffer = 'E'
let g:ctrlp_tabpage_position = 'c'
let g:ctrlp_working_path_mode = 'rc'
let g:ctrlp_root_markers = ['.project.root']
let g:ctrlp_custom_ignore = '\v%(/\.%(git|hg|svn)|\.%(class|o|png|jpg|jpeg|bmp|tar|jar|tgz|deb|zip)$|/target/%(quickfix|resolution-cache|streams)|/target/scala-2.10/%(classes|test-classes|sbt-0.13|cache)|/project/target|/project/project)'
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_open_multiple_files = '1ri'
let g:ctrlp_match_window = 'max:40'
let g:ctrlp_prompt_mappings = {
  \ 'PrtSelectMove("j")':   ['<c-n>'],
  \ 'PrtSelectMove("k")':   ['<c-p>'],
  \ 'PrtHistory(-1)':       ['<c-j>', '<down>'],
  \ 'PrtHistory(1)':        ['<c-i>', '<up>']
\ }
nnoremap ,fb :CtrlPBuffer<cr>
nnoremap ,ff :CtrlP .<cr>
nnoremap ,fr :CtrlP<cr>
nnoremap ,fm :CtrlPMixed<cr>

"-----------------------------------------------------------------------------
" XPTemplate settings
"-----------------------------------------------------------------------------
let g:xptemplate_brace_complete = ''

nnoremap <silent> ,cd :lcd %:h<CR>
nnoremap <silent> ,cr :lcd <c-r>=FindGitDirOrRoot()<cr><cr>
nnoremap <silent> ,md :!mkdir -p %:p:h<CR>

"FSwitch Settings
"-----------------------------------------------------------------------------
"" FSwitch mappings
"-----------------------------------------------------------------------------
au FileType *.scala let b:fswitchdst = 'scala'
au BufEnter *\(Test\)\@!.scala let b:fswitchlocs = 'reg:+/main/scala+/test/scala/+' | let b:fswitchfnames='/$/Test/'
au BufEnter *Test.scala let b:fswitchlocs = 'reg:+/test/scala+/main/scala/+' | let b:fswitchfnames='/Test$//'

nnoremap <buffer> <silent> ,of :ScalaSwitchHere<cr>
nnoremap <buffer> <silent> ,ol :ScalaSwitchRight<cr>
nnoremap <buffer> <silent> ,oL :ScalaSwitchSplitRight<cr>
nnoremap <buffer> <silent> ,oh :ScalaSwitchLeft<cr>
nnoremap <buffer> <silent> ,oH :ScalaSwitchSplitLeft<cr>
nnoremap <buffer> <silent> ,ok :ScalaSwitchAbove<cr>
nnoremap <buffer> <silent> ,oK :ScalaSwitchSplitAbove<cr>
nnoremap <buffer> <silent> ,oj :ScalaSwitchBelow<cr>
nnoremap <buffer> <silent> ,oJ :ScalaSwitchSplitBelow<cr>


"hi Normal guibg=NONE ctermbg=NONE
let g:staircase_use_sbt = 1

 " Run the current file with rspec
 nnoremap <Leader>rb :call VimuxRunCommand(":load " . bufname("%"))<CR>

 " Run the current file with rspec
 nnoremap <Leader>rs :call VimuxRunCommand("clear; scala")<CR>

 " Prompt for a command to run
 nnoremap <Leader>vp :VimuxPromptCommand<CR>

 " Run last command executed by VimuxRunCommand
 nnoremap <Leader>vl :VimuxRunLastCommand<CR>

 " Inspect runner pane
 nnoremap <Leader>vi :VimuxInspectRunner<CR>

 " Close vim tmux runner opened by VimuxRunCommand
 nnoremap <Leader>vq :VimuxCloseRunner<CR>

 " Interrupt any command running in the runner pane
 nnoremap <Leader>vx :VimuxInterruptRunner<CR>

 " Zoom the runner pane (use <bind-key> z to restore runner pane)
 nnoremap <Leader>vz :call VimuxZoomRunner()<CR>

 " Prompt for a command to run
 nnoremap <Leader>vp :VimuxPromptCommand<CR>

 " Run last command executed by VimuxRunCommand
 nnoremap <Leader>vl :VimuxRunLastCommand<CR>

 " Inspect runner pane
 nnoremap <Leader>vi :VimuxInspectRunner<CR>

 " Close vim tmux runner opened by VimuxRunCommand
 nnoremap <Leader>vq :VimuxCloseRunner<CR>

 " Interrupt any command running in the runner pane
 nnoremap <Leader>vx :VimuxInterruptRunner<CR>

 " Zoom the runner pane (use <bind-key> z to restore runner pane)
 nnoremap <Leader>vz :call VimuxZoomRunner()<CR>

 if exists('$TMUX')
   set term=screen-256color
 endif

 set noeb vb t_vb=
