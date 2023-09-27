package.loaded['yank'] = nil

local M = {}

M.fname = function()
  vim.cmd 'let @+ = expand("%:t")'
  vim.notify(vim.fn.expand '%:t', 'info', {
    animate = false,
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
      vim.api.nvim_win_set_option(win, 'concealcursor', 'nvic')
    end,
    timeout = 1000 * 8,
  })
end

M.absfname = function()
  vim.cmd 'let @+ = substitute(nvim_buf_get_name(0), "/", "\\\\", "g")'
  vim.notify(vim.fn.substitute(vim.api.nvim_buf_get_name(0), '/', '\\\\', 'g'), 'info', {
    animate = false,
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
      vim.api.nvim_win_set_option(win, 'concealcursor', 'nvic')
    end,
    timeout = 1000 * 8,
  })
end

M.cwd = function()
  vim.cmd 'let @+ = substitute(getcwd(), "/", "\\\\", "g")'
  vim.notify(vim.fn.substitute(vim.loop.cwd(), '/', '\\\\', 'g'), 'info', {
    animate = false,
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
      vim.api.nvim_win_set_option(win, 'concealcursor', 'nvic')
    end,
    timeout = 1000 * 8,
  })
end

return M
