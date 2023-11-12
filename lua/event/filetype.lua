local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

-- close some filetypes with <c-q>
B.aucmd(M.lua, 'FileType', 'FileType', {
  pattern = {
    'lazy',
    'help',
    'lspinfo',
    'man',
    'mason',
    'git',
    'notify',
    'fugitive',
    'fugitiveblame',
    'qf',
    'spectre_panel',
    'startuptime',
    'checkhealth',
  },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    B.set_timeout(30, function()
      require 'config.my_test'.map_buf_c_q_close(ev.buf, 'close!')
    end)
  end,
})

return M
