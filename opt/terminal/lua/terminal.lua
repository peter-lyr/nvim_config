local M = {}
local B = require 'my_base'
M.source = debug.getinfo(1)['source']
package.loaded[B.get_loaded(M.source)] = nil
--------------------------------------------

local bufleave_readable_file = ''

vim.api.nvim_create_autocmd({ 'BufLeave', }, {
  callback = function()
    local fname = vim.api.nvim_buf_get_name(0)
    if require 'plenary.path':new(fname):exists() then
      bufleave_readable_file = fname
    end
  end,
})

local is_bufname_terminal = function(bufname, terminal)
  if string.match(bufname, '^term://') then
    local is_ipython = string.match(bufname, ':ipython$')
    local is_bash = string.match(bufname, ':bash$')
    local is_powershell = string.match(bufname, ':powershell$')
    local is_cmd = string.match(bufname, ':cmd$')
    if terminal == 'ipython' and is_ipython then
      return true, true
    elseif terminal == 'bash' and is_bash then
      return true, true
    elseif terminal == 'powershell' and is_powershell then
      return true, true
    elseif terminal == 'cmd' and is_cmd then
      return true, true
    else
      return true, false
    end
  end
  return false, false
end

local try_goto_terminal = function()
  for i = 1, vim.fn.winnr '$' do
    local bufnr = vim.fn.winbufnr(i)
    local buftype = vim.fn.getbufvar(bufnr, '&buftype')
    if buftype == 'terminal' then
      vim.fn.win_gotoid(vim.fn.win_getid(i))
      return true
    end
  end
  return false
end

local get_terminal_bufnrs = function(terminal)
  local terminal_bufnrs = {}
  for _, v in pairs(vim.fn.getbufinfo()) do
    local _, certain = is_bufname_terminal(v['name'], terminal)
    if certain then
      table.insert(terminal_bufnrs, v['bufnr'])
    end
  end
  if #terminal_bufnrs == 0 then
    return nil
  end
  return terminal_bufnrs
end

local is_hide_en = function()
  local cnt = 0
  for i = 1, vim.fn.winnr '$' do
    if vim.fn.getbufvar(vim.fn.winbufnr(i), '&buftype') ~= 'nofile' then
      cnt = cnt + 1
    end
    if cnt > 1 then
      return true
    end
  end
  return false
end

local get_dname = function(readablefile)
  if #readablefile == 0 then
    return ''
  end
  local fname = string.gsub(readablefile, '\\', '/')
  local path = require 'plenary.path':new(fname)
  if path:is_file() then
    return path:parent()['filename']
  end
  return ''
end

local function map_q_close()
  local buf = vim.fn.bufnr()
  vim.bo[buf].buflisted = false
  vim.keymap.set('n', 'q', function()
    pcall(vim.cmd, 'close')
  end, { buffer = buf, nowait = true, silent = true, })
  vim.keymap.set('n', '<esc>', function()
    pcall(vim.cmd, 'close')
  end, { buffer = buf, nowait = true, silent = true, })
end

M.toggle                  = function(terminal, chdir)
  if not chdir then
    chdir = ''
  end
  if vim.g.builtin_terminal_ok == 0 then
    if chdir == '.' then
      chdir = get_dname(vim.api.nvim_buf_get_name(0))
      chdir = string.gsub(chdir, '/', '\\')
    elseif chdir == 'u' then
      chdir = '..'
    elseif chdir == '-' then
      chdir = '-'
    elseif chdir == 'cwd' then
      chdir = vim.fn.getcwd()
    end
    vim.cmd(string.format('silent !cd %s & start %s', chdir, terminal))
    return
  end
  local fname = vim.api.nvim_buf_get_name(0)
  local terminal_bufnrs = get_terminal_bufnrs(terminal)
  local one, certain = is_bufname_terminal(fname, terminal)
  if certain then
    if #chdir > 0 then
      if chdir == '.' then
        chdir = get_dname(bufleave_readable_file)
      elseif chdir == 'u' then
        chdir = '..'
      elseif chdir == '-' then
        chdir = '-'
      elseif chdir == 'cwd' then
        chdir = vim.fn.getcwd()
      end
      chdir = string.gsub(chdir, '\\', '/')
      vim.api.nvim_chan_send(vim.b.terminal_job_id, string.format('cd %s', chdir))
      if terminal == 'ipython' then
        vim.fn.feedkeys [[:call feedkeys("i\<cr>\<esc>")]]
        local t0 = os.clock()
        while os.clock() - t0 <= 0.02 do
        end
        vim.cmd [[call feedkeys("\<cr>")]]
      else
        vim.cmd [[call feedkeys("i\<cr>\<esc>")]]
      end
      map_q_close()
      return
    else
      if #terminal_bufnrs == 1 then
        if is_hide_en() then
          vim.cmd 'hide'
        end
        return
      end
    end
    local bnr_idx = B.index_of(terminal_bufnrs, vim.fn.bufnr())
    bnr_idx = bnr_idx + 1
    if bnr_idx > #terminal_bufnrs then
      if is_hide_en() then
        vim.cmd 'hide'
      end
      return
    else
      vim.cmd(string.format('b%d', terminal_bufnrs[bnr_idx]))
      map_q_close()
    end
  else
    if terminal_bufnrs then
      if not try_goto_terminal() then
        if #fname > 0 or vim.bo.modified == true then
          vim.cmd 'split'
        end
      end
      vim.cmd(string.format('b%d', terminal_bufnrs[1]))
    else
      if not one then
        vim.cmd 'split'
      end
      vim.cmd(string.format('te %s', terminal))
    end
    map_q_close()
    if #chdir > 0 then
      M.toggle(terminal, chdir)
    end
  end
