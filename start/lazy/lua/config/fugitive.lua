require 'maps'.add('<F5>', 'n', function()
  pcall(vim.call, 'fugitive#ReloadStatus')
end, 'futigive status fresh')

local M = {}

M.toggle = function()
  if vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'filetype') == 'fugitive' then
    vim.cmd 'close'
  else
    vim.cmd 'Git'
  end
end

pcall(vim.api.nvim_del_autocmd, vim.g.fugitive_au_focusgained)

vim.g.fugitive_au_focusgained = vim.api.nvim_create_autocmd({ 'FocusGained', }, {
  callback = function(ev)
    if vim.bo.ft == 'fugitive' then
      pcall(vim.call, 'fugitive#ReloadStatus')
    end
  end,
})

local function feed(key)
  vim.cmd(string.format([[call feedkeys("%s")]], key))
end

pcall(vim.api.nvim_del_autocmd, vim.g.fugitive_au_bufenter)

vim.g.fugitive_au_bufenter = vim.api.nvim_create_autocmd({ 'BufEnter', }, {
  callback = function(ev)
    if vim.bo.ft == 'fugitive' then
      vim.keymap.set({ 'n', 'v', }, 'dd', function() feed 'X' end, { desc = 'X', buffer = ev.buf, })
    end
  end,
})

return M
