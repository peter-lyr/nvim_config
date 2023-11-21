local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.map_buf_close(lhs, buf, cmd)
  if not cmd then
    cmd = 'close!'
  end
  if not buf then
    buf = vim.fn.bufnr()
  end
  local desc = string.format('close buf %d', buf)
  vim.keymap.set({ 'n', 'v', }, lhs, function()
    vim.cmd(cmd)
  end, { buffer = buf, nowait = true, desc = desc, })
end

function M.map_buf_c_q_close(buf, cmd)
  M.map_buf_close('<c-q>', buf, cmd)
end

--------------------

function M.execute_output(cmd)
  vim.cmd 'wincmd n'
  vim.fn.append(vim.fn.line '.', vim.fn.split(vim.fn.execute(cmd), '\n'))
  M.map_buf_c_q_close(vim.fn.bufnr(), 'bwipeout!')
end

vim.api.nvim_create_user_command('ExecuteOutput', function(params)
  M.execute_output(vim.fn.join(params['fargs'], ' '))
end, { nargs = '*', complete = 'command', })

function M.type_execute_output()
  vim.cmd [[call feedkeys(":\<c-u>ExecuteOutput ")]]
end

--------------------

function M.delete_whichkeys_txt()
  local whichkeys_txt = require 'startup'.whichkeys_txt
  local autocmd_startup = require 'my_simple'.autocmd_startup
  if autocmd_startup then
    vim.api.nvim_del_autocmd(autocmd_startup)
  end
  if vim.fn.filereadable(whichkeys_txt) == 1 then
    vim.fn.delete(whichkeys_txt)
    print('Deleted: ' .. whichkeys_txt)
  else
    print('Not exists: ' .. whichkeys_txt)
  end
end

--------------------

function M.startuptime(...)
  vim.g.startuptime_tries = 10
  local opts = ''
  for _, t in ipairs { ..., } do
    opts = opts .. ' ' .. t
  end
  vim.cmd('StartupTime' .. opts)
  vim.fn.timer_start(20, function()
    M.map_buf_c_q_close(vim.fn.bufnr(), 'bwipeout!')
  end)
end

M.restart_nvim_qt_dir_path = B.get_create_std_data_dir 'restart_nvim_qt'
M.restart_nvim_qt_bat_path = B.get_create_file_path(M.restart_nvim_qt_dir_path, 'restart_nvim_qt.bat')

function M.start_new_nvim_qt()
  local rtp = vim.fn.expand(string.match(vim.fn.execute 'set rtp', ',([^,]+)\\share\\nvim\\runtime'))
  M.restart_nvim_qt_bat_path:write(string.format([[
@echo off
REM sleep 1
cd %s\bin
start /d %s nvim-qt.exe
exit
]],
    rtp, vim.loop.cwd()), 'w')
  vim.cmd(string.format([[silent !start /b /min %s]], M.restart_nvim_qt_bat_path.filename))
end

--------------------

function M.source_lua(file)
  if not file then
    file = vim.api.nvim_buf_get_name(0)
  end
  local lua = B.get_loaded(file)
  if B.is(lua) then
    package.loaded[lua] = nil
    vim.cmd('source ' .. file)
    B.notify_info('source ' .. file)
  end
end

--------------------

return M
