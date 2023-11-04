local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.load_require_common()

-------------

vim.fn.setreg('e', 'reg e empty')

vim.g.single_quote = ''  -- ''
vim.g.double_quote = ''  -- ""
vim.g.back_quote = ''    -- ``
vim.g.parentheses = ''   -- ()
vim.g.bracket = ''       -- []
vim.g.brace = ''         -- {}
vim.g.angle_bracket = '' -- <>

B.aucmd(M.source, 'BufLeave', { 'BufLeave', 'CmdlineEnter', }, {
  callback = function()
    local word = vim.fn.expand '<cword>'
    if #word > 0 then
      vim.fn.setreg('e', word)
    end
    if B.is_buf_ft { 'NvimTree', } then
      return
    end
    local bak = vim.fn.getreg '"'
    local save_cursor = vim.fn.getpos '.'
    vim.cmd "norm yi'"
    vim.g.single_quote = vim.fn.getreg '"'
    pcall(vim.fn.setpos, '.', save_cursor)
    vim.cmd 'norm yi"'
    vim.g.double_quote = vim.fn.getreg '"'
    pcall(vim.fn.setpos, '.', save_cursor)
    vim.cmd 'norm yi`'
    vim.g.back_quote = vim.fn.getreg '"'
    pcall(vim.fn.setpos, '.', save_cursor)
    vim.cmd 'norm yi)'
    vim.g.parentheses = vim.fn.getreg '"'
    pcall(vim.fn.setpos, '.', save_cursor)
    vim.cmd 'norm yi]'
    vim.g.bracket = vim.fn.getreg '"'
    pcall(vim.fn.setpos, '.', save_cursor)
    vim.cmd 'norm yi}'
    vim.g.brace = vim.fn.getreg '"'
    pcall(vim.fn.setpos, '.', save_cursor)
    vim.cmd 'norm yi>'
    vim.g.angle_bracket = vim.fn.getreg '"'
    pcall(vim.fn.setpos, '.', save_cursor)
    vim.fn.setreg('"', bak)
  end,
})

--------------------

-- B.map_set_lua(M.loaded .. '_' .. 'funcs')
--
-- B.map_set_opts { mode = { 'c', 'i', }, }

vim.keymap.set({ 'c', 'i', }, '<c-e>', '<c-r>e', { desc = 'paste <cword>', })

vim.keymap.set({ 'c', 'i', }, '<c-q>', '<c-r>=expand("%:t")<cr>', { desc = 'paste %:t', })
vim.keymap.set({ 'c', 'i', }, '<c-|>', '<c-r>=nvim_buf_get_name(0)<cr>', { desc = 'paste nvim_buf_get_name', })

vim.keymap.set({ 'c', 'i', }, '<c-1>', '<c-r>=bufname()<cr>', { desc = 'paste bufname', })
vim.keymap.set({ 'c', 'i', }, '<c-2>', '<c-r>=getcwd()<cr>', { desc = 'paste cwd', })

vim.keymap.set({ 'c', 'i', }, '<c-l>', '<c-r>=getline(".")<cr>', { desc = 'paste cur line', })

vim.keymap.set({ 'c', 't', }, "<c-'>", '<c-r>=g:single_quote<cr>', { desc = "<c-'>", })
vim.keymap.set({ 'c', 't', }, "<c-s-'>", '<c-r>=g:double_quote<cr>', { desc = '<c-">', })
vim.keymap.set({ 'c', 't', }, '<c-0>', '<c-r>=g:parentheses<cr>', { desc = '<c-)>', })
vim.keymap.set({ 'c', 't', }, '<c-]>', '<c-r>=g:bracket<cr>', { desc = '<c-]>', })
vim.keymap.set({ 'c', 't', }, '<c-s-]>', '<c-r>=g:brace<cr>', { desc = '<c-}>', })
vim.keymap.set({ 'c', 't', }, '<c-`>', '<c-r>=g:back_quote<cr>', { desc = '<c-`>', })
vim.keymap.set({ 'c', 't', }, '<c-s-.>', '<c-r>=g:angle_bracket<cr>', { desc = '<c->>', })

vim.keymap.set({ 'c', 'i', }, '<c-tab>', '<c-r>+', { desc = 'paste +', })

vim.keymap.set({ 'c', 'i', }, '<c-s>', '<c-r>"', { desc = 'paste "', })
vim.keymap.set({ 't', }, '<c-s>', '<c-\\><c-n>pi', { desc = 'paste "', })

vim.keymap.set({ 'c', 'i', }, '<c-v>', '<c-r>+', { desc = 'paste +', })
vim.keymap.set({ 't', }, '<c-v>', '<c-\\><c-n>"+pi', { desc = 'paste +', })

-- cursor

vim.keymap.set({ 'n', 'v', }, 'k', "(v:count == 0 && &wrap) ? 'gk' : 'k'", { expr = true, silent = true, })
vim.keymap.set({ 'n', 'v', }, 'j', "(v:count == 0 && &wrap) ? 'gj' : 'j'", { expr = true, silent = true, })


vim.keymap.set({ 't', 'c', 'i', }, '<a-k>', '<UP>', { desc = 'up', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-j>', '<DOWN>', { desc = 'down', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-k>', '<UP><UP><UP><UP><UP>', { desc = '5 up', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-j>', '<DOWN><DOWN><DOWN><DOWN><DOWN>', { desc = '5 down', })

vim.keymap.set({ 't', 'c', 'i', }, '<a-i>', '<HOME>', { desc = 'home', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-i>', '<HOME>', { desc = 'home', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-o>', '<END>', { desc = 'end', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-o>', '<END>', { desc = 'end', })

vim.keymap.set({ 't', 'c', 'i', }, '<a-l>', '<RIGHT>', { desc = 'right', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-h>', '<LEFT>', { desc = 'left', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-l>', '<c-RIGHT>', { desc = 'ctrl right', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-h>', '<c-LEFT>', { desc = 'ctrl left', })


vim.keymap.set({ 't', 'c', 'i', }, '<a-w>', '<UP>', { desc = 'up', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s>', '<DOWN>', { desc = 'down', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-w>', '<UP><UP><UP><UP><UP>', { desc = '5 up', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-s>', '<DOWN><DOWN><DOWN><DOWN><DOWN>', { desc = '5 down', })

vim.keymap.set({ 't', 'c', 'i', }, '<a-q>', '<HOME>', { desc = 'home', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-q>', '<HOME>', { desc = 'home', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-e>', '<END>', { desc = 'end', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-e>', '<END>', { desc = 'end', })

vim.keymap.set({ 't', 'c', 'i', }, '<a-d>', '<RIGHT>', { desc = 'right', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-a>', '<LEFT>', { desc = 'left', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-d>', '<c-RIGHT>', { desc = 'ctrl right', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-a>', '<c-LEFT>', { desc = 'ctrl left', })

vim.keymap.set({ 'n', 'v', }, '<c-f11>', 'gf', { desc = 'gf', })

-- esc

vim.keymap.set({ 't', }, '<esc>', '<c-\\><c-n>', { desc = 'esc', })

-- zh 2 en

-- vim.keymap.set({ 't', 'c', 'i', }, '·', '`', { desc = '`', })

-- B.map_reset_opts()

return M
