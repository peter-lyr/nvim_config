local M = {}

package.loaded['sessions'] = nil

M.sessions_dir_p = require 'plenary.path':new(vim.fn.stdpath 'data'):joinpath 'sessions'
M.sessions_txt_p = M.sessions_dir_p:joinpath 'sessions.txt'

if not M.sessions_dir_p:exists() then
  vim.fn.mkdir(M.sessions_dir_p.filename)
end

M.sel = function()
  local lines = M.sessions_txt_p:readlines()
  local fnames = {}
  for _, line in ipairs(lines) do
    local fname = vim.fn.trim(line)
    if #fname > 0 and require 'plenary.path':new(fname):exists() then
      fnames[#fnames + 1] = fname
    end
  end
  vim.ui.select(fnames, { prompt = 'sessions sel open', }, function(choice, idx)
    if not choice then
      return
    end
    vim.cmd('edit ' .. choice)
  end)
end

M.load = function()
  local lines = M.sessions_txt_p:readlines()
  for _, line in ipairs(lines) do
    local fname = vim.fn.trim(line)
    if #fname > 0 and require 'plenary.path':new(fname):exists() then
      vim.cmd('edit ' .. fname)
    end
  end
end

vim.api.nvim_create_autocmd({ 'VimLeavePre', }, {
  callback = function()
    local fnames = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) == true and vim.api.nvim_buf_is_valid(buf) == true then
        local fname = vim.api.nvim_buf_get_name(buf)
        if #fname > 0 and require 'plenary.path':new(fname):exists() then
          fnames[#fnames + 1] = fname
        end
      end
    end
    M.sessions_txt_p:write(vim.fn.join(fnames, '\n'), 'w')
  end,
})

vim.keymap.set({ 'n', 'v', }, '<leader>s<cr>', function() M.load() end, { desc = 'sessions load', })
vim.keymap.set({ 'n', 'v', }, '<leader>s\\', function() M.sel() end, { desc = 'sessions sel open', })

return M
