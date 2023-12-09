local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.get_str_num(str, hex)
  vim.g.str = str
  vim.g.hex = hex and 1 or 0
  vim.g.str_is_num = nil
  vim.cmd [[
    python << EOF
import re
import vim
s = vim.eval('g:str')
h = int(vim.eval('g:hex'))
if not h:
  if len(s) > 2 and s[:2].lower() == '0x':
    h = 1
  elif re.findall('[a-fA-F]', s):
    h = 1
try:
  if h:
    num = int(s, 16)
  else:
    num = int(s)
  vim.command(f'let g:str_is_num = 1')
  vim.command(f'let g:num = "{num}"')
except Exception as e:
  e = ','.join(e.args).replace("'", '"')
  vim.command(f"""lua require'my_base'.notify_error('get_str_num, error: {e}')""")
EOF
]]
  if vim.g.str_is_num then
    return vim.g.num
  end
  return nil
end

function M.count_bin(cword, hex, append)
  cword = vim.fn.expand(cword)
  local num = M.get_str_num(cword, hex)
  if not num then
    return
  end
  vim.g.num = num
  vim.cmd [[
    python << EOF
import re
import vim
num = eval(vim.eval('g:num'))
index_list = []
value_list = []
for i, bit in enumerate(str(bin(num))[2:][::-1]):
  bit_width = 1 + len(str(i))
  if bit == '1':
    value_list.append(('%%%ds' % bit_width) % '1')
  else:
    value_list.append(('%%%ds' % bit_width) % '')
  index_list.append(('%%%dd' % bit_width) % i)
index_list = index_list[::-1]
value_list = value_list[::-1]
vim.command(f'let g:int = "{int(num)}"')
vim.command(f'let g:hex = "{hex(num)}"')
vim.command(f'let g:bin = "{bin(num)}"')
vim.command(f'let g:index = {index_list}')
vim.command(f'let g:value = {value_list}')
EOF
]]
  local main = string.format('%s %s %s', vim.g.bin, vim.g.int, vim.g.hex)
  local index = 'index: │' .. vim.fn.join(vim.g.index, '')
  local value = 'value: │' .. vim.fn.join(vim.g.value, '')
  if append then
    vim.fn.append('.', { '', cword, main, index, value, '', })
    vim.cmd [[call feedkeys("2jgcip")]]
  else
    B.notify_info {
      '',
      'count bin: ' .. cword,
      '',
      main,
      '',
      index,
      value,
      '',
      '',
    }
  end
end

return M
