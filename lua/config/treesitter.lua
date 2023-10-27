local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

M.treesitter_parser_path = B.get_std_data_dir_path 'treesitter-parser'

if not M.treesitter_parser_path:exists() then
  vim.fn.mkdir(M.treesitter_parser_path.filename)
end

vim.opt.runtimepath:append(M.treesitter_parser_path.filename)

-- M.disable = function(lang, buf)
M.disable = function(_, buf)
  local max_filesize = 1000 * 1024
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
end

require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'c',
    'python',
    'lua',
    'markdown', 'markdown_inline',
  },
  sync_install = false,
  auto_install = false,
  parser_install_dir = M.treesitter_parser_path.filename,
  highlight = {
    enable = true,
    disable = M.disable,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = M.disable,
  },
  incremental_selection = {
    enable = true,
    disable = M.disable,
    keymaps = {
      init_selection = 'qi',
      node_incremental = 'qi',
      scope_incremental = 'qu',
      node_decremental = 'qo',
    },
  },
  rainbow = {
    enable = true,
    disable = M.disable,
    extended_mode = true,
    max_file_lines = nil,
  },
  matchup = {
    enable = true,
    disable = M.disable,
  },
}

require 'rainbow.internal'.defhl()

require 'treesitter-context'.setup {
  zindex = 1,
  on_attach = function()
    local max_filesize = 1000 * 1024
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > max_filesize then
      return false
    end
    return true
  end,
}

require 'match-up'.setup {}

-- solve diffview close err
if package.loaded['plugins.diffview'] then
  vim.api.nvim_create_autocmd({ 'TabClosed', 'TabEnter', }, {
    callback = function()
      B.set_timeout(50, function()
        if string.match(vim.bo.ft, 'Diffview') or vim.opt.diff:get() == true then
          vim.cmd 'TSDisable rainbow'
        else
          vim.cmd 'TSEnable rainbow'
        end
      end)
    end,
  })
end