end

local get_paragraph       = function(sep)
  local paragraph = {}
  local linenr = vim.fn.line '.'
  local lines = 0
  for i = linenr, 1, -1 do
    local line = vim.fn.getline(i)
    if #line > 0 then
      lines = lines + 1
      table.insert(paragraph, 1, line)
    else
      break
    end
  end
  for i = linenr + 1, vim.fn.line '$' do
    local line = vim.fn.getline(i)
    if #line > 0 then
      table.insert(paragraph, line)
      lines = lines + 1
    else
      break
    end
  end
  return table.concat(paragraph, sep)
end

M.send                    = function(terminal, to_send, show) -- show时，send后不hide
  if vim.g.builtin_terminal_ok == 0 then
    vim.cmd(string.format('silent !start %s', terminal))
    return
  end
  local cmd_to_send = ''
  if to_send == 'curline' then
    cmd_to_send = vim.fn.getline '.'
  elseif to_send == 'paragraph' then
    if terminal == 'terminal' then
      cmd_to_send = get_paragraph ' && '
    elseif terminal == 'powershell' then
      cmd_to_send = get_paragraph '; '
    else
      cmd_to_send = get_paragraph '\n'
    end
  elseif to_send == 'clipboard' then
    local clipboard = vim.fn.getreg '+'
    clipboard = clipboard:gsub('^%s*(.-)%s*$', '%1') -- trim_string
    if terminal == 'terminal' then
      cmd_to_send = string.gsub(clipboard, '\n', ' && ')
    elseif terminal == 'powershell' then
      cmd_to_send = string.gsub(clipboard, '\n', '; ')
    elseif terminal == 'ipython' then
      cmd_to_send = '%paste'
    else
      cmd_to_send = clipboard
    end
    print('cmd_to_send', cmd_to_send)
  else
    cmd_to_send = to_send
  end
  local fname = vim.api.nvim_buf_get_name(0)
  local terminal_bufnrs = get_terminal_bufnrs(terminal)
  local one, certain = is_bufname_terminal(fname, terminal)
  if certain then
    vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd_to_send)
    if terminal == 'ipython' then
      vim.fn.feedkeys [[:call feedkeys("i\<cr>\<esc>")]]
      local t0 = os.clock()
      while os.clock() - t0 <= 0.02 do
      end
      vim.cmd [[call feedkeys("\<cr>")]]
    else
      vim.cmd [[call feedkeys("i\<cr>\<esc>")]]
    end
    if show ~= 'show' then
      if is_hide_en() then
        vim.loop.new_timer():start(100, 0,
          function()
            vim.schedule(function()
              vim.cmd 'hide'
            end)
          end)
      end
    end
  else
    if terminal_bufnrs then
      if not try_goto_terminal() then
        if #fname > 0 or vim.bo.modified == true then
          vim.cmd 'split'
        end
      end
      vim.cmd(string.format('b%d', terminal_bufnrs[1]))
    else
      if not one then
        vim.cmd 'split'
      end
      vim.cmd(string.format('te %s', terminal))
    end
    if #cmd_to_send > 0 then
      M.send(terminal, cmd_to_send, show)
    end
  end
end

M.hideall                 = function()
  local winid = vim.fn.win_getid()
  for winnr = 1, vim.fn.winnr '$' do
    local b = vim.fn.winbufnr(winnr)
    if vim.fn.buflisted(b) ~= 0 and 1 then
      if vim.api.nvim_buf_get_option(b, 'buftype') == 'terminal' then
        vim.fn.win_gotoid(vim.fn.win_getid(winnr))
        pcall(vim.cmd, 'close')
      end
    end
  end
  vim.fn.win_gotoid(winid)
end

local major, minor, patch = string.match(vim.fn.system 'ver', 'Microsoft Windows %[Version (%d+)%.(%d+)%.(%d+)%.%d+%]')
major = tonumber(major, 10)
minor = tonumber(minor, 10)
patch = tonumber(patch, 10)

if major < 10 or patch < 18900 then
  vim.g.builtin_terminal_ok = 1
end

return M
