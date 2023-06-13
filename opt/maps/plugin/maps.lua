-- %s/vim.keymap.set(\({[ 'nvtic,]\+},\)\s\+\([^ ]\+,\)\s\+\(.\+\))/\=printf("vim.keymap.set(%-18s %-25s %s)", submatch(1), submatch(2), submatch(3))

-- alt_num

vim.keymap.set({ 'n', },          '<alt-1>',                '<nop>', { silent = true, desc = 'nop' })
vim.keymap.set({ 'n', },          '<alt-2>',                '<nop>', { silent = true, desc = 'nop' })
vim.keymap.set({ 'n', },          '<alt-3>',                '<nop>', { silent = true, desc = 'nop' })
vim.keymap.set({ 'n', },          '<alt-4>',                '<nop>', { silent = true, desc = 'nop' })
vim.keymap.set({ 'n', },          '<alt-5>',                '<nop>', { silent = true, desc = 'nop' })
vim.keymap.set({ 'n', },          '<alt-6>',                '<nop>', { silent = true, desc = 'nop' })
vim.keymap.set({ 'n', },          '<alt-7>',                '<nop>', { silent = true, desc = 'nop' })
vim.keymap.set({ 'n', },          '<alt-8>',                '<nop>', { silent = true, desc = 'nop' })
vim.keymap.set({ 'n', },          '<alt-9>',                '<nop>', { silent = true, desc = 'nop' })
vim.keymap.set({ 'n', },          '<alt-0>',                '<nop>', { silent = true, desc = 'nop' })

-- change_cwd

vim.keymap.set({ 'n', 'v' },      'c.',                     ':try|cd %:h|ec getcwd()|catch|endtry<cr>', { silent = true, desc = 'cd %:h' })
vim.keymap.set({ 'n', 'v' },      'cu',                     ':try|cd ..|ec getcwd()|catch|endtry<cr>', { silent = true, desc = 'cd ..' })
vim.keymap.set({ 'n', 'v' },      'c-',                     ':try|cd -|ec getcwd()|catch|endtry<cr>', { silent = true, desc = 'cd -' })

-- copy_pase

vim.keymap.set({ 'n', 'v' },      '<a-y>',                  '"+y', { desc = '"+y' })
vim.keymap.set({ 'n', 'v' },      '<a-p>',                  '"+p', { desc = '"+p' })
vim.keymap.set({ 'n', 'v' },      '<a-s-p>',                '"+P', { desc = '"+P' })

vim.keymap.set({ 'c', 'i' },      '<a-w>',                  '<c-r>=g:word<cr>', { desc = 'paste g:word' })
vim.keymap.set({ 'c', 'i' },      '<a-v>',                  '<c-r>"', { desc = 'paste "' })
vim.keymap.set({ 't', },          '<a-v>',                  '<c-\\><c-n>pi', { desc = 'paste "' })
vim.keymap.set({ 'c', 'i' },      '<a-=>',                  '<c-r>+', { desc = 'paste +' })
vim.keymap.set({ 't', },          '<a-=>',                  '<c-\\><c-n>"+pi', { desc = 'paste +' })

vim.keymap.set({ 'n', 'v' },      '<leader>y',              '<esc>:let @+ = expand("%:t")<cr>', { desc = 'copy %:t to +' })
vim.keymap.set({ 'n', 'v' },      '<leader>gy',             '<esc>:let @+ = substitute(nvim_buf_get_name(0), "/", "\\\\", "g")<cr>', { desc = 'copy fullpath to +' })
vim.keymap.set({ 'n', 'v' },      '<leader><leader>gy',     '<esc>:let @+ = substitute(getcwd(), "/", "\\\\", "g")<cr>', { desc = 'copy cwd to +' })

vim.api.nvim_create_autocmd({ "BufLeave", "CmdlineEnter", }, {
  callback = function()
    local word = vim.fn.expand('<cword>')
    if #word > 0 then
      vim.g.word = word
    end
  end,
})

-- cursor

vim.keymap.set({ 'n', 'v', },     '<c-j>',                  '5j', { desc = '5j' })
vim.keymap.set({ 'n', 'v', },     '<c-k>',                  '5k', { desc = '5k' })

vim.keymap.set({ 't', 'c', 'i' }, '<a-k>',                  '<UP>', { desc = 'up' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-j>',                  '<DOWN>', { desc = 'down' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-k>',                '<UP><UP><UP><UP><UP>', { desc = '5 up' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-j>',                '<DOWN><DOWN><DOWN><DOWN><DOWN>', { desc = '5 down' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-i>',                  '<HOME>', { desc = 'home' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-i>',                '<HOME>', { desc = 'home' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-o>',                  '<END>', { desc = 'end' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-o>',                '<END>', { desc = 'end' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-l>',                  '<RIGHT>', { desc = 'right' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-h>',                  '<LEFT>', { desc = 'left' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-l>',                '<c-RIGHT>', { desc = 'ctrl right' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-h>',                '<c-LEFT>', { desc = 'ctrl left' })

vim.keymap.set({ 'v', },          '<c-l>',                  'L', { desc = 'L' })
vim.keymap.set({ 'v', },          '<c-h>',                  'H', { desc = 'H' })
vim.keymap.set({ 'v', },          '<c-g>',                  'G', { desc = 'G' })
vim.keymap.set({ 'v', },          '<c-m>',                  'M', { desc = 'M' })
vim.keymap.set({ 'v', },          '<c-u>',                  'U', { desc = 'U' })
vim.keymap.set({ 'v', },          '<c-e>',                  'E', { desc = 'E' })
vim.keymap.set({ 'v', },          '<c-w>',                  'W', { desc = 'W' })
vim.keymap.set({ 'v', },          '<c-b>',                  'B', { desc = 'B' })

-- esc

vim.keymap.set({ 'v', },          'm',                      '<esc>', { desc = 'esc' })

vim.keymap.set({ 'i', 'c', },     'ql',                     '<esc><esc>', { desc = 'esc' })
vim.keymap.set({ 'i', 'c', },     'qL',                     '<esc><esc>', { desc = 'esc' })
vim.keymap.set({ 'i', 'c', },     'Ql',                     '<esc><esc>', { desc = 'esc' })
vim.keymap.set({ 'i', 'c', },     'QL',                     '<esc><esc>', { desc = 'esc' })

vim.keymap.set({ 't', },          'ql',                     '<c-\\><c-n>', { desc = 'esc' })
vim.keymap.set({ 't', },          'qL',                     '<c-\\><c-n>', { desc = 'esc' })
vim.keymap.set({ 't', },          'Ql',                     '<c-\\><c-n>', { desc = 'esc' })
vim.keymap.set({ 't', },          'QL',                     '<c-\\><c-n>', { desc = 'esc' })

vim.keymap.set({ 'i', 'c' },      '<a-m>',                  '<esc><esc>', { desc = 'esc' })
vim.keymap.set({ 't', },          '<esc>',                  '<c-\\><c-n>', { desc = 'esc' })
vim.keymap.set({ 't', },          '<a-m>',                  '<c-\\><c-n>', { desc = 'esc' })

-- enter

vim.keymap.set({ 'i', },          'qo',                     '<esc>o', { desc = 'new line' })
vim.keymap.set({ 'i', },          'Qo',                     '<esc>o', { desc = 'new line' })
vim.keymap.set({ 'i', },          'qO',                     '<esc>o', { desc = 'new line' })
vim.keymap.set({ 'i', },          'QO',                     '<esc>o', { desc = 'new line' })

vim.keymap.set({ 't', 'c', },     'qo',                     '<cr>', { desc = 'enter' })
vim.keymap.set({ 't', 'c', },     'Qo',                     '<cr>', { desc = 'enter' })
vim.keymap.set({ 't', 'c', },     'qO',                     '<cr>', { desc = 'enter' })
vim.keymap.set({ 't', 'c', },     'QO',                     '<cr>', { desc = 'enter' })

-- f5

vim.keymap.set({ 'n', 'v' },      '<f5>',                   ':<c-u>e!<cr>', { silent = true, desc = 'e!' })

-- mouse

vim.keymap.set({ 'n', 'v', 'i' }, '<rightmouse>',           '<leftmouse>', { silent = true, desc = 'leftmouse' })
vim.keymap.set({ 'n', 'v', 'i' }, '<rightrelease>',         '<nop>', { silent = true, desc = 'nop' })
vim.keymap.set({ 'n', 'v', 'i' }, '<middlemouse>',          '<nop>', { silent = true, desc = 'nop' })

-- record

vim.keymap.set({ 'n', 'v' },      'q',                      '<nop>', { silent = true, desc = 'nop' })
vim.keymap.set({ 'n', 'v' },      'Q',                      'q', { silent = true, desc = 'record' })

-- source

vim.keymap.set({ 'n', 'v' },      '<leader>f.',             ':if (&ft == "vim" || &ft == "lua") | source %:p | endif<cr>', { silent = true, desc = 'source vim or lua' })

-- undo

vim.keymap.set({ 'n', },          'U',                      '<c-r>', { silent = true, desc = 'redo' })
