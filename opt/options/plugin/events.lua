-- sometimes mouse not working
vim.api.nvim_create_autocmd({ "BufEnter", }, {
  callback = function()
    vim.opt.mouse = 'a'
  end,
})
