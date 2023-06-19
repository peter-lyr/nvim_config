-- sometimes mouse not working

vim.api.nvim_create_autocmd({ "BufEnter", }, {
  callback = function()
    vim.opt.mouse = 'a'
  end,
})

-- tab space

local tab_4_lang = {
  'c', 'cpp',
  'python',
  'ld',
}

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    if vim.tbl_contains(tab_4_lang, vim.opt.filetype:get()) == true then
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
    else
      vim.opt.tabstop = 2
      vim.opt.softtabstop = 2
      vim.opt.shiftwidth = 2
    end
  end,
})
