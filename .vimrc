"set shiftwidth=4 " auto-indent amount when using cindent,
                 " >>, << and stuff like that
set shiftround " when at 3 spaces, and I hit > ... go to 4, not 5

set autoindent
"set smartindent " replaced by cindent

filetype on
"set tabstop=2
"set expandtab
"retab
set cindent
set noerrorbells
set nohls " don't high light searchs
"set backup " make backup files
"set backupdir=~/.vim/backups " where to put backup files
set guioptions-=T " remove toolbar in gui version
set ruler " status line
set nocompatible " fuck vi and its bugs
set autoread " watch for file changes by other programs
set number " show number lines
set list " we do what to show tabs, to ensure we get them
         " out of my files
set listchars=tab:>-,trail:- " show tabs and trailing 
set showcmd " show the command being typed
set showmatch " show matching brackets


noremap s l
noremap t j
noremap n k

"map <C-J> <C-W>j<C-W>_
"map <C-K> <C-W>k<C-W>_

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif


" * Spelling
" define `Ispell' language and personal dictionary, used in several places
" below:
let IspellLang = 'british'
let PersonalDict = '~/.ispell_' . IspellLang


"colorscheme desert
"colorscheme wombat
"colorscheme pyte
"colorscheme anotherdark
"colorscheme blackdust
"colorscheme darkspectrum
"colorscheme kellys
"colorscheme paintbox
"colorscheme summerfruit
"colorscheme cloudcity
"colorscheme autumnleaf
"colorscheme jellybeans2
"colorscheme oceandeep
"colorscheme pacific
"colorscheme torte "CLI
colorscheme dante
"colorscheme baycomb
