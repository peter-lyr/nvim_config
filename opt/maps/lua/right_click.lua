M = {}

package.loaded['right_click'] = nil

M.commands = {}
M.winid = 0
M.bufnr = 0

M.buf_options = {
  filetype = 'menu',
  buftype = 'nofile',
  modifiable = false,
}

M.win_options = {
  signcolumn = 'no',
  number = true,
  -- winblend = 10,
}

M.win_open_opts = {
  relative = 'cursor',
  title = 'menu',
  border = 'rounded',
  row = 1,
  col = 0,
  style = 'minimal',
}

M.close = function()
  vim.api.nvim_win_close(M.winid, true)
end

M.run_command = function()
  local line = vim.fn.line '.'
  M.close()
  local func = M.commands[line]
  if func then
    func()
  end
end

M.popup_menu = function(items)
  M.commands = {}
  M.bufnr = vim.api.nvim_create_buf(false, true)
  local cword = vim.fn.expand '<cword>'
  local win_width = vim.fn.strdisplaywidth(cword)
  local win_height = #vim.tbl_keys(items)
  local menus = {}
  for _, v in ipairs(items) do
    menus[#menus + 1] = v[1]
    M.commands[#M.commands + 1] = v[2]
    if vim.fn.strdisplaywidth(v[1]) > win_width then
      win_width = vim.fn.strdisplaywidth(v[1])
    end
  end
  win_width = win_width + 2 + vim.opt.numberwidth:get()
  vim.api.nvim_buf_set_lines(M.bufnr, 0, -1, true, menus)
  M.winid = vim.api.nvim_open_win(M.bufnr, true,
    vim.tbl_deep_extend('force', M.win_open_opts, {
      width = win_width,
      height = win_height,
      title = cword,
    }))
  for k, v in pairs(M.buf_options) do
    vim.api.nvim_buf_set_option(M.bufnr, k, v)
  end
  for k, v in pairs(M.win_options) do
    vim.api.nvim_win_set_option(M.winid, k, v)
  end
  local map_opt = function(desc)
    return { buffer = M.bufnr, desc = desc, }
  end
  vim.keymap.set({ 'n', 'v', }, '<2-LeftMouse>', M.run_command, map_opt 'run command')
  vim.keymap.set({ 'n', 'v', }, '<cr>', M.run_command, map_opt 'run command')
  vim.keymap.set({ 'n', 'v', }, '<esc>', M.close, map_opt 'esc')
  vim.api.nvim_create_autocmd({ 'BufLeave', }, {
    callback = M.close,
    once = true,
  })
end

M.select_all = function()
  vim.cmd [[call feedkeys("ggVG")]]
end

M.copy_all = function()
  local save_cursor = vim.fn.getpos '.'
  vim.cmd [[call feedkeys("ggVG\"+y")]]
  vim.fn.timer_start(10, function()
    pcall(vim.fn.setpos, '.', save_cursor)
    vim.cmd 'norm zz'
  end)
end

local items = {
  { 'select all', M.select_all, },
  { 'copy all',   M.copy_all, },
}

M.right_click = function()
  vim.cmd [[call feedkeys("\<LeftMouse>")]]
  vim.fn.timer_start(10, function()
    M.popup_menu(items)
  end)
end

return M
