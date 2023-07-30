-- %s/vim.keymap.set(\({[ 'nvtic,]\+},\)\s\+\([^ ]\+,\)\s\+\(.\+\))/\=printf("vim.keymap.set(%-18s %-10s %s)", submatch(1), submatch(2), submatch(3))

-- copy_paste

vim.fn.setreg('w', 'reg w empty')

vim.keymap.set({ 'c', 'i' },      'vw',      '<c-r>w', { desc = 'paste <cword>' })

vim.keymap.set({ 'c', 'i' },      'vv',      '<c-r>"', { desc = 'paste "' })
vim.keymap.set({ 't', },          'vv',      '<c-\\><c-n>pi', { desc = 'paste "' })
vim.keymap.set({ 'c', 'i' },      'v v',     'v', { desc = 'just type v' })

vim.keymap.set({ 'c', 'i' },      'vs',      '<c-r>+', { desc = 'paste +' })
vim.keymap.set({ 't', },          'vs',      '<c-\\><c-n>"+pi', { desc = 'paste +' })

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
vim.keymap.set({ 't', 'c', 'i' }, 'vk',      '<UP>', { desc = 'up' })
vim.keymap.set({ 't', 'c', 'i' }, '<a-j>',   '<DOWN>', { desc = 'down' })
vim.keymap.set({ 't', 'c', 'i' }, 'vj',      '<DOWN>', { desc = 'down' })
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
vim.keymap.set({ 'v', },          '<c-m>',   'M', { desc = 'M' })
vim.keymap.set({ 'v', },          '<c-u>',   'U', { desc = 'U' })
vim.keymap.set({ 'v', },          '<c-e>',   'E', { desc = 'E' })
vim.keymap.set({ 'v', },          '<c-w>',   'W', { desc = 'W' })
vim.keymap.set({ 'v', },          '<c-b>',   'B', { desc = 'B' })

-- esc

vim.keymap.set({ 'v', },          'v',       '<esc><esc><esc>', { desc = 'esc' })

vim.keymap.set({ 'i', 'c', },     'vm',      '<esc><esc>', { desc = 'esc' })
vim.keymap.set({ 'i', 'c', },     'vM',      '<esc><esc>', { desc = 'esc' })
vim.keymap.set({ 'i', 'c', },     'Vm',      '<esc><esc>', { desc = 'esc' })
vim.keymap.set({ 'i', 'c', },     'VM',      '<esc><esc>', { desc = 'esc' })

vim.keymap.set({ 't', },          'vm',      '<c-\\><c-n>', { desc = 'esc' })
vim.keymap.set({ 't', },          'vM',      '<c-\\><c-n>', { desc = 'esc' })
vim.keymap.set({ 't', },          'Vm',      '<c-\\><c-n>', { desc = 'esc' })
vim.keymap.set({ 't', },          'VM',      '<c-\\><c-n>', { desc = 'esc' })

vim.keymap.set({ 't', },          '<esc>',   '<c-\\><c-n>', { desc = 'esc' })

-- new line

vim.keymap.set({ 'i', },          'vo',      '<esc>o', { desc = 'new line' })
vim.keymap.set({ 'i', },          'Vo',      '<esc>o', { desc = 'new line' })
vim.keymap.set({ 'i', },          'vO',      '<esc>o', { desc = 'new line' })
vim.keymap.set({ 'i', },          'VO',      '<esc>o', { desc = 'new line' })

-- enter

vim.keymap.set({ 't', 'c', },     'vo',      '<cr>', { desc = 'enter' })
vim.keymap.set({ 't', 'c', },     'Vo',      '<cr>', { desc = 'enter' })
vim.keymap.set({ 't', 'c', },     'vO',      '<cr>', { desc = 'enter' })
vim.keymap.set({ 't', 'c', },     'VO',      '<cr>', { desc = 'enter' })
