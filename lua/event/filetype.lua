local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

-- close some filetypes with <c-q>
B.aucmd(M.source, 'FileType', 'FileType', {
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
      require 'config.test'.map_buf_c_q_close(ev.buf, 'close!')
    end)
  end,
})

return M
