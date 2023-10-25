local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

function M.map_buf_close(lhs, buf, cmd)
  if not cmd then
    cmd = 'close!'
  end
  local desc = string.format('close buf %d', buf)
  vim.keymap.set({ 'n', 'v', }, lhs, function()
    vim.cmd(cmd)
  end, { buffer = buf, nowait = true, desc = desc, })
end

function M.map_buf_esc_q_close(buf, cmd)
  M.map_buf_close('<esc>', buf, cmd)
  M.map_buf_close('q', buf, cmd)
end

function M.execute_output(cmd)
  vim.cmd 'wincmd n'
  vim.fn.append(vim.fn.line('.'), vim.fn.split(vim.fn.execute(cmd), '\n'))
  M.map_buf_esc_q_close(vim.fn.bufnr(), 'bwipeout!')
end

return M
