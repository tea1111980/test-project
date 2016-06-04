" Content reference from: The contents of this configuration file are referenced from the Internet

set nocompatible
set nu                      "Display Line Number
set ic
set wrap
set linebreak
set whichwrap=b,s,<,>,[,]
" Shared clipboard  
set clipboard+=unnamed
set nohlsearch
syntax on
filetype on 
set vb t_vb=
set showmatch               " Display matching items
set matchtime=5
set ignorecase
set incsearch
set tabstop=4               " Tab number
set history=1000            " Number of historical records
set shiftwidth=4
set background=dark
set completeopt=preview,menu
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileencoding=utf-8
set laststatus=2
set ruler                   " Open the bar of the status bar
set cursorline              " Highlight the current line
set magic                   " Set magic
set guioptions-=T           " Hide the toolbar
set guioptions-=m           " Hide menu bar
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%y/%m/%d\ -\ %H:%M:%S\")}
"set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
set foldmarker={,} 
set foldmethod=marker 
set foldmethod=syntax 
set foldlevel=100 " Don't autofold anything (but I can still fold manually) 
set foldopen-=search " don't open folds when you search into them 
set foldopen-=undo " don't open folds when you undo stuff 
set foldcolumn=4 

" Show Chinese help, if possible.
if version >= 603
    set helplang=cn
    set encoding=utf-8
endif


" Extra font configuration
if (has("gui_running"))
    set guifont=Bitstream\ Vera\ Sans\ Mono\ 10
endif

