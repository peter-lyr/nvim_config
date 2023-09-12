package.loaded['quickfix'] = nil

local M = {}

vim.g.qf_before_winid = -1

M.allow = nil

M.last_en = false
M.lastline = -1
M.lastcol = -1

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
    end
  else
    vim.g.qf_before_winid = vim.fn.win_getid()
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
      if line ~= 0 and col ~= 0 then
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

local function click_open()
  vim.cmd [[call feedkeys("\<LeftMouse>")]]
  open()
end

local function nodupl()
  local title = vim.fn.getqflist { title = 0, }.title
  local l = {}
  local D = {}
  local L = vim.fn.getqflist()
  local different = nil
  for _, i in ipairs(L) do
    i.text = vim.fn.trim(i.text)
    local d = string.format('%d-%d-%d-%s', i.bufnr, i.col, i.lnum, i.text)
    if vim.tbl_contains(D, d) == false or #i.text == 0 then
      l[#l + 1] = i
      D[#D + 1] = d
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
        vim.o.wrap = true
      else
        vim.o.wrap = false
      end
      vim.keymap.set('n', 'o', open_ccl, { buffer = ev.buf, nowait = true, silent = true, })
      vim.keymap.set('n', 'a', open_ccl, { buffer = ev.buf, nowait = true, silent = true, })
      vim.keymap.set('n', '<2-LeftMouse>', click_open, { buffer = ev.buf, nowait = true, silent = true, })
      vim.cmd [[
        setlocal scrolloff=0
      ]]
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
