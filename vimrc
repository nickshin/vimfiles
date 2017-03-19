" vimrc by nick shin <nshin@estss.com>
"
" this file can be found at: https://github.com/nickshin/vimfiles
"
" for best results, symbolic link to this file for ~/.vimrc


" ----------------------------------------
" Environment
set nocompatible				" Don't set vi-compatibility
set nobackup
set history=50					" keep 50 lines of command line history
set hidden						" hidden allows to have modified buffers in background
set mouse=a						" automatically enable mouse usage
set mousehide					" Hide the mouse when typing text
set lazyredraw					" no readraw when running macros
"set ttyfast						" Smoother redraws.
set timeoutlen=200 ttimeoutlen=100

set sessionoptions=blank,options,resize,winpos,winsize,buffers,tabpages,folds,curdir,help

set background=dark
colorscheme koehler


" ----------------------------------------
" command line
set wildmenu					" show list instead of just completing
set wildmode=list:longest,full	" command <Tab> completion, list matches, then longest common part, then all.
set wildignore=.svn,CVS,*.swp,*.o,*~,*.pyc


" ----------------------------------------
" editing
set backspace=indent,eol,start	" http://vim.wikia.com/wiki/Backspace_and_delete_problems
set scrolloff=5					" keep at least 5 lines above/below
set sidescrolloff=5				" keep at least 5 lines left/right
set nowrap						" line wrapping
syntax enable					" note: 'on' will override to default settings
set cursorline					" Highlight current line
"set cursorcolumn				" Highlight current column
set showmatch					" Show briefly matching bracket when closing it.
set matchtime=2					" time (tenth of a second) to show the matching bracket
set incsearch					" incremental searching
set hlsearch					" highlight search
set ignorecase					" set case insensitivity
set smartcase					" unless there's a capital letter
set magic						" special characters that can be used in search patterns
"set list						" show invisible characters
set listchars=tab:>.,trail:.,extends:#,nbsp:.	" Highlight problematic whitespace

" Flag problematic whitespace (trailing spaces, spaces before tabs).
highlight BadWhitespace term=standout ctermbg=red guibg=red
match BadWhitespace /[^* \t]\zs\s\+$\| \+\ze\t/


" ----------------------------------------
" plugins
execute pathogen#infect()
call pathogen#helptags()


" - - - - - - - - - - - - - - - - - - - -
" gundo
"nnoremap <F5> :GundoToggle<CR>		" author of gundo uses this...
nmap <leader>gt :GundoToggle<CR>	" toggle the gundo utility
"let g:gundo_width = 60
"let g:gundo_preview_height = 40
"let g:gundo_right = 1


" - - - - - - - - - - - - - - - - - - - -
" unite
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

" OSX needs this...
let g:ycm_path_to_python_interpreter = '/usr/bin/python'

let g:unite_source_history_yank_enable = 1
let g:unite_force_overwrite_statusline = 0
if executable('ag')
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
	let g:unite_source_grep_recursive_opt = ''
endif

call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
	\ 'ignore_pattern', join([
		\ '\.git/',
		\ '\.sass-cache/',
		\ '\.tmp/',
		\ '\vendor/',
		\ '\node_modules/',
	\ ], '\|'))

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
" these three:
"	imap <buffer> <C-j> <Plug>(unite_select_next_line)
"	imap <buffer> <C-k> <Plug>(unite_select_previous_line)
"	imap <buffer> <c-a> <Plug>(unite_choose_action)
" are the same as:
"	imap <buffer> <C-j> <C-n>
"	imap <buffer> <C-k> <C-p>
"	imap <buffer> <c-a> <cr>
	imap <silent><buffer><expr> <C-s> unite#do_action('split')
	imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
"	imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')
	nmap <buffer> <ESC> <Plug>(unite_exit)
endfunction

" The prefix key
nnoremap [unite] <Nop>
"nmap <space> [unite]
nmap <leader>u [unite]

