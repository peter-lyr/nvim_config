-- %s/vim.keymap.set(\s*\({\s*[^\}]\+},\)\s*\(.\+,\)\s*\(.\+,\)\s*\({\s*[^\}]\+\s*}\)\s*)/\=printf("vim.keymap.set(%-18s %-25s %s %s)", submatch(1), submatch(2), submatch(3), submatch(4))

-- alt_num

vim.keymap.set({ 'n', },          '<alt-1>',                '<nop>', { silent = true })
vim.keymap.set({ 'n', },          '<alt-2>',                '<nop>', { silent = true })
vim.keymap.set({ 'n', },          '<alt-3>',                '<nop>', { silent = true })
vim.keymap.set({ 'n', },          '<alt-4>',                '<nop>', { silent = true })
vim.keymap.set({ 'n', },          '<alt-5>',                '<nop>', { silent = true })
vim.keymap.set({ 'n', },          '<alt-6>',                '<nop>', { silent = true })
vim.keymap.set({ 'n', },          '<alt-7>',                '<nop>', { silent = true })
vim.keymap.set({ 'n', },          '<alt-8>',                '<nop>', { silent = true })
vim.keymap.set({ 'n', },          '<alt-9>',                '<nop>', { silent = true })
vim.keymap.set({ 'n', },          '<alt-0>',                '<nop>', { silent = true })

-- change_cwd

vim.keymap.set({ 'n', 'v' },      'c.',                     ':try|cd %:h|ec getcwd()|catch|endtry<cr>', { silent = true })
vim.keymap.set({ 'n', 'v' },      'cu',                     ':try|cd ..|ec getcwd()|catch|endtry<cr>', { silent = true })
vim.keymap.set({ 'n', 'v' },      'c-',                     ':try|cd -|ec getcwd()|catch|endtry<cr>', { silent = true })

-- copy_pase

vim.keymap.set({ 'n', 'v' },      '<a-y>',                  '"+y', { silent = true })
vim.keymap.set({ 'n', 'v' },      '<a-p>',                  '"+p', { silent = true })
vim.keymap.set({ 'n', 'v' },      '<a-s-p>',                '"+P', { silent = true })

vim.keymap.set({ 'c', 'i' },      '<a-w>',                  '<c-r>=g:word<cr>', { silent = true })
vim.keymap.set({ 'c', 'i' },      '<a-v>',                  '<c-r>"', { silent = true })
vim.keymap.set({ 't',     },      '<a-v>',                  '<c-\\><c-n>pi', { silent = true })
vim.keymap.set({ 'c', 'i' },      '<a-=>',                  '<c-r>+', { silent = true })
vim.keymap.set({ 't',     },      '<a-=>',                  '<c-\\><c-n>"+pi', { silent = true })

vim.keymap.set({ 'n', 'v' },      '<leader>y',              '<esc>:let @+ = expand("%:t")<cr>', { silent = true })
vim.keymap.set({ 'n', 'v' },      '<leader>gy',             '<esc>:let @+ = substitute(nvim_buf_get_name(0), "/", "\\\\", "g")<cr>', { silent = true })
vim.keymap.set({ 'n', 'v' },      '<leader><leader>gy',     '<esc>:let @+ = substitute(getcwd(), "/", "\\\\", "g")<cr>', { silent = true })

vim.api.nvim_create_autocmd({ "BufLeave", "CmdlineEnter", }, {
  callback = function()
    local word = vim.fn.expand('<cword>')
    if #word > 0 then
      vim.g.word = word
    end
  end,
})

-- cursor

vim.keymap.set({ 'n', 'v', },     '<c-j>',                  '5j', { silent = true })
vim.keymap.set({ 'n', 'v', },     '<c-k>',                  '5k', { silent = true })

