local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
package.loaded[M.loaded] = nil
--------------------------------------------

M.bufleave_readable_file = ''

B.aucmd(M.source, 'BufLeave', { 'BufLeave', }, {
  callback = function(ev)
    local fname = vim.api.nvim_buf_get_name(ev.buf)
    if require 'plenary.path':new(fname):exists() then
      M.bufleave_readable_file = fname
    end
  end,
})

M.is_bufname_terminal = function(bufname, terminal)
  if string.match(bufname, '^term://') then
    if terminal == 'ipython' and string.match(bufname, ':ipython$') then
      return true, true
    elseif terminal == 'bash' and string.match(bufname, ':bash$') then
      return true, true
    elseif terminal == 'powershell' and string.match(bufname, ':powershell$') then
      return true, true
    elseif terminal == 'cmd' and string.match(bufname, ':cmd$') then
      return true, true
    else
      return true, nil
    end
  end
  return nil, nil
end

M.try_goto_terminal = function()
  for winnr = 1, vim.fn.winnr '$' do
    local bufnr = vim.fn.winbufnr(winnr)
    if vim.fn.getbufvar(bufnr, '&buftype') == 'terminal' then
      vim.fn.win_gotoid(vim.fn.win_getid(winnr))
      return 1
    end
  end
  return nil
end

