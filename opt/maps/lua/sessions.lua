local M = {}

package.loaded['sessions'] = nil

M.sessions_dir_p = require 'plenary.path':new(vim.fn.stdpath 'data'):joinpath 'sessions'
M.sessions_txt_p = M.sessions_dir_p:joinpath 'sessions.txt'

if not M.sessions_dir_p:exists() then
  vim.fn.mkdir(M.sessions_dir_p.filename)
end

M.load = function()
  local lines = M.sessions_txt_p:readlines()
  for _, line in ipairs(lines) do
    local fname = vim.fn.trim(line)
    if #fname > 0 and vim.fn.filereadable(fname) then
      vim.cmd('edit ' .. fname)
    end
  end
end

vim.api.nvim_create_autocmd({ 'VimLeave', }, {
  callback = function()
    local fnames = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) == true and vim.api.nvim_buf_is_valid(buf) == true then
        fnames[#fnames + 1] = vim.api.nvim_buf_get_name(buf)
      end
    end
    M.sessions_txt_p:write(vim.fn.join(fnames, '\n'), 'w')
  end,
})

return M
