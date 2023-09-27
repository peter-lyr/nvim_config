local M = {}

package.loaded['change_dir'] = nil

M.cur = function()
  local dir = vim.fn.expand '%:p:h'
  if #dir == 0 then
    return
  end
  vim.cmd(string.format('cd %s|cd %s', string.sub(dir, 1, 2), dir))
  require 'notify'.dismiss()
  vim.notify(vim.loop.cwd(), 'info', {
    animate = false,
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
      vim.api.nvim_win_set_option(win, 'concealcursor', 'nvic')
    end,
  })
end

M.up = function()
  local dir = vim.fn.expand '%:p:h'
  if #dir == 0 then
    return
  end
  vim.cmd 'cd ..'
  require 'notify'.dismiss()
  vim.notify(vim.loop.cwd(), 'info', {
    animate = false,
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
      vim.api.nvim_win_set_option(win, 'concealcursor', 'nvic')
    end,
  })
end

M.cwd = function()
  local dir = vim.fn.expand '%:p:h'
  if #dir == 0 then
    return
  end
  pcall(vim.cmd, 'ProjectRootCD')
  require 'notify'.dismiss()
  vim.notify(vim.loop.cwd(), 'info', {
    animate = false,
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
      vim.api.nvim_win_set_option(win, 'concealcursor', 'nvic')
    end,
  })
end

return M
