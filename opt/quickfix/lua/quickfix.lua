package.loaded['quickfix'] = nil

local M = {}

vim.g.qf_before_winid = -1

M.allow = nil

M.last_en = false
M.lastline = -1
M.lastcol = -1

-- local winheight = -1
-- local winwidth = -1

-- function SaveWinSize()
--   winheight = vim.api.nvim_win_get_height(0)
--   winwidth = vim.api.nvim_win_get_width(0)
-- end

-- function RestoreWinSize()
--   if winheight ~= -1 and winwidth ~= -1 then
--     vim.api.nvim_win_set_height(0, winheight)
--     vim.api.nvim_win_set_width(0, winwidth)
--   end
-- end

local function wait()
  vim.fn.timer_start(10, function()
    if M.lastline ~= -1 and M.lastcol ~= -1 and (vim.fn.line '.' == 1 or vim.fn.col '.' == 1) then
      vim.cmd(string.format('norm %dgg%d|', M.lastline, M.lastcol))
    end
    M.last_en = true
    vim.keymap.set('n', 'q', function()
      vim.schedule(function()
        vim.cmd 'ccl'
        if vim.api.nvim_win_is_valid(vim.g.qf_before_winid) == true then
          vim.fn.win_gotoid(vim.g.qf_before_winid)
          -- RestoreWinSize()
        end
      end)
    end, { buffer = vim.fn.bufnr(), nowait = true, silent = true, })
  end)
end

M.toggle = function()
  if vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'buftype') == 'quickfix' then
    vim.cmd 'ccl'
    if vim.api.nvim_win_is_valid(vim.g.qf_before_winid) == true then
      vim.fn.win_gotoid(vim.g.qf_before_winid)
      -- RestoreWinSize()
    end
  else
    vim.g.qf_before_winid = vim.fn.win_getid()
    -- SaveWinSize()
    vim.cmd 'copen'
    M.allow = nil
    wait()
  end
end

local open = function(ccl)
  vim.cmd 'norm 0'
  local temp = 0
  local cfile = ''
  local line = 0
  local col = 0
  for res in string.gmatch(vim.fn.getline '.', '([^|]+)|') do
    temp = temp + 1
    if temp == 1 then
      cfile = res
    elseif temp == 2 then
      for nr in string.gmatch(res, '(%d+)') do
        if line == 0 then
          line = vim.fn.str2nr(nr)
        elseif col == 0 then
          col = vim.fn.str2nr(nr)
        end
      end
    end
  end
  if vim.fn.filereadable(cfile) == 1 then
    if vim.api.nvim_win_is_valid(vim.g.qf_before_winid) == true then
      vim.fn.win_gotoid(vim.g.qf_before_winid)
      if ccl == 1 then
        vim.cmd 'ccl'
      end
      Buffer(cfile)
      -- local bufferjump = require 'bufferjump'
      if line ~= 0 and col ~= 0 then
        -- bufferjump.ix(bufferjump.x)
        -- vim.cmd 'wincmd ='
        vim.cmd(string.format('norm %dgg%d|', line, col))
      else
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
          pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
      end
    end
  end
end

local function open_ccl()
  open(1)
end

local function nodupl()
  local title = vim.fn.getqflist { title = 0, }.title
  local l = {}
  local L = vim.fn.getqflist()
  local D = {}
  local notempty = 0
  local different = nil
  for _, i in ipairs(L) do
    i.text = vim.fn.trim(i.text)
    if vim.tbl_contains(D, i.text) == false or (#i.text == 0 and notempty == 0) then
      D[#D + 1] = i.text
      l[#l + 1] = i
      if #i.text > 0 then
        notempty = 1
      end
    else
      different = 1
    end
  end
  if different then
    vim.fn.setqflist(l, 'r')
    vim.fn.setqflist({}, 'a', { title = title, })
  end
end

pcall(vim.api.nvim_del_autocmd, vim.g.quickfix_au_bufenter)

vim.g.quickfix_au_bufenter = vim.api.nvim_create_autocmd({ 'BufEnter', }, {
  callback = function(ev)
    local buftype = vim.api.nvim_buf_get_option(ev.buf, 'buftype')
    if buftype == 'quickfix' then
      if string.match(vim.fn.getline(1), 'cbp2make') then
        vim.cmd 'set wrap'
      else
        vim.cmd 'set nowrap'
      end
      vim.keymap.set('n', 'o', open_ccl, { buffer = ev.buf, nowait = true, silent = true, })
      vim.keymap.set('n', 'a', open_ccl, { buffer = ev.buf, nowait = true, silent = true, })
      vim.keymap.set('n', '<2-LeftMouse>', open, { buffer = ev.buf, nowait = true, silent = true, })
      vim.cmd [[
        setlocal scrolloff=0
      ]]
    end
    if vim.tbl_contains({ 'quickfix', 'nofile', }, buftype) == true then
      M.allow = nil
      nodupl()
      wait()
    end
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.quickfix_au_cursormoved)

vim.g.quickfix_au_cursormoved = vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorHold', }, {
  callback = function(ev)
    if vim.api.nvim_buf_get_option(ev.buf, 'buftype') == 'quickfix' and M.last_en == true then
      M.lastline = vim.fn.line '.'
      M.lastcol = vim.fn.col '.'
    else
      M.last_en = false
    end
  end,
})

require 'maps'.add('<esc>', 'n', function()
  vim.cmd 'ccl'
end, 'ccl')

return M
