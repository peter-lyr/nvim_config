package.loaded['yank'] = nil

local M = {}

M.notify = function(info)
  vim.notify(info, 'info', {
    animate = false,
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
      vim.api.nvim_win_set_option(win, 'concealcursor', 'nvic')
    end,
    timeout = 1000 * 8,
  })
end

M.fname = function()
  vim.cmd 'let @+ = expand("%:t")'
  M.notify(vim.fn.expand '%:t')
end

M.absfname = function()
  vim.cmd 'let @+ = substitute(nvim_buf_get_name(0), "/", "\\\\", "g")'
  M.notify(vim.fn.substitute(vim.api.nvim_buf_get_name(0), '/', '\\\\', 'g'))
end

M.cwd = function()
  vim.cmd 'let @+ = substitute(getcwd(), "/", "\\\\", "g")'
  M.notify(vim.fn.substitute(vim.loop.cwd(), '/', '\\\\', 'g'))
end

return M
