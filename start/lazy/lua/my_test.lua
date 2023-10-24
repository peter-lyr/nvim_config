local T = {}

function T.map_buf_close(lhs, buf, cmd)
  if not cmd then
    cmd = 'close!'
  end
  local desc = string.format('close buf %d', buf)
  vim.keymap.set({ 'n', 'v', }, lhs, function()
    vim.cmd(cmd)
  end, { buffer = buf, nowait = true, desc = desc, })
end

function T.map_buf_esc_q_close(buf, cmd)
  T.map_buf_close('<esc>', buf, cmd)
  T.map_buf_close('q', buf, cmd)
end

function T.append(cmd)
  vim.cmd 'wincmd n'
  vim.fn.append(vim.fn.line('.'), vim.fn.split(vim.fn.execute(cmd), '\n'))
  T.map_buf_esc_q_close(vim.fn.bufnr(), 'bwipeout!')
end

return T
