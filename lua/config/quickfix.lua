local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

M.bqf = require 'bqf'

M.percent = 50

function M.hi()
  vim.cmd [[
    hi BqfPreviewBorder guifg=#50a14f ctermfg=71
    hi link BqfPreviewRange Search
  ]]
end

M.hi()

function M.au_height()
  if vim.bo.ft == 'qf' then
    local floatwin = require 'bqf.preview.floatwin'
    floatwin.defaultHeight = vim.fn.float2nr(vim.o.lines * M.percent / 100 - 3)
    floatwin.defaultVHeight = vim.fn.float2nr(vim.o.lines * M.percent / 100 - 3)
  end
end

M.bqf.setup {
  auto_resize_height = true,
  preview = {
    win_height = vim.fn.float2nr(vim.o.lines * M.percent / 100 - 3),
    win_vheight = vim.fn.float2nr(vim.o.lines * M.percent / 100 - 3),
    wrap = true,
  },
}

------

M.qf_before_winid = -1

function M.close()
  vim.cmd 'cclose'
  if vim.api.nvim_win_is_valid(M.qf_before_winid) == true then
    vim.fn.win_gotoid(M.qf_before_winid)
  end
end

function M.wait_map_q()
  vim.fn.timer_start(10, function()
    if vim.api.nvim_win_get_width(0) < vim.o.columns then
      vim.cmd 'wincmd J'
    end
    vim.keymap.set({ 'n', 'v', }, 'q', function()
      M.close()
    end, { buffer = vim.fn.bufnr(), nowait = true, silent = true, })
    vim.keymap.set({ 'n', 'v', }, '<c-q>', function()
      M.close()
    end, { buffer = vim.fn.bufnr(), nowait = true, silent = true, })
  end)
end

function M.toggle(open)
  if vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'buftype') == 'quickfix' and not open then
    M.close()
  else
    M.qf_before_winid = vim.fn.win_getid()
    vim.cmd 'copen'
    M.wait_map_q()
  end
end

function M.open_file(cclose)
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
    if vim.api.nvim_win_is_valid(M.qf_before_winid) == true then
      vim.fn.win_gotoid(M.qf_before_winid)
      if cclose == 1 then
        vim.cmd 'cclose'
      end
      vim.cmd('e ' .. cfile)
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

function M.open_and_close()
  M.open_file(1)
end

function M.click_open()
  vim.cmd [[call feedkeys("\<LeftMouse>")]]
  M.open_file()
end

function M.del_dupl()
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

M.height = 0
M.bufnr = 0

function M.map(ev)
  if vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'buftype') == 'quickfix' then
    M.bufnr = ev.buf
    M.height = vim.api.nvim_win_get_height(0)
    vim.o.wrap = false
    vim.keymap.set('n', 'o', M.open_and_close, { buffer = ev.buf, nowait = true, silent = true, })
    vim.keymap.set('n', 'a', M.open_and_close, { buffer = ev.buf, nowait = true, silent = true, })
    vim.keymap.set('n', '<cr>', M.click_open, { buffer = ev.buf, nowait = true, silent = true, })
    vim.keymap.set('n', '<2-LeftMouse>', M.click_open, { buffer = ev.buf, nowait = true, silent = true, })
    vim.cmd 'setlocal scrolloff=0'
    M.del_dupl()
    M.wait_map_q()
  end
end

return M
