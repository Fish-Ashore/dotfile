vim9script

# ============================================================
# 基础配置
# ============================================================

set nocompatible
filetype plugin indent on

# Leader 键
g:mapleader = ","

# ============================================================
# 界面与显示
# ============================================================

set number
set relativenumber
set cursorline
set showmatch
set showcmd
set laststatus=2
syntax enable

if has("gui_running")
    &guifont = "Monospace 12"
endif

set title

# ============================================================
# 编辑与搜索
# ============================================================

set smartindent
&tabstop = 4
&shiftwidth = 4
&expandtab = true

set wrap
set linebreak

set ignorecase
set smartcase
set hlsearch
set incsearch

# 按空格取消搜索高亮
nnoremap <silent> <Space> <Cmd>nohlsearch<CR>

# ============================================================
# 文件编码与备份
# ============================================================

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,gbk,gb2312,cp936

set nobackup
set noswapfile
set nowritebackup

# ============================================================
# 快捷键映射
# ============================================================

# 保存
# nnoremap <C-w> <Cmd>w<CR>
nnoremap <leader>w <Cmd>w<CR>

# 退出
nnoremap <leader>q <Cmd>q<CR>
nnoremap <leader>Q <Cmd>q!<CR>

# 重载配置
nnoremap <leader>sv <Cmd>source $MYVIMRC<CR>

# 分屏
nnoremap <leader>h <Cmd>split<CR>
nnoremap <leader>v <Cmd>vsplit<CR>

# 分屏间切换
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

# NERDTree
nnoremap <leader>n <Cmd>NERDTreeToggle<CR>

# 全选
nnoremap <C-a> ggVG

# 系统剪贴板
vnoremap <leader>y "+y
nnoremap <leader>Y "+y$
nnoremap <leader>p "+p

# 自动补全成对符号
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap " ""<Left>
inoremap ' ''<Left>

# Alt + j/k 移动行（终端里 Alt 常被发成 Esc+字母）
map <Esc>j <A-j>
map <Esc>k <A-k>
nnoremap <A-j> <Cmd>m .+1<CR>==
nnoremap <A-k> <Cmd>m .-2<CR>==
vnoremap <A-j> <Cmd>m '>+1<CR>gv=gv
vnoremap <A-k> <Cmd>m '<-2<CR>gv=gv

# 保存时清理行尾空白（按需取消注释）
autocmd BufWritePre * :%s/\s\+$//e

# ============================================================
# vim-plug 自动安装
# ============================================================

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

# 插件列表
plug#begin('~/.vim/plugged')

Plug 'catppuccin/vim', { 'branch': 'vim', 'as': 'catppuccin' }

Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'airblade/vim-gitgutter'
Plug 'Yggdroot/indentLine'
Plug 'mhinz/vim-startify'
Plug 'mileszs/ack.vim'

plug#end()

# ============================================================
# 主题
# ============================================================

set termguicolors
set background=dark
colorscheme catppuccin

# ============================================================
# 插件个性化配置
# ============================================================

# NERDTree
g:NERDTreeShowHidden = 1
g:NERDTreeMinimalUI  = 1
g:NERDTreeDirArrows  = 1

# Lightline
set noshowmode
g:lightline = {
    'colorscheme': 'powerline',
    'active': {
        'left': [
            ['mode', 'paste'],
            ['gitbranch', 'readonly', 'filename', 'modified']
        ]
    },
    'component_function': {
        'gitbranch': 'FugitiveHead'
    }
}

if exists('g:loaded_gitgutter')
    set signcolumn=yes
endif

# fzf
nnoremap <leader>f <Cmd>Files<CR>
nnoremap <leader>b <Cmd>Buffers<CR>
nnoremap <leader>g <Cmd>GFiles<CR>

# indentLine
g:indentLine_enabled = 1
g:indentLine_char    = '│'

# startify
g:startify_lists = [
    { 'type': 'files',    'header': ['   Recent Files'] },
    { 'type': 'dir',      'header': ['   Recent Files in Current Directory'] },
    { 'type': 'sessions', 'header': ['   Sessions'] }
]


def Format()
    var ft = &filetype
    var cmd = ''
    if ft == 'go'
        cmd = 'gofmt'
    elseif ft == 'python'
        cmd = 'black -q -'
    elseif ft == 'rust'
        cmd = 'rustfmt'
    elseif ft == 'javascript' || ft == 'typescript'
        cmd = 'prettier --stdin-filepath ' .. expand('%')
    elseif ft == 'json'
        cmd = 'python3 -m json.tool'
    elseif ft == 'c' || ft == 'cpp'
        cmd = 'clang-format'
    else
        cmd = ''
    endif

    if cmd == ''
        echo '没有配置 ' .. ft .. ' 的格式化工具'
        return
    endif

    # 保留光标位置和滚动位置
    var pos = getpos('.')
    var view = winsaveview()
    silent execute '%!' .. cmd
    call setpos('.', pos)
    winrestview(view)
enddef

command! Format Format()
nnoremap <leader>F <Cmd>Format<CR>

