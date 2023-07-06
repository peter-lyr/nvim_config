vim.keymap.set({ 'n', 'v', }, '<f9>', function()
  local ch = vim.fn.getcharstr()
  print('|', string.byte(ch, 1), '|', string.byte(ch, 2), '|', string.byte(ch, 3), '|', string.byte(ch, 4), '|', ch, '|')
end, { desc = 'test <c-e>', nowait = true })
