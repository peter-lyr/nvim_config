local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.load_require 'rcarriga/nvim-notify'

function M.notify_info(message)
  local messages = type(message) == 'table' and message or { message, }
  local title = ''
  if #messages > 1 then
    title = table.remove(messages, 1)
  end
  message = vim.fn.join(messages, '\n')
  vim.notify(message, 'info', {
    title = title,
    animate = false,
    on_open = M.notify_on_open,
    timeout = 1000 * 8,
  })
end

function M.notify_error(message)
  local messages = type(message) == 'table' and message or { message, }
  local title = ''
  if #messages > 1 then
    title = table.remove(messages, 1)
  end
  message = vim.fn.join(messages, '\n')
  vim.notify(message, 'error', {
    title = title,
    animate = false,
    on_open = M.notify_on_open,
    timeout = 1000 * 8,
  })
end

function M.notify_qflist()
  local lines = {}
  for _, i in ipairs(vim.fn.getqflist()) do
    lines[#lines + 1] = i['text']
  end
  M.notify_info(lines)
end

function M.refresh_fugitive()
  vim.cmd 'Lazy load vim-fugitive'
  vim.call 'fugitive#ReloadStatus'
end

M.asyncrun_done_changed = nil

function M.asyncrun_done_default()
  M.notify_qflist()
  M.refresh_fugitive()
  vim.cmd 'au! User AsyncRunStop'
end

function M.au_user_asyncrunstop()
  vim.cmd 'au User AsyncRunStop call v:lua.AsyncRunDone()'
end

function M.asyncrun_prepare(callback)
  if callback then
    AsyncRunDone = function()
      M.asyncrun_done_changed = nil
      callback()
      vim.cmd 'au! User AsyncRunStop'
      AsyncRunDone = M.asyncrun_done_default
    end
    M.asyncrun_done_changed = 1
  end
  M.au_user_asyncrunstop()
end

function M.asyncrun_prepare_add(callback)
  if callback then
    AsyncRunDone = function()
      M.asyncrun_done_changed = nil
      M.asyncrun_done_default()
      callback()
      AsyncRunDone = M.asyncrun_done_default
    end
    M.asyncrun_done_changed = 1
  end
  M.au_user_asyncrunstop()
end

function M.asyncrun_prepare_default()
  if not M.asyncrun_done_changed then
    AsyncRunDone = M.asyncrun_done_default
    M.au_user_asyncrunstop()
  end
end

function M.notify_on_open(win)
  local buf = vim.api.nvim_win_get_buf(win)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  vim.api.nvim_win_set_option(win, 'concealcursor', 'nvic')
end

function M.system_run(way, str_format, ...)
  if type(str_format) == 'table' then
    str_format = vim.fn.join(str_format, ' && ')
  end
  local cmd = string.format(str_format, ...)
  if way == 'start' then
    cmd = string.format([[silent !start cmd /c "%s"]], cmd)
    vim.cmd(cmd)
  elseif way == 'asyncrun' then
    vim.cmd 'Lazy load asyncrun.vim'
    cmd = string.format('AsyncRun %s', cmd)
    M.asyncrun_prepare_default()
    vim.cmd(cmd)
  elseif way == 'term' then
    cmd = string.format('wincmd s|term %s', cmd)
    vim.cmd(cmd)
  end
end

function M.cmd(str_format, ...)
  if type(str_format) == 'table' then
    str_format = vim.fn.join(str_format, ' && ')
  end
  vim.cmd(string.format(str_format, ...))
end

function M.system_cd(file)
  vim.cmd 'Lazy load plenary.nvim'
  local new_file = ''
  if string.sub(file, 2, 2) == ':' then
    new_file = new_file .. string.sub(file, 1, 2) .. ' && '
  end
  if require 'plenary.path'.new(file):is_dir() then
    return new_file .. 'cd ' .. file
  else
    return new_file .. 'cd ' .. require 'plenary.path'.new(file):parent().filename
  end
end

-----------

function M.powershell_run(cmd)
  vim.g.powershell_run_cmd = cmd
  vim.g.powershell_run_out = nil
  vim.cmd [[
  python << EOF
import vim
import subprocess
cmd = vim.eval('g:powershell_run_cmd')
process = subprocess.Popen(["powershell", cmd],stdout=subprocess.PIPE, stderr = subprocess.PIPE)
out = process.communicate()
res = []
for o in out:
  o = o.replace(b'\r', b'')
  try:
    o = o.decode('utf-8')
  except:
    try:
      o = o.decode('gbk')
    except:
      o = '-error-'
  res.append(o.split('\n'))
vim.command(f"""let g:powershell_run_out = {res}""")
EOF
]]
  return vim.g.powershell_run_out
end

return M
