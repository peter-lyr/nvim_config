vim.opt.number         = true
vim.opt.numberwidth    = 1
vim.opt.relativenumber = true
vim.opt.title          = true
vim.opt.winminheight   = 1
vim.opt.winminwidth    = 1
vim.opt.expandtab      = true
vim.opt.cindent        = true
vim.opt.smartindent    = true
vim.opt.wrap           = false
vim.opt.smartcase      = true
vim.opt.smartindent    = true -- Insert indents automatically
vim.opt.cursorline     = true
vim.opt.cursorcolumn   = true
vim.opt.termguicolors = true
vim.opt.splitright    = true
vim.opt.splitbelow    = true
vim.opt.mousemodel    = 'extend'
vim.opt.mousescroll   = 'ver:5,hor:0'
vim.opt.swapfile      = false
vim.opt.fileformats   = 'dos'
vim.opt.foldmethod    = 'indent'
vim.opt.foldlevel     = 99
-- local ver             = vim.version()
vim.opt.titlestring   = 'Neovim-094' -- string.format('v%d.%d.%d-Neovim', ver['major'], ver['minor'], ver['patch'])
vim.opt.fileencodings = 'utf-8,gbk,default,ucs-bom,latin'

vim.opt.shortmess:append { W = true, I = true, c = true, }
vim.opt.showmode      = true -- Dont show mode since we have a statusline

vim.opt.undofile      = true
vim.opt.undolevels    = 10000
vim.opt.sidescrolloff = 0      -- Columns of context
vim.opt.scrolloff     = 0      -- Lines of context
vim.opt.scrollback    = 100000 -- Lines of context
vim.opt.completeopt   = 'menu,menuone,noselect'
vim.opt.conceallevel  = 0      -- Hide * markup for bold and italic
vim.opt.list          = true
vim.opt.shada         = [[!,'1000,<500,s10000,h]]
vim.opt.laststatus    = 3
vim.opt.statusline    = [[%f %h%m%r%=%<%-14.(%l,%c%V%) %P]]
vim.opt.equalalways   = false