" General purpose
"nnoremap [unite]u :Unite -no-split -start-insert source<cr>
nnoremap [unite]u :Unite -no-split source<cr>

" Files
nnoremap [unite]f :Unite -no-split -start-insert file_rec/async<cr>

" Files in rails
nnoremap [unite]rm :Unite -no-split -start-insert -input=app/models/ file_rec/async<cr>
nnoremap [unite]rv :Unite -no-split -start-insert -input=app/views/ file_rec/async<cr>
nnoremap [unite]ra :Unite -no-split -start-insert -input=app/assets/ file_rec/async<cr>
nnoremap [unite]rs :Unite -no-split -start-insert -input=spec/ file_rec/async<cr>

" Grepping
nnoremap [unite]g :Unite -no-split grep:.<cr>
nnoremap [unite]d :Unite -no-split grep:.:-s:\(TODO\|FIXME\)<cr>

" Content
nnoremap [unite]o :Unite -no-split -start-insert -auto-preview outline<cr>
nnoremap [unite]l :Unite -no-split -start-insert line<cr>
nnoremap [unite]t :!retag<cr>:Unite -no-split -auto-preview -start-insert tag<cr>

" Quickly switch between recent things
nnoremap [unite]F :Unite -no-split buffer tab file_mru directory_mru<cr>
nnoremap [unite]b :Unite -no-split buffer<cr>
nnoremap [unite]m :Unite -no-split file_mru<cr>

" Yank history
nnoremap [unite]y :Unite -no-split history/yank<cr>


" - - - - - - - - - - - - - - - - - - - -
" YouCompleteMe
let g:ycm_autoclose_preview_window_after_insertion=1
" interesting suggestion -- trying it out for a bit...
inoremap jk <Esc>


" - - - - - - - - - - - - - - - - - - - -
" tern
let g:tern_map_keys=1
let g:tern_show_argument_hints='on_hold'


" - - - - - - - - - - - - - - - - - - - -
" vim-json
let g:vim_json_syntax_conceal = 0
nmap <leader>jj :call Toggle_vim_json_syntax_conceal()<cr>
function! Toggle_vim_json_syntax_conceal()
    if g:vim_json_syntax_conceal
        let g:vim_json_syntax_conceal = 0
        setlocal conceallevel=0
    else
        let g:vim_json_syntax_conceal = 1
        setlocal conceallevel=2
    endif
endfunction


" - - - - - - - - - - - - - - - - - - - -
" vim-airline
set laststatus=2
set noshowmode					" If in Insert, Replace or Visual mode put a message on the last line.
set relativenumber				" Yay!
"set number						" Line Numbers

" make your own theme: https://github.com/bling/vim-airline/wiki/FAQ#where-should-i-store-my-own-custom-theme
"let g:airline_theme='your_theme_name'
"let g:airline_powerline_fonts = 1
"let g:bufferline_echo=0
"let g:airline_left_sep = '?'
"let g:airline_left_sep = '?'
"let g:airline_right_sep = '?'
"let g:airline_right_sep = '?'


" ----------------------------------------
" when VimPrint works... (vidcasting)
"set noshowcmd					" show partial commands in status line and selected characters/lines in visual mode
"in the mean time...
set showcmd						" show partial commands in status line and selected characters/lines in visual mode


" ----------------------------------------
" [was] based on bufexplorer bindings ^_^
nnoremap <leader>be :Unite -no-split buffer<cr>
nmap <leader>bb :b#<CR>


" ----------------------------------------
" indent
set autoindent					" indent at the same level of the previous line
set smartindent					" try to be smart about indenting (C-style)
set smarttab
set noexpandtab					" expand <Tab>s with spaces; run ":retab!" to convert whole file
set shiftwidth=4				" spaces for each step of (auto)indent
set softtabstop=4				" set virtual tab stop (compat for 8-wide tabs)
set tabstop=4					" for proper display of files with tabs
set shiftround					" always round indents to multiple of shiftwidth
set copyindent					" use existing indents for new indents
set preserveindent				" save as much indent structure as possible


