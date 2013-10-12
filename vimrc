" Configuration file for vim
"Kudos: Berge, xim, sjl

filetype off
" Add pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
" Enabled file type detection
filetype plugin indent on

highlight clear
" Add hilight before colorscheme
au ColorScheme * highlight ExtraWhitespace ctermbg=red

set background=dark
let g:solarized_termcolors=16
colorscheme solarized

" Now we set some defaults for the editor
set nobackup                    " Backup is for puppies
set nowritebackup
set noswapfile
set encoding=utf-8              " wtf-8
set autoindent                  " always set autoindenting on
set shiftwidth=4                " How many columns to insert with indent keys (<<)
set shiftround                  " Indent/outdent to nearest tabstops
set softtabstop=4               " How many columns to insert when pressing Tab-key
set tabstop=4                   " Number of coloumns to indent
set expandtab                   " Set spaces instead of <tab>
set wrap                        " Text wrapping on
set textwidth=79                " Wrap words by default
set colorcolumn=80              " Color long lines
set formatoptions=qrn1          " When to wrap text, and how
set modelines=0                 " Dont use modelines, disable to prevent security issues
set nocompatible                " Use Vim defaults instead of vi compatibility
set backspace=indent,eol,start  " more powerful backspacing
set wildmenu
set wildmode=list:longest       " File completion in a menu
set wildignore+=.git,.pyc       " Ignore some files
set cursorline                  " Indicate what line we are on
set ttyfast                     " We are on a quick terminal
set laststatus=2                " Show a statusline all the time
set relativenumber              " Show numbers in column
set ignorecase                  " Defaults on search
set smartcase                   " Smarter search when applying upper case letters
set nobackup                    " Don't keep a backup file
set viminfo='20,\"50            " read/write a .viminfo file, don't store more than 50 lines of registers
set hlsearch                    " Hilight last search
set history=50                  " keep 50 lines of command line history
set ruler                       " show the cursor position all the time
set showcmd                     " Show (partial) command in status line.
set showmatch                   " Show matching brackets.
set showmode                    " Show mode we are in
set visualbell                  " Blink, no sound
set pastetoggle=<F2>            " Press F2 to enter paste mode
set clipboard=unnamed			" OSX clipboard integration
set errorformat=%f:%l:\ %m      "
set scrolloff=3                 " Keep more context when scrolling
set title
syntax on                       " I like syntax hilight

" Suffixes that get lower priority when doing tab completion
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" And some variables..
let mapleader = ","

" Automatically cd into the directory that the opened file is in
au BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="

" Remove trailing whitespace on save
au BufWritePre *.py :%s/\s\+$//e

" Sane regexp (very magical)
nnoremap / /\v
vnoremap / /\v

" redraw window so search terms are centered
nnoremap n nzz
nnoremap N Nzz

" Create header lines
nnoremap <leader>1 yypVr=
nnoremap <leader>2 yypVr-

" Clear hilights
nnoremap <leader><space> :noh<cr>

" Select recently pasted text
nnoremap <leader>v V`]

" Use tab to jump to next matching bracket
nnoremap <tab> %
vnoremap <tab> %

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" jj in insert mode mapped as Esc, and same with F1
inoremap jj <Esc>
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" hh in insert mode mapped as Esc + Write
inoremap hh <Esc>:w<cr>

" xclip integration
vmap <F6> :!xclip -f -sel clip<CR>
inoremap <F7> <ESC>:-1r !xclip -o -sel clip<CR>i
nnoremap <F7> :+1r !xclip -o -sel clip<CR>

" Open current file in OS default
inoremap <F10> <ESC>:!xdg-open %<CR>
inoremap <F10> :!xdg-open %<CR>

" Command to remove trailing whitespaces
command Tws %s/\s\+$//

" Tired of forgetting sudo..
cmap w!! w !sudo tee %

" Language specific settings
"
" No text wrap for urls.py
au BufNewFile,BufRead urls.py      setlocal nowrap
" Wrap in diff mode
au FilterWritePre * if &diff | set wrap | endif

" Set some filetypes
au BufNewFile,BufRead *.pp         setlocal filetype=ruby
au BufNewFile,BufRead *.coffee     setlocal filetype=coffee
au BufNewFile,BufRead *.groovy     setlocal filetype=groovy
au BufNewFile,BufRead *.md         setlocal filetype=markdown
au BufNewFile,BufRead *.twig       setlocal filetype=htmldjango
au BufNewFile,BufRead *.html       setlocal filetype=htmldjango
au BufNewFile,BufRead admin.py     setlocal filetype=python.django
au BufNewFile,BufRead urls.py      setlocal filetype=python.django
au BufNewFile,BufRead models.py    setlocal filetype=python.django
au BufNewFile,BufRead views.py     setlocal filetype=python.django
au BufNewFile,BufRead settings.py  setlocal filetype=python.django
au BufNewFile,BufRead forms.py     setlocal filetype=python.django

" Lint (based on filetype)
nnoremap <leader>l :Lint<cr>

" Replace next occurrences of work
nnoremap <leader>s :%s/<c-r><c-w>/<c-r><c-w>/gc<c-f>$F/hvb

" Git blame through fugitive.vim
nnoremap <leader>b :Gblame<cr>

" Functions

" Pylint on python files
function! s:PyLint(rcfile)
  if exists('a:rcfile')
    let l:lint = 'pylint --output-format=parseable --include-ids=y --reports=n --rcfile='.a:rcfile
  else
    let l:lint = 'pylint --output-format=parseable --include-ids=y --reports=n'
  endif
  cexpr system(l:lint . ' ' . expand('%'))
endfunction

au FileType python command! Lint :call s:PyLint(exists('s:pylintrc_path') ? s:pylintrc_path : '')

" Jshint on javascript files
function! s:JsLint(rcfile)
  let l:lint = 'jshint'
  if exists('a:rcfile')
    cexpr system(l:lint . ' ' . expand('%') . ' ' . '--config' . ' ' . a:rcfile . ' ' . '\| head -n -2')
  else
    cexpr system(l:lint . ' ' . expand('%') . ' ' . '\| head -n -2')
  endif
endfunction

au FileType javascript command! Lint :call s:JsLint(exists('s:jshintrc_path') ? s:jshintrc_path : b:git_dir . '/../.jshintrc')

let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0

let g:ctrlp_custom_ignore = '\v[\/](node_modules|dist|.sass_cache|.tmp)$'

let g:vimclojure#HighlightBuiltins = 1
let g:vimclojure#ParenRainbow = 1

" Various golang stuff
set rtp+=$GOROOT/misc/vim
autocmd FileType go autocmd BufWritePre <buffer> Fmt

let g:Powerline_symbols = 'fancy'
