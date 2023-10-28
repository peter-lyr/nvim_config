local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.aucmd(M.config, 'FileType', 'FileType', {
  pattern = {
    'help',
    'NvimTree',
    'fugitive',
    'lazy',
    'mason',
    'notify',
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

B.aucmd(M.config, 'BufReadPre', 'BufReadPre', {
  callback = function(ev)
    local max_filesize = 1000 * 1024
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
    if ok and stats and stats.size > max_filesize then
      vim.b.miniindentscope_disable = true
    end
  end,
})

require 'mini.indentscope'.setup {
  symbol = '│',
  options = { try_as_border = true, },
}

return M