M.get_terminal_bufnrs = function(terminal)
  local terminal_bufnrs = {}
  for _, v in pairs(vim.fn.getbufinfo()) do
    local _, certain = M.is_bufname_terminal(v['name'], terminal)
    if certain then
      terminal_bufnrs[#terminal_bufnrs + 1] = v['bufnr']
    end
  end
  if #terminal_bufnrs == 0 then
    return nil
  end
  return terminal_bufnrs
end

M.is_hide_en = function()
  local cnt = 0
  for i = 1, vim.fn.winnr '$' do
    if vim.fn.getbufvar(vim.fn.winbufnr(i), '&buftype') ~= 'nofile' then
      cnt = cnt + 1
    end
    if cnt > 1 then
      return 1
    end
  end
  return nil
end

function M.toggle(terminal, chdir)
  if not chdir then
    chdir = ''
  end
  if vim.g.builtin_terminal_ok == 0 then
    if chdir == '.' then
      chdir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')
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
  local terminal_bufnrs = M.get_terminal_bufnrs(terminal)
  local one, certain = M.is_bufname_terminal(fname, terminal)
  if certain then
    if #chdir > 0 then
      if chdir == '.' then
        chdir = vim.fn.fnamemodify(M.bufleave_readable_file, ':h')
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
      B.buf_map_q_esc_close()
      return
    else
      if #terminal_bufnrs == 1 then
        if M.is_hide_en() then
          vim.cmd 'hide'
        end
        return
      end
    end
    local bnr_idx = B.index_of(terminal_bufnrs, vim.fn.bufnr())
    bnr_idx = bnr_idx + 1
    if bnr_idx > #terminal_bufnrs then
      if M.is_hide_en() then
        vim.cmd 'hide'
      end
      return
    else
      vim.cmd(string.format('b%d', terminal_bufnrs[bnr_idx]))
      B.buf_map_q_esc_close()
    end
  else
    if terminal_bufnrs then
      if not M.try_goto_terminal() then
        if #fname > 0 or vim.bo.modified == true then
          vim.cmd 'split'
        end
      end
      vim.cmd(string.format('b%d', terminal_bufnrs[1]))
    else
      if not one then
        vim.cmd 'split'
      end
      vim.cmd(string.format('term %s', terminal))
    end
    B.buf_map_q_esc_close()
    if #chdir > 0 then
      M.toggle(terminal, chdir)
    end
  end
end

function M.send(terminal, to_send, show) -- show时，send后不hide
  if vim.g.builtin_terminal_ok == 0 then
    vim.cmd(string.format('silent !start %s', terminal))
    return
  end
  local cmd_to_send = ''
  if to_send == 'curline' then
    cmd_to_send = vim.fn.getline '.'
  elseif to_send == 'paragraph' then
    if terminal == 'terminal' then
      cmd_to_send = B.get_paragraph ' && '
    elseif terminal == 'powershell' then
      cmd_to_send = B.get_paragraph '; '
    else
      cmd_to_send = B.get_paragraph '\n'
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
  local terminal_bufnrs = M.get_terminal_bufnrs(terminal)
  local one, certain = M.is_bufname_terminal(fname, terminal)
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
      if M.is_hide_en() then
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
      if not M.try_goto_terminal() then
        if #fname > 0 or vim.bo.modified == true then
          vim.cmd 'split'
        end
      end
      vim.cmd(string.format('b%d', terminal_bufnrs[1]))
    else
      if not one then
        vim.cmd 'split'
      end
      vim.cmd(string.format('term %s', terminal))
    end
    if #cmd_to_send > 0 then
      M.send(terminal, cmd_to_send, show)
    end
  end
end

function M.hideall()
  local winid = vim.fn.win_getid()
  for winnr = vim.fn.winnr '$', 1, -1 do
    local buf = vim.fn.winbufnr(winnr)
    if vim.fn.buflisted(buf) ~= 0 and 1 then
      if vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
        vim.fn.win_gotoid(vim.fn.win_getid(winnr))
        pcall(vim.cmd, 'close')
      end
    end
  end
  vim.fn.win_gotoid(winid)
end

local major, minor, patch = string.match(vim.fn.system 'ver', '(%d+)%.(%d+)%.(%d+)%.%d+')
major = tonumber(major, 10)
minor = tonumber(minor, 10)
patch = tonumber(patch, 10)

if major < 10 or patch < 18900 then
  vim.g.builtin_terminal_ok = 1
end

B.map('<leader><f1><f1>', M, 'toggle', { 'cmd', })
B.map('<leader><f2><f2>', M, 'toggle', { 'ipython', })
B.map('<leader><f3><f3>', M, 'toggle', { 'bash', })
B.map('<leader><f4><f4>', M, 'toggle', { 'powershell', })

-- cd
B.map('<leader><f1>w', M, 'toggle', { 'cmd', 'cwd', })
B.map('<leader><f2>w', M, 'toggle', { 'ipython', 'cwd', })
B.map('<leader><f3>w', M, 'toggle', { 'bash', 'cwd', })
B.map('<leader><f4>w', M, 'toggle', { 'powershell', 'cwd', })
B.map('<leader><f1>.', M, 'toggle', { 'cmd', '.', })
B.map('<leader><f2>.', M, 'toggle', { 'ipython', '.', })
B.map('<leader><f3>.', M, 'toggle', { 'bash', '.', })
B.map('<leader><f4>.', M, 'toggle', { 'powershell', '.', })
B.map('<leader><f1>u', M, 'toggle', { 'cmd', 'u', })
B.map('<leader><f2>u', M, 'toggle', { 'ipython', 'u', })
B.map('<leader><f3>u', M, 'toggle', { 'bash', 'u', })
B.map('<leader><f4>u', M, 'toggle', { 'powershell', 'u', })
B.map('<leader><f1>-', M, 'toggle', { 'cmd', '-', })
B.map('<leader><f2>-', M, 'toggle', { 'ipython', '-', })
B.map('<leader><f3>-', M, 'toggle', { 'bash', '-', })
B.map('<leader><f4>-', M, 'toggle', { 'powershell', '-', })

-- send and show
B.map('<leader><f1>s.', M, 'send', { 'cmd', 'curline', 'show', })
B.map('<leader><f2>s.', M, 'send', { 'ipython', 'curline', 'show', })
B.map('<leader><f3>s.', M, 'send', { 'bash', 'curline', 'show', })
B.map('<leader><f4>s.', M, 'send', { 'powershell', 'curline', 'show', })
B.map('<leader><f1>sp', M, 'send', { 'cmd', 'paragraph', 'show', })
B.map('<leader><f2>sp', M, 'send', { 'ipython', 'paragraph', 'show', })
B.map('<leader><f3>sp', M, 'send', { 'bash', 'paragraph', 'show', })
B.map('<leader><f4>sp', M, 'send', { 'powershell', 'paragraph', 'show', })
B.map('<leader><f1>sc', M, 'send', { 'cmd', 'clipboard', 'show', })
B.map('<leader><f2>sc', M, 'send', { 'ipython', 'clipboard', 'show', })
B.map('<leader><f3>sc', M, 'send', { 'bash', 'clipboard', 'show', })
B.map('<leader><f4>sc', M, 'send', { 'powershell', 'clipboard', 'show', })

-- send and hide
B.map('<leader><f1>h.', M, 'send', { 'cmd', 'curline', 'hide', })
B.map('<leader><f2>h.', M, 'send', { 'ipython', 'curline', 'hide', })
B.map('<leader><f3>h.', M, 'send', { 'bash', 'curline', 'hide', })
B.map('<leader><f4>h.', M, 'send', { 'powershell', 'curline', 'hide', })
B.map('<leader><f1>hp', M, 'send', { 'cmd', 'paragraph', 'hide', })
B.map('<leader><f2>hp', M, 'send', { 'ipython', 'paragraph', 'hide', })
B.map('<leader><f3>hp', M, 'send', { 'bash', 'paragraph', 'hide', })
B.map('<leader><f4>hp', M, 'send', { 'powershell', 'paragraph', 'hide', })
B.map('<leader><f1>hc', M, 'send', { 'cmd', 'clipboard', 'hide', })
B.map('<leader><f2>hc', M, 'send', { 'ipython', 'clipboard', 'hide', })
B.map('<leader><f3>hc', M, 'send', { 'bash', 'clipboard', 'hide', })
B.map('<leader><f4>hc', M, 'send', { 'powershell', 'clipboard', 'hide', })

-- hideall
B.map('<leader><f1><del>', M, 'hideall')
B.map('<leader><f2><del>', M, 'hideall')
B.map('<leader><f3><del>', M, 'hideall')
B.map('<leader><f4><del>', M, 'hideall')

return M
