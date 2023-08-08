-- '<,'>s/\(vim\.opt\.\w\+\) \+= \+\(.\+\)/\=printf("%-30s = %s", submatch(1), submatch(2))

vim.opt.number          = true
vim.opt.numberwidth     = 1
vim.opt.relativenumber  = true
vim.opt.title           = true
vim.opt.winminheight    = 1
vim.opt.winminwidth     = 1
vim.opt.expandtab       = true
vim.opt.cindent         = true
vim.opt.smartindent     = true
vim.opt.wrap            = false
vim.opt.smartcase       = true
vim.opt.smartindent     = true -- Insert indents automatically
vim.opt.cursorline      = true
vim.opt.termguicolors   = true
vim.opt.splitright      = true
vim.opt.splitbelow      = true
vim.opt.mousemodel      = "extend"
vim.opt.mousescroll     = "ver:5,hor:0"
vim.opt.swapfile        = false
vim.opt.fileformats     = 'dos'
vim.opt.foldmethod      = "indent"
vim.opt.foldlevel       = 99
vim.opt.signcolumn      = "auto:1"
-- vim.opt.foldcolumn      = 'auto:1'
vim.opt.timeoutlen      = 300
vim.opt.updatetime      = 200
vim.opt.titlestring     = "Neovim"
-- vim.opt.background      = "dark" -- 耗时高
-- vim.opt.backspace       = "indent,eol,start"
-- vim.opt.iskeyword       = '@,48-57,_,192-255'
-- vim.opt.autoindent      = true -- true

vim.opt.shortmess:append({ W = true, I = true, c = true })
vim.opt.showmode        = false -- Dont show mode since we have a statusline

if vim.fn.has("nvim-0.9.0") == 1 then
  vim.opt.splitkeep = "screen"
  vim.opt.shortmess:append({ C = true })
end
vim.opt.undofile        = true
vim.opt.undolevels      = 10000
vim.opt.sidescrolloff   = 8 -- Columns of context
vim.opt.scrolloff       = 4 -- Lines of context
vim.opt.completeopt     = "menu,menuone,noselect"
vim.opt.conceallevel    = 3 -- Hide * markup for bold and italic
vim.opt.list            = true
vim.opt.shada           = [[!,'1000,<500,s10000,h]]
