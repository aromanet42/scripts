" 1 tab = X spaces
:set shiftwidth=2
" how to display white spaces with :set list
:set listchars=tab:»⋅,trail:~,extends:>,precedes:<,eol:$,nbsp:⋅
" keep indentation for a new line
:set autoindent

" display lines numbers
:set number

" highlight search results
:set hlsearch
" incremental search : display the match for the string while you are still typing it.
:set incsearch

" When 'ignorecase' and 'smartcase' are both on, if a pattern contains an
" uppercase letter, it is case sensitive, otherwise, it is not
:set ignorecase
:set smartcase

" automatically change working directory to the directory of editing file
:set autochdir

" change extension for backup files
:set backupext=.bak

" display file name in status line
:set statusline+=%F\ %l\:%c
:set laststatus=2

" when opening a new file, first tab will complete as much as possible, second
" Tab hit will provide a list, and subsequent tabs will cycle through
" completion options
:set wildmode=longest,list,full

" Pathogen is a plugin manager : https://github.com/tpope/vim-pathogen
execute pathogen#infect()


syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

set omnifunc=syntaxcomplete#Complete


" link extensions with filetype for syntax highlighting
au BufRead, BufNewFile *.md set filetype=markdown

" ------------- maps ---------------
"  nmap : add a mapping in normal mode
"  imap : add a mapping in editing mode

" in splitted mode : switch split
:nmap <C-X> <C-W><C-W>   
" in splitted mode : resize -10. Key = Alt-D
:noremap ^[d :vertical resize -10<CR>
" in splitted mode : resize +10. Key = Alt-F
:noremap f :vertical resize +10<CR>


" move current line up with Alt+Z and move current line down with Alt+S
:nnoremap z :m .-2<CR>==
:nnoremap s :m .+1<CR>==
:inoremap z <Esc>:m .-2<CR>==gi
:inoremap s <Esc>:m .+1<CR>==gi
:vnoremap z :m '<-2<CR>gv=gv
:vnoremap s :m '>+1<CR>gv=gv

" in git-rebase-interactive, change action for line
function RebaseAction(action)
  execute "normal! ^cw" . a:action
  execute "normal! ^"
endfunction

autocmd BufRead git-rebase-todo noremap f :call RebaseAction('fixup')<CR>
autocmd BufRead git-rebase-todo noremap p :call RebaseAction('pick')<CR>
autocmd BufRead git-rebase-todo noremap r :call RebaseAction('reword')<CR>
autocmd BufRead git-rebase-todo noremap e :call RebaseAction('edit')<CR>


