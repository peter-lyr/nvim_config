local M = {}

package.loaded['drag'] = nil

-- when dragging file(s) to a markdown file

M.is_dragging = true
M.post_cmd = ''
M.last_file = ''

pcall(vim.api.nvim_del_autocmd, vim.g.drag_au_focuslost)

vim.g.drag_au_focuslost = vim.api.nvim_create_autocmd({ 'FocusLost', }, {
  callback = function()
    vim.schedule(function()
      M.is_dragging = true
    end)
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.drag_au_bufreadpre)

vim.g.drag_au_bufreadpre = vim.api.nvim_create_autocmd({ 'BufReadPre', }, {
  callback = function(ev)
    vim.schedule(function()
      if M.is_dragging == true then
        M.post_cmd = require 'drag_images'.check(ev.buf)
        if #M.post_cmd == 0 then
          M.post_cmd = require 'drag_bin'.check(ev.buf)
        end
      end
    end)
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.drag_au_bufreadpost)

vim.g.drag_au_bufreadpost = vim.api.nvim_create_autocmd({ 'BufReadPost', }, {
  callback = function()
    vim.schedule(function()
      if #M.post_cmd > 0 then
        pcall(vim.cmd, M.post_cmd)
      end
      M.post_cmd = ''
    end)
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.drag_au_bufenter)

vim.g.drag_au_bufenter = vim.api.nvim_create_autocmd({ 'BufEnter', }, {
  callback = function(ev)
    vim.schedule(function()
      M.last_file = ev.file
    end)
  end,
})

return M
