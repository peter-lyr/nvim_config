local M = {}

M.open = function()
  local fname = vim.api.nvim_buf_get_name(vim.fn.bufnr())
  if vim.fn.filereadable(fname) == 1 then
    vim.cmd 'wincmd v'
    vim.cmd 'wincmd J'
    vim.cmd 'copen'
    vim.cmd 'wincmd k'
    vim.cmd 'close'
    vim.cmd 'wincmd j'
  else
    print('File not readable, can not open quickfix list')
  end
end

return M
