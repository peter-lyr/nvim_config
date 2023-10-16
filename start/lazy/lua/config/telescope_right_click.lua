local M = {}

package.loaded['config.telescope_right_click'] = nil

M.menu_popup_way = 'nvim_open_win' -- nvim_open_win, ui_select

M.commands = {}

--------------------------
-- define menu popup way of nvim_open_win
--------------------------

M.winid = 0
M.line = 0
M.bufnr = 0

M.buf_options = {
  filetype = 'markdown',
  buftype = 'nofile',
  modifiable = false,
}

M.win_options = {
  signcolumn = 'no',
  winblend = 10,
  concealcursor = 'nvic',
  number = true,
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

M.run_at = function(index)
  M.line = index
  local func = M.commands[index]
  if func then
    func()
  end
end

M.run_command = function()
  local line = vim.fn.line '.'
  M.close()
  M.run_at(line)
end

M.popup_menu = function(items)
  M.commands = {}
  M.bufnr = vim.api.nvim_create_buf(false, true)
  local cword = vim.fn.expand '<cword>'
  local win_width = vim.fn.strdisplaywidth(cword)
  local win_height = #vim.tbl_keys(items)
  local menus = {}
  for i, v in ipairs(items) do
    menus[#menus + 1] = string.format('%s', v[1])
    M.commands[#M.commands + 1] = v[2]
    if vim.fn.strdisplaywidth(v[1]) > win_width then
      win_width = vim.fn.strdisplaywidth(v[1])
    end
  end
  win_width = win_width + #tostring(#menus)
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
    return { buffer = M.bufnr, desc = desc, nowait = true, }
  end
  vim.cmd(string.format('norm %dgg', M.line))
  vim.keymap.set({ 'n', 'v', }, '<2-LeftMouse>', M.run_command, map_opt 'run command')
  vim.keymap.set({ 'n', 'v', }, '<cr>', M.run_command, map_opt 'run command')
  vim.keymap.set({ 'n', 'v', }, '<leader>', M.run_command, map_opt 'run command')
  vim.keymap.set({ 'n', 'v', }, '<tab>', M.run_command, map_opt 'run command')
  vim.keymap.set({ 'n', 'v', }, '<c-m>', M.run_command, map_opt 'run command')
  vim.keymap.set({ 'n', 'v', }, '`', M.close, map_opt 'esc')
  vim.keymap.set({ 'n', 'v', }, '<esc>', M.close, map_opt 'esc')
  vim.keymap.set({ 'n', 'v', }, 'q', M.close, map_opt 'esc')
  vim.api.nvim_create_autocmd({ 'BufLeave', }, {
    callback = M.close,
    once = true,
  })
end

require 'telescope'.load_extension 'ui-select'

M.ui_select_menu = function(items)
  local temp = {}
  for _, v in ipairs(items) do
    temp[#temp + 1] = v[1]
    M.commands[#M.commands + 1] = v[2]
  end
  vim.ui.select(temp, { prompt = 'menu ui_select', }, function(choice, idx)
    if not choice then
      return
    end
    M.run_at(idx)
  end)
end

--------------------------
-- define right click menu
--------------------------

M.toggle_menu_popup_way = function()
  if M.menu_popup_way == 'nvim_open_win' then
    M.menu_popup_way = 'ui_select'
  else
    M.menu_popup_way = 'nvim_open_win'
  end
end

M.copy_all_to_system_clipboard = function()
  local save_cursor = vim.fn.getpos '.'
  vim.cmd [[call feedkeys("ggVG\"+y")]]
  vim.fn.timer_start(10, function()
    pcall(vim.fn.setpos, '.', save_cursor)
    vim.cmd 'norm zz'
  end)
end

M.copy_paragraph_to_system_clipboard = function()
  local save_cursor = vim.fn.getpos '.'
  vim.cmd [[call feedkeys("vip\"+y")]]
  vim.fn.timer_start(10, function()
    pcall(vim.fn.setpos, '.', save_cursor)
    vim.cmd 'norm zz'
  end)
end

M.quit_all = function()
  vim.cmd 'qa!'
end

M.refresh = function()
  vim.cmd 'e!'
end

------------
-- nvim-tree
------------

M.nvim_tree_open = function()
  vim.cmd 'NvimTreeOpen'
end

M.nvim_tree_close = function()
  vim.cmd 'NvimTreeClose'
end

M.nvim_tree_find_file = function()
  vim.cmd 'NvimTreeFindFile'
end

------------
-- fugitive
------------

M.fugitive_open = function()
  vim.cmd 'Git'
end

------------
-- spectre
------------

M.spectre_open_visual = function()
  require 'spectre'.open_visual { select_word = true, }
end

M.spectre_open_file_search = function()
  require 'spectre'.open_file_search { select_word = true, }
end

------------
-- aerial
------------

M.aerial_open = function()
  vim.cmd 'AerialOpen right'
end

M.aerial_close = function()
  vim.cmd 'AerialCloseAll'
end

------------
-- minimap
------------

M.minimap_open = function()
  require 'config.minimap'.open()
end

M.minimap_close = function()
  require 'config.minimap'.close()
end

------------
-- others
------------

M.monitor_1min = function()
  vim.fn.system 'powercfg -x -monitor-timeout-ac 1'
  print 'monitor_1min'
end

M.monitor_30min = function()
  vim.fn.system 'powercfg -x -monitor-timeout-ac 30'
  print 'monitor_30min'
end

M.proxy_on = function()
  vim.fn.system [[reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f]]
  print 'proxy_on'
end

M.proxy_off = function()
  vim.fn.system [[reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f]]
  print 'proxy_off'
end

M.path = function()
  vim.fn.system 'rundll32 sysdm.cpl,EditEnvironmentVariables'
end

M.sound = function()
  vim.fn.system 'mmsys.cpl'
end

M.items = {
  { 'toggle [Menu Popup Way]',              M.toggle_menu_popup_way, },
  { '[Aerial] open right',                  M.aerial_open, },
  { '[Aerial] close',                       M.aerial_close, },
  { '[Minimap] open',                       M.minimap_open, },
  { '[Minimap] close',                      M.minimap_close, },
  { '[Fugitive] open',                      M.fugitive_open, },
  { '[Nvim-Tree] find file',                M.nvim_tree_find_file, },
  { '[Nvim-Tree] open',                     M.nvim_tree_open, },
  { '[Nvim-Tree] close',                    M.nvim_tree_close, },
  { '[Spectre] open cword cfile',           M.spectre_open_file_search, },
  { '[Spectre] open cword cwd',             M.spectre_open_visual, },
  { '[Refresh]',                            M.refresh, },
  { '[Copy] all to system clipboard',       M.copy_all_to_system_clipboard, },
  { '[Copy] paragraph to system clipboard', M.copy_paragraph_to_system_clipboard, },
  { '[Monitor] timeout 1 min',              M.monitor_1min, },
  { '[Monitor] timeout 30 min',             M.monitor_30min, },
  { '[Proxy] on',                           M.proxy_on, },
  { '[Proxy] off',                          M.proxy_off, },
  { '[Path] open',                          M.path, },
  { '[Quit All]',                           M.quit_all, },
}

M.right_click_menu = function()
  vim.cmd [[call feedkeys("\<LeftMouse>")]]
  if M.menu_popup_way == 'nvim_open_win' then
    vim.fn.timer_start(10, function()
      M.popup_menu(M.items)
    end)
  elseif M.menu_popup_way == 'ui_select' then
    vim.fn.timer_start(10, function()
      M.ui_select_menu(M.items)
    end)
  end
end

RClick = M.right_click_menu

M.right_click = function()
  if vim.fn.getmousepos()['line'] == 0 then
    return '<RightMouse>'
  end
  return ':<c-u>call v:lua.RClick()<cr>'
end

vim.keymap.set({ 'n', 'v', }, '<RightMouse>', M.right_click, { desc = '<RightMouse>', expr = true, })
vim.keymap.set({ 'n', 'v', }, '<leader>`', M.right_click, { desc = '<RightMouse>', expr = true, })

return M
