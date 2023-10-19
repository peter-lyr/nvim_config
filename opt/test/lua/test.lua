vim.keymap.set({ 'n', 'v', }, '<c-del>', function()
  print(string.format('[%s]{%s}', vim.fn.mode(), vim.fn.visualmode()))
end, { desc = 'test', })
