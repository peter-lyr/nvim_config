local M = {}

M.height_more = function()
  vim.cmd '10wincmd >'
end

M.height_less = function()
  vim.cmd '10wincmd <'
end

M.width_more = function()
  vim.cmd '5wincmd +'
end

M.width_less = function()
  vim.cmd '5wincmd -'
end

M.copy_tab = function()
  vim.cmd 'wincmd s'
  vim.cmd 'wincmd T'
end

M.copy_up = function()
  vim.cmd 'leftabove split'
end

M.copy_down = function()
  vim.cmd 'split'
end

M.copy_right = function()
  vim.cmd 'vsplit'
end

M.copy_left = function()
  vim.cmd 'leftabove vsplit'
end

M.new_tab = function()
  vim.cmd 'tabnew'
end

M.new_up = function()
  vim.cmd 'leftabove new'
end

M.new_down = function()
  vim.cmd 'new'
end

M.new_right = function()
  vim.cmd 'vnew'
end

M.new_left = function()
  vim.cmd 'leftabove vnew'
end

M.close_win_up = function()
  local winid = vim.fn.win_getid()
  vim.cmd('wincmd k')
  if winid ~= vim.fn.win_getid() then
    vim.cmd [[
      try
        close
      catch
      endtry
    ]]
    vim.fn.win_gotoid(winid)
  end
end

M.close_win_down = function()
  local winid = vim.fn.win_getid()
  vim.cmd('wincmd j')
  if winid ~= vim.fn.win_getid() then
    vim.cmd [[
      try
        close
      catch
      endtry
    ]]
    vim.fn.win_gotoid(winid)
  end
end

M.close_win_right = function()
  local winid = vim.fn.win_getid()
  vim.cmd('wincmd l')
  if winid ~= vim.fn.win_getid() then
    vim.cmd [[
      try
        close
      catch
      endtry
    ]]
    vim.fn.win_gotoid(winid)
  end
end

M.close_win_left = function()
  local winid = vim.fn.win_getid()
  vim.cmd('wincmd h')
  if winid ~= vim.fn.win_getid() then
    vim.cmd [[
      try
        close
      catch
      endtry
    ]]
    vim.fn.win_gotoid(winid)
  end
end

M.close_cur = function()
  vim.cmd [[
    try
      close!
    catch
    endtry
  ]]
end

M.bdelete_cur = function()
  vim.cmd [[
    try
      bdelete!
      e!
    catch
    endtry
  ]]
end

M.bwipeout_cur = function()
  vim.cmd [[
    try
      bw!
    catch
    endtry
  ]]
end

M.close_cur_tab = function()
  vim.cmd [[
    try
      tabclose!
    catch
    endtry
  ]]
end

local function rep(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '\\', '/')
  return content
end

M.bwipeout_cur_proj = function()
  local curroot = rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if curroot == rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(b))) then
      pcall(vim.cmd, 'bw! ' .. tostring(b))
    end
  end
end

M.bdelete_cur_proj = function()
  local curroot = rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if curroot == rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(b))) then
      pcall(vim.cmd, 'bdelete! ' .. tostring(b))
    end
  end
end

return M