vim.keymap.set({ 't', 'c', 'i' }, '<a-k>',                  '<UP>', { silent = true })
vim.keymap.set({ 't', 'c', 'i' }, '<a-j>',                  '<DOWN>', { silent = true })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-k>',                '<UP><UP><UP><UP><UP>', { silent = true })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-j>',                '<DOWN><DOWN><DOWN><DOWN><DOWN>', { silent = true })
vim.keymap.set({ 't', 'c', 'i' }, '<a-i>',                  '<HOME>', { silent = true })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-i>',                '<HOME>', { silent = true })
vim.keymap.set({ 't', 'c', 'i' }, '<a-o>',                  '<END>', { silent = true })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-o>',                '<END>', { silent = true })
vim.keymap.set({ 't', 'c', 'i' }, '<a-l>',                  '<RIGHT>', { silent = true })
vim.keymap.set({ 't', 'c', 'i' }, '<a-h>',                  '<LEFT>', { silent = true })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-l>',                '<c-RIGHT>', { silent = true })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-h>',                '<c-LEFT>', { silent = true })

vim.keymap.set({ 'v', },          '<c-l>',                  'L', { silent = true })
vim.keymap.set({ 'v', },          '<c-h>',                  'H', { silent = true })
vim.keymap.set({ 'v', },          '<c-g>',                  'G', { silent = true })
vim.keymap.set({ 'v', },          '<c-m>',                  'M', { silent = true })
vim.keymap.set({ 'v', },          '<c-u>',                  'U', { silent = true })
vim.keymap.set({ 'v', },          '<c-e>',                  'E', { silent = true })
vim.keymap.set({ 'v', },          '<c-w>',                  'W', { silent = true })
vim.keymap.set({ 'v', },          '<c-b>',                  'B', { silent = true })

-- esc

vim.keymap.set({ 'v', },          'm',                      '<esc>', { silent = true })

vim.keymap.set({ 'i', 'c', },     'ql',                     '<esc><esc>', { silent = true })
vim.keymap.set({ 'i', 'c', },     'qL',                     '<esc><esc>', { silent = true })
vim.keymap.set({ 'i', 'c', },     'Ql',                     '<esc><esc>', { silent = true })
vim.keymap.set({ 'i', 'c', },     'QL',                     '<esc><esc>', { silent = true })

vim.keymap.set({ 't', },          'ql',                     '<c-\\><c-n>', { silent = true })
vim.keymap.set({ 't', },          'qL',                     '<c-\\><c-n>', { silent = true })
vim.keymap.set({ 't', },          'Ql',                     '<c-\\><c-n>', { silent = true })
vim.keymap.set({ 't', },          'QL',                     '<c-\\><c-n>', { silent = true })

vim.keymap.set({ 'i', 'c' },      '<a-m>',                  '<esc><esc>', { silent = true })
vim.keymap.set({ 't',     },      '<esc>',                  '<c-\\><c-n>', { silent = true })
vim.keymap.set({ 't',     },      '<a-m>',                  '<c-\\><c-n>', { silent = true })

-- enter

vim.keymap.set({ 'i', },          'qo',                     '<esc>o', { silent = true })
vim.keymap.set({ 'i', },          'Qo',                     '<esc>o', { silent = true })
vim.keymap.set({ 'i', },          'qO',                     '<esc>o', { silent = true })
vim.keymap.set({ 'i', },          'QO',                     '<esc>o', { silent = true })

vim.keymap.set({ 't', 'c', },     'qo',                     '<cr>', { silent = true })
vim.keymap.set({ 't', 'c', },     'Qo',                     '<cr>', { silent = true })
vim.keymap.set({ 't', 'c', },     'qO',                     '<cr>', { silent = true })
vim.keymap.set({ 't', 'c', },     'QO',                     '<cr>', { silent = true })

-- f5

vim.keymap.set({ 'n', 'v' },      '<f5>',                   ':<c-u>e!<cr>', { silent = true })

-- mouse

vim.keymap.set({ 'n', 'v', 'i' }, '<rightmouse>',           '<leftmouse>', { silent = true })
vim.keymap.set({ 'n', 'v', 'i' }, '<rightrelease>',         '<nop>', { silent = true })
vim.keymap.set({ 'n', 'v', 'i' }, '<middlemouse>',          '<nop>', { silent = true })

-- record

vim.keymap.set({ 'n', 'v' },      'q',                      '<nop>', { silent = true })
vim.keymap.set({ 'n', 'v' },      'Q',                      'q', { silent = true })

-- source

vim.keymap.set({ 'n', 'v' },      '<leader>f.',             ':if (&ft == "vim" || &ft == "lua") | source %:p | endif<cr>', { silent = true })

-- undo

vim.keymap.set({ 'n', },          'U',                      '<c-r>', { silent = true })
