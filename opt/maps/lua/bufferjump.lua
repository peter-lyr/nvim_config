local M = {}

package.loaded['bufferjump'] = nil

M.max_en = 0
M.winid = 0

M.check = function()
  if M.max_en then
    if vim.opt.winfixheight:get() == false then
      vim.cmd 'wincmd _'
      if M.winid ~= vim.fn.win_getid() then
        vim.api.nvim_win_set_height(M.winid, 2)
      end
    end
  end
end

M.k = function()
  M.winid = vim.fn.win_getid()
  vim.cmd 'wincmd k'
  M.check()
end

M.j = function()
  M.winid = vim.fn.win_getid()
  vim.cmd 'wincmd j'
  M.check()
end

M.wp = function()
  local count = vim.v.count
  local max = vim.fn.winnr '$'
  if count == 0 then
    local winnr = vim.fn.winnr() - 1
    if winnr < 1 then
      winnr = max
    end
    vim.fn.win_gotoid(vim.fn.win_getid(winnr))
  else
    if count < 1 then
      count = 1
    else
      if count > max then
        count = max
      end
      vim.fn.win_gotoid(vim.fn.win_getid(count))
    end
  end
end

M.wn = function()
  local count = vim.v.count
  local max = vim.fn.winnr '$'
  if count == 0 then
    local winnr = vim.fn.winnr() + 1
    if winnr > max then
      winnr = 1
    end
    vim.fn.win_gotoid(vim.fn.win_getid(winnr))
  else
    if count < 1 then
      count = 1
    else
      if count > max then
        count = max
      end
      vim.fn.win_gotoid(vim.fn.win_getid(count))
    end
  end
end

M.main = function()
  for winnr = 1, vim.fn.winnr '$' do
    local bufnr = vim.fn.winbufnr(winnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if vim.fn.filereadable(fname) == 1 then
      local winid = vim.fn.win_getid(winnr)
      vim.fn.win_gotoid(winid)
      break
    end
  end
end

M.oo = function()
  M.max_en = 1
  print 'win height auto max enabled'
end

M.ii = function()
  M.max_en = nil
  print 'win height auto max disabled'
end

M.i = function()
  vim.cmd 'wincmd ='
  if vim.opt.winfixheight:get() == true then
    vim.cmd [[
      set nowinfixheight
      wincmd =
      set winfixheight
    ]]
  end
end

local gotoid = function(winid)
  if vim.api.nvim_win_get_height(winid) < 2 then
    vim.api.nvim_win_set_height(winid, 2)
  end
  vim.fn.win_gotoid(winid)
end

local isallow = function(winnr)
  local bufnr = vim.fn.winbufnr(winnr)
  if vim.api.nvim_buf_is_valid(bufnr) then
    local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    if vim.tbl_contains({ 'NvimTree', 'fugitive', 'minimap', 'aerial', 'edgy', }, ft) == true then
      return nil
    end
  end
  return 1
end

M.ix = function(x)
  local winid = vim.fn.win_getid()
  if x == 9 then
    for winnr = 1, vim.fn.winnr '$' do
      gotoid(vim.fn.win_getid(winnr))
      if vim.opt.winfixheight:get() == true then
        vim.cmd [[
          set nowinfixheight
          wincmd =
          set winfixheight
          ]]
      elseif vim.opt.winfixwidth:get() == true then
        vim.cmd [[
          set nowinfixwidth
          wincmd =
          set winfixwidth
          ]]
      end
    end
  elseif x == 10 then
    for winnr = 1, vim.fn.winnr '$' do
      gotoid(vim.fn.win_getid(winnr))
      vim.cmd [[
        set nowinfixheight
        set nowinfixwidth
        ]]
    end
    vim.cmd 'wincmd ='
  elseif x == 11 then
    for winnr = vim.fn.winnr() - 1, 1, -1 do
      if isallow(winnr) then
        local cur_winid = vim.fn.win_getid(winnr)
        if vim.api.nvim_get_option_value('winfixheight', { win = cur_winid, scope = 'global', }) == true
            or vim.api.nvim_get_option_value('winfixwidth', { win = cur_winid, scope = 'global', }) == true then
          gotoid(vim.fn.win_getid(winnr))
          return
        end
      end
    end
    return
  elseif x == 12 then
    for winnr = vim.fn.winnr() + 1, vim.fn.winnr '$' do
      if isallow(winnr) then
        local cur_winid = vim.fn.win_getid(winnr)
        if vim.api.nvim_get_option_value('winfixheight', { win = cur_winid, scope = 'global', }) == true
            or vim.api.nvim_get_option_value('winfixwidth', { win = cur_winid, scope = 'global', }) == true then
          gotoid(cur_winid)
          return
        end
      end
    end
    return
  else
    for winnr = 1, vim.fn.winnr '$' do
      if isallow(winnr) then
        local cur_winid = vim.fn.win_getid(winnr)
        if vim.api.nvim_get_option_value('winfixheight', { win = cur_winid, scope = 'global', }) == true then
          vim.api.nvim_win_set_height(cur_winid, x * 7)
        end
        if vim.api.nvim_get_option_value('winfixwidth', { win = cur_winid, scope = 'global', }) == true then
          gotoid(cur_winid)
          vim.cmd 'wincmd h'
          vim.api.nvim_win_set_width(0, vim.api.nvim_win_get_width(0) - x * 20 + vim.api.nvim_win_get_width(cur_winid))
        end
      end
    end
  end
  gotoid(winid)
end

M.hh = function()
  vim.cmd 'set nowinfixwidth'
  print 'set nowinfixwidth'
end

M.ll = function()
  vim.cmd 'set winfixwidth'
  print 'set winfixwidth'
end

M.kk = function()
  vim.cmd 'set winfixheight'
  print 'set winfixheight'
end

M.jj = function()
  vim.cmd 'set nowinfixheight'
  print 'set nowinfixheight'
end

local hjkl_en = 0

M.hjkl_toggle = function()
  if hjkl_en == 0 then
    vim.keymap.set({ 'n', 'v', }, '1', 'h', { desc = 'h', })
    vim.keymap.set({ 'n', 'v', }, '2', 'j', { desc = 'j', })
    vim.keymap.set({ 'n', 'v', }, '3', 'k', { desc = 'k', })
    vim.keymap.set({ 'n', 'v', }, '4', 'l', { desc = 'l', })
    hjkl_en = 1
  else
    vim.keymap.del({ 'n', 'v', }, '1')
    vim.keymap.del({ 'n', 'v', }, '2')
    vim.keymap.del({ 'n', 'v', }, '3')
    vim.keymap.del({ 'n', 'v', }, '4')
    hjkl_en = 0
  end
  print('hjkl_en: ' .. hjkl_en)
end

return M
