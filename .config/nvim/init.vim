set shell=/bin/bash
let mapleader = "\<Space>"

" ####################################################
" PLUGINS
" ####################################################

call plug#begin()
Plug 'ciaranm/securemodelines' 
Plug 'justinmk/vim-sneak'

" modeline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" highlight yanked selection
Plug 'machakann/vim-highlightedyank'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Git stuff
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

Plug 'arcticicestudio/nord-vim'

" Completion
" ==============================================
        Plug 'dense-analysis/ale'

	Plug 'neoclide/coc.nvim', {'branch': 'release'}

	" Languages
	Plug 'cespare/vim-toml'
	Plug 'stephpy/vim-yaml'
	Plug 'rust-lang/rust.vim'
	Plug 'rhysd/vim-clang-format'
	Plug 'plasticboy/vim-markdown'
" ==============================================
call plug#end()

let g:sneak#s_next=1

" fuzzy finder
if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
endif

function! s:list_cmd()
 let base = fnamemodify(expand('%'), ':h:.:S')
 return base == '.' ? 'fd --type file --follow' : printf('fd --type file --follow | proximity-sort %s', shellescape(expand('%')))
endfunction

command! -bang -nargs=? -complete=dir Files
 \ call fzf#vim#files(<q-args>, {'source': s:list_cmd(),
 \                               'options': ['--tiebreak=index', '--preview']}, <bang>0)

" modeline
let g:airlie_theme='nord'
let g:airline_powerline_fonts = 1

" Completion
" ==============================================
        " ALE
	let g:ale_disable_lsp = 1

	function! s:check_back_space() abort
		  let col = col('.') - 1
		    return !col || getline('.')[col - 1]  =~# '\s'
	    endfunction

	" Use tab to trigger completion
	inoremap <silent><expr> <TAB>
	      \ pumvisible() ? "\<C-n>" :
	      \ <SID>check_back_space() ? "\<TAB>" :
	      \ coc#refresh()
	inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
	
	" Use <c-space> to trigger completion.
	 if has('nvim')
	   inoremap <silent><expr> <c-space> coc#refresh()
	else
	  inoremap <silent><expr> <c-@> coc#refresh()
	endif
	
	inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
	                      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
	
	" Use `[g` and `]g` to navigate diagnostics
	" Use `:CocDiagnostics` to get all diagnostics of current buffer in
	" location list.
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)
	
	" GoTo code navigation.
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)
	
	" Use K to show documentation in preview window.
	nnoremap <silent> K :call <SID>show_documentation()<CR>
	
	function! s:show_documentation()
	  if (index(['vim','help'], &filetype) >= 0)
	      execute 'h '.expand('<cword>')
	  elseif (coc#rpc#ready())
	      call CocActionAsync('doHover')
	  else
 	      execute '!' . &keywordprg . " " .
	      expand('<cword>')
	  endif
	endfunction
  
    xmap <leader>fm <Plug>(coc-format-selected)
    nmap <leader>fm <Plug>(coc-format-selected)

    " Code action
    nmap <leader>ac <Plug>(coc-codeaction)


    " Code Action for selected region
    xmap <leader>a <Plug>(coc-codeaction-selected)
    nmap <leader>a <Plug>(coc-codeaction-selected)

	" Highlight the symbol and its references when
	" holding the cursor.
	autocmd CursorHold * silent call CocActionAsync('highlight')
	
	" Symbol renaming.
	nmap <leader>rn <Plug>(coc-rename)

        nmap <C-Space> <Plug>(coc-codeaction)

	" Quickfix!
	nmap <leader>qf <Plug>(coc-fix-current)

	set shortmess+=c	
	set cmdheight=2 " For diplay messages
	set updatetime=300 " Update messages quicker

	" rust stuff
	let g:rustfmt_autosave = 1
	let g:rustfmt_emit_files = 1
	let g:rustfmt_fail_silently = 0


    " Prettier
    "
    command! -nargs=0 Prettier :CocCommand prettier.formatFile
" ==============================================


" SECURE MODE-LINES
let g:secure_modelines_allowed_items = [
                \ "textwidth",   "tw",
                \ "softtabstop", "sts",
                \ "tabstop",     "ts",
                \ "shiftwidth",  "sw",
                \ "expandtab",   "et",   "noexpandtab", "noet",
                \ "filetype",    "ft",
                \ "foldmethod",  "fdm",
                \ "readonly",    "ro",   "noreadonly", "noro",
                \ "rightleft",   "rl",   "norightleft", "norl",
                \ "colorcolumn"
                \ ]

" VIM SNEAK
let g:sneak#snext=1

" ####################################################
" LOOK AND FEEL
" ####################################################

colorscheme nord
set guioptions-=T " No toolbar
set vb t_vb= " No beeping
set relativenumber " Relative
set number	   " And Absolute numbers
set colorcolumn=80 
set mouse=a " Enable mouse usage ????

set listchars=nbsp:¬,extends:»,precedes:«,trail:•

set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

set inccommand=nosplit
noremap <C-q> :confirm qall<CR>

set scrolloff=2
set noshowmode
set hidden
set nowrap
set nojoinspaces

" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" ####################################################
" KEYBINDINGS
" ####################################################



nnoremap ; :

nnoremap <C-j> <Esc>
inoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
snoremap <C-j> <Esc>
xnoremap <C-j> <Esc>
cnoremap <C-j> <C-c>
onoremap <C-j> <Esc>
lnoremap <C-j> <Esc>
tnoremap <C-j> <Esc>

nnoremap <C-k> <Esc>
inoremap <C-k> <Esc>
vnoremap <C-k> <Esc>
snoremap <C-k> <Esc>
xnoremap <C-k> <Esc>
cnoremap <C-k> <C-c>
onoremap <C-k> <Esc>
lnoremap <C-k> <Esc>
tnoremap <C-k> <Esc>

" Start and end from home row
map H ^
map L $

" <leader>s for Rg search
noremap <leader>s :Rg
let g:fzf_layout = { 'down': '~20%' }
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always
  \ '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)


" No arrow keys --- force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

" Move by line
nnoremap j gj
nnoremap k gk

map <leader><leader> <c-^>
map <leader>f :GFiles<CR>
nmap <leader>; :Buffers<CR>
nmap <leader>w :w<CR>
map <leader>wq :wqa<CR>
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" XClip integration
function! ClipboardYank()
    call system('xclip -o -selection clipboard', @@)
endfunction
function! ClipboardPaste()
    let @@ = system('xclip -o -selection clipboard')
endfunction

vnoremap <silent> y y:call ClipboardYank()<cr>
vnoremap <silent> d d:cll ClipboardYank()<cr>
nnoremap <silent> p :call ClipboardPaste()<cr>p

" FOR EDITING VIMRC AUTORELOAD
"
map <leader>wv :source $MYVIMRC<CR>
