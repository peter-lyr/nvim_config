local M = {}

function M.map_buf_close(lhs, buf, cmd)
  if not cmd then
    cmd = 'close!'
  end
  local desc = string.format('close buf %d', buf)
  vim.keymap.set({ 'n', 'v', }, lhs, function()
    vim.cmd(cmd)
  end, { buffer = buf, nowait = true, desc = desc, })
end

function M.map_buf_q_close(buf, cmd)
  M.map_buf_close('<esc>', buf, cmd)
  M.map_buf_close('q', buf, cmd)
end

--------------------

function M.execute_output(cmd)
  vim.cmd 'wincmd n'
  vim.fn.append(vim.fn.line '.', vim.fn.split(vim.fn.execute(cmd), '\n'))
  M.map_buf_q_close(vim.fn.bufnr(), 'bwipeout!')
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

function M.startuptime()
  vim.cmd 'StartupTime'
  vim.fn.timer_start(20, function()
    M.map_buf_q_close(vim.fn.bufnr(), 'bwipeout!')
  end)
end

function M.start_new_nvim_qt()
  vim.cmd(
    string.format([[silent !start /d %s /b %s\\bin\\nvim-qt.exe"]],
    vim.loop.cwd(),
    string.match(vim.fn.execute 'set rtp', ',([^,]+)\\share\\nvim\\runtime'))
  )
end

--------------------

return M
