" 1 tab = X spaces
:set shiftwidth=2
" keep indentation for a new line
:set autoindent

" display lines numbers
:set number

" highlight search results
:set hlsearch
" incremental search : display the match for the string while you are still typing it.
:set incsearch

" change extension for backup files
:set backupext=.bak

" display file name in status line
:set statusline+=%F
:set laststatus=2

syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

set omnifunc=syntaxcomplete#Complete


" ------------- maps ---------------
"  nmap : add a mapping in normal mode
"  imap : add a mapping in editing mode

" in splitted mode : switch split
:nmap <C-X> <C-W><C-W>   

