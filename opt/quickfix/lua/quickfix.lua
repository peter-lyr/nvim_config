package.loaded['quickfix'] = nil

local M = {}

vim.g.qf_before_winid = -1

M.allow = nil

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
    vim.cmd 'wincmd J'
    vim.fn.timer_start(20, function()
      vim.api.nvim_win_set_height(0, 15)
      vim.cmd 'set winfixheight'
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
end

local open = function()
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
      vim.cmd 'ccl'
    end
  else
  end
end

pcall(vim.api.nvim_del_autocmd, vim.g.quickfix_au_bufenter)

vim.g.quickfix_au_bufenter = vim.api.nvim_create_autocmd({ 'BufEnter', }, {
  callback = function(ev)
    if vim.api.nvim_buf_get_option(ev.buf, 'buftype') == 'quickfix' then
      vim.keymap.set('n', 'o', open, { buffer = ev.buf, nowait = true, silent = true, })
      vim.keymap.set('n', 'a', open, { buffer = ev.buf, nowait = true, silent = true, })
    end
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.quickfix_au_bufleave)

vim.g.quickfix_au_bufleave = vim.api.nvim_create_autocmd({ 'BufLeave', }, {
  callback = function()
    M.allow = 1
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.quickfix_au_cursorhold)

vim.g.quickfix_au_cursorhold = vim.api.nvim_create_autocmd({ 'CursorHold', }, {
  callback = function(ev)
    if vim.api.nvim_buf_get_option(ev.buf, 'buftype') == 'quickfix' and M.allow then
      M.allow = nil
      vim.cmd 'wincmd J'
      vim.fn.timer_start(20, function()
        require 'bufferjump'.i()
      end)
    end
  end,
})

require 'maps'.add('<esc>', 'n', function()
  vim.cmd('ccl')
end, 'ccl')

return M
