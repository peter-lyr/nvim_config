-- %s/vim.keymap.set(\({[ 'nvtic,]\+},\)\s\+\([^ ]\+,\)\s\+\(.\+\))/\=printf("vim.keymap.set(%-18s %-10s %s)", submatch(1), submatch(2), submatch(3))

-- copy_paste

vim.fn.setreg('w', 'reg w empty')

vim.keymap.set({ 'c', 'i' },      '<a-w>',   '<c-r>w', { desc = 'paste <cword>' })
vim.keymap.set({ 'c', 'i' },      'qw',      '<c-r>w', { desc = 'paste <cword>' })

vim.keymap.set({ 'c', 'i' },      '<a-v>',   '<c-r>"', { desc = 'paste "' })
vim.keymap.set({ 'c', 'i' },      'qv',      '<c-r>"', { desc = 'paste "' })

vim.keymap.set({ 't', },          '<a-v>',   '<c-\\><c-n>pi', { desc = 'paste "' })
vim.keymap.set({ 't', },          'qv',      '<c-\\><c-n>pi', { desc = 'paste "' })

vim.keymap.set({ 'c', 'i' },      '<a-=>',   '<c-r>+', { desc = 'paste +' })
vim.keymap.set({ 'c', 'i' },      'q=',      '<c-r>+', { desc = 'paste +' })

vim.keymap.set({ 't', },          '<a-=>',   '<c-\\><c-n>"+pi', { desc = 'paste +' })
vim.keymap.set({ 't', },          'q=',      '<c-\\><c-n>"+pi', { desc = 'paste +' })

vim.api.nvim_create_autocmd({ "BufLeave", "CmdlineEnter", }, {
  callback = function()
    local word = vim.fn.expand('<cword>')
    if #word > 0 then
      vim.fn.setreg('w', word)
    end
  end,
})

-- cursor

vim.keymap.set({ 't', 'c', 'i' }, '<a-k>',   '<UP>', { desc = 'up' })
vim.keymap.set({ 't', 'c', 'i' }, 'qk',      '<UP>', { desc = 'up' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-j>',   '<DOWN>', { desc = 'down' })
vim.keymap.set({ 't', 'c', 'i' }, 'qj',      '<DOWN>', { desc = 'down' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-k>', '<UP><UP><UP><UP><UP>', { desc = '5 up' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-j>', '<DOWN><DOWN><DOWN><DOWN><DOWN>', { desc = '5 down' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-i>',   '<HOME>', { desc = 'home' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-i>', '<HOME>', { desc = 'home' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-o>',   '<END>', { desc = 'end' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-o>', '<END>', { desc = 'end' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-l>',   '<RIGHT>', { desc = 'right' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-h>',   '<LEFT>', { desc = 'left' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-l>', '<c-RIGHT>', { desc = 'ctrl right' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-s-h>', '<c-LEFT>', { desc = 'ctrl left' })

vim.keymap.set({ 'v', },          '<c-l>',   'L', { desc = 'L' })
vim.keymap.set({ 'v', },          '<c-h>',   'H', { desc = 'H' })
vim.keymap.set({ 'v', },          '<c-g>',   'G', { desc = 'G' })
vim.keymap.set({ 'v', },          '<c-m>',   'M', { desc = 'M' })
vim.keymap.set({ 'v', },          '<c-u>',   'U', { desc = 'U' })
vim.keymap.set({ 'v', },          '<c-e>',   'E', { desc = 'E' })
vim.keymap.set({ 'v', },          '<c-w>',   'W', { desc = 'W' })
vim.keymap.set({ 'v', },          '<c-b>',   'B', { desc = 'B' })

-- esc

vim.keymap.set({ 'i', 'c', },     'ql',      '<esc><esc>', { desc = 'esc' })
vim.keymap.set({ 'i', 'c', },     'qL',      '<esc><esc>', { desc = 'esc' })
vim.keymap.set({ 'i', 'c', },     'Ql',      '<esc><esc>', { desc = 'esc' })
vim.keymap.set({ 'i', 'c', },     'QL',      '<esc><esc>', { desc = 'esc' })

vim.keymap.set({ 't', },          'ql',      '<c-\\><c-n>', { desc = 'esc' })
vim.keymap.set({ 't', },          'qL',      '<c-\\><c-n>', { desc = 'esc' })
vim.keymap.set({ 't', },          'Ql',      '<c-\\><c-n>', { desc = 'esc' })
vim.keymap.set({ 't', },          'QL',      '<c-\\><c-n>', { desc = 'esc' })

vim.keymap.set({ 'i', 'c' },      '<a-m>',   '<esc><esc>', { desc = 'esc' })
vim.keymap.set({ 't', },          '<esc>',   '<c-\\><c-n>', { desc = 'esc' })
vim.keymap.set({ 't', },          '<a-m>',   '<c-\\><c-n>', { desc = 'esc' })

-- new line

vim.keymap.set({ 'i', },          'qo',      '<esc>o', { desc = 'new line' })
vim.keymap.set({ 'i', },          'Qo',      '<esc>o', { desc = 'new line' })
vim.keymap.set({ 'i', },          'qO',      '<esc>o', { desc = 'new line' })
vim.keymap.set({ 'i', },          'QO',      '<esc>o', { desc = 'new line' })

-- enter

vim.keymap.set({ 't', 'c', },     'qo',      '<cr>', { desc = 'enter' })
vim.keymap.set({ 't', 'c', },     'Qo',      '<cr>', { desc = 'enter' })
vim.keymap.set({ 't', 'c', },     'qO',      '<cr>', { desc = 'enter' })
vim.keymap.set({ 't', 'c', },     'QO',      '<cr>', { desc = 'enter' })