" ----------------------------------------
" folding lines
set foldmethod=marker			" manual, indent, syntax, expr, marker, diff
set foldlevel=1
nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>
"set foldcolumn=3				" show the folds (level) on the side bar


" ----------------------------------------
" gVIM
"if has("gui_running")
	set guioptions-=T			" remove toolbar
	"set guioptions+=b			" show horizontal scroll bar
	set guifont=Monospace\ 9
"endif


" ----------------------------------------
" filetypes
filetype plugin indent on		" load filetype plugins and indent settings
"filetype on					"		Enable filetype detection
"filetype indent on				"		Enable filetype-specific indenting
"filetype plugin on				"		Enable filetype-specific plugins


" ============================================================
" ============================================================











" i don't use the rest of the following (as my default settings), but
" leaving here to help me remember how to do some of the stuff listed below
finish











" ============================================================
" ============================================================

" wrapping (soft)
set wrap linebreak nolist		" [list] displays unprintable characters which will override [linebreak] option
set showbreak=…					" character to lead each 'display line' after the first one (alternative to :set number)

" wrapping (hard)
set textwidth=80				" maximum line width
set wrapmargin=5				" wrap text from right margin
set formatoptions+=t			" auto-wrap text using textwidth
set formatoptions+=a			" automatic formating of paragraph (best seen when deleting words)
" to format manually:
" gqip -- format inner paragraph, move cursor to end of paragraph
" gwip -- format inner paragraph, keep cursor on the same word - (and is vim's internal parser)

" gq can call external parsers:
set formatprg=par\ -w40r		" r - pads comment
set formatprg=par\ -w40rj		" j - justify blocks
set formatprg=par\ -w40re		" e - removes superfluous lines
set formatprg=par\ -w40q		" q - nested quotes

" --------------------------------------------------

" split window nav
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l
map <C-H> <C-W>h

" --------------------------------------------------

" backups
set backupdir=~/.vim/tmp/backup	" backups
set directory=~/.vim/tmp/swap	" swap files

" save with :wundo
" read with :rundo
" g- --> move to previous change -- i.e. :earlier
" g+ --> move through forward    -- i.e. :later
set undofile					" persistent undo
set undodir=~/.vim/tmp/undo		" undo files

" --------------------------------------------------

" Source the vimrc file after saving it. This way, you don't have to reload Vim to see the changes.
if has("autocmd")
	augroup myvimrchooks
		au!
		autocmd bufwritepost .vimrc source ~/.vimrc
	augroup END
endif

" this can also be achieved with:
" :so %							" while editing .vimrc
" :so ~/.vimrc

" NOTE: the changes may take on a per buffer state
"       -- so you may still need to reload Vim to see the settings globally

" --------------------------------------------------

set autochdir	" always switch to the current file directory
		" *** Messes with some plugins or not every vim is compiled with this,
		"     use the following line instead

autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
		" *** If you use command-t plugin, it conflicts with this
		"
		" NOTE: the NERDTree plugin also provides this functionality

"ALTERNATIVE: Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" --------------------------------------------------

" default leader is '\', but ',' is in a standard location
let mapleader = ','

" --------------------------------------------------

" Make ; work like : for commands. Saves typing and eliminates :W style typos due to lazy holding shift.
nnoremap ; :


" ============================================================
" ============================================================

" add ft support editor-side for 'custom/propietary' file extensions
" don't need to pollute filetype.vim -- just place here in vimrc!

au BufNewFile,BufRead *.mks,*.mkh  setf c
" OR
au BufNewFile,BufRead *.mks,*.mkh
    \ if exists("c_syntax_for_h") | setf c | else | setf cpp | endif


" ============================================================
" ============================================================
