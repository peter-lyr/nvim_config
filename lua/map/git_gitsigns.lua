local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.opt(desc)
  return { silent = true, desc = M.lua .. ' ' .. desc, }
end

vim.keymap.set({ 'n', }, 'gd', function() require 'config.git_gitsigns'.diffthis() end, M.opt 'diffthis')
vim.keymap.set({ 'n', }, '<leader>gd', function() require 'config.git_gitsigns'.diffthis() end, M.opt 'diffthis')

vim.keymap.set({ 'n', }, '<leader>gmd', function() require 'config.git_gitsigns'.diffthis_l() end, M.opt 'diffthis_l')

vim.keymap.set({ 'n', }, 'gr', function() require 'config.git_gitsigns'.reset_hunk() end, M.opt 'reset_hunk')
vim.keymap.set({ 'n', }, '<leader>gr', function() require 'config.git_gitsigns'.reset_hunk() end, M.opt 'reset_hunk')
vim.keymap.set({ 'v', }, 'gr', function() require 'config.git_gitsigns'.reset_hunk_v() end, M.opt 'reset_hunk_v')
vim.keymap.set({ 'v', }, '<leader>gr', function() require 'config.git_gitsigns'.reset_hunk_v() end, M.opt 'reset_hunk_v')
vim.keymap.set({ 'n', }, '<leader>gmr', function() require 'config.git_gitsigns'.reset_buffer() end, M.opt 'reset_buffer')

vim.keymap.set({ 'n', }, 'gs', function() require 'config.git_gitsigns'.stage_hunk() end, M.opt 'stage_hunk')
vim.keymap.set({ 'n', }, '<leader>gs', function() require 'config.git_gitsigns'.stage_hunk() end, M.opt 'stage_hunk')
vim.keymap.set({ 'v', }, 'gs', function() require 'config.git_gitsigns'.stage_hunk_v() end, M.opt 'stage_hunk_v')
vim.keymap.set({ 'v', }, '<leader>gs', function() require 'config.git_gitsigns'.stage_hunk_v() end, M.opt 'stage_hunk_v')

vim.keymap.set({ 'n', }, '<leader>gms', function() require 'config.git_gitsigns'.stage_buffer() end, M.opt 'stage_buffer')
vim.keymap.set({ 'n', }, '<leader>gu', function() require 'config.git_gitsigns'.undo_stage_hunk() end, M.opt 'undo_stage_hunk')
vim.keymap.set({ 'n', }, '<leader>gmb', function() require 'config.git_gitsigns'.blame_line() end, M.opt 'blame_line')
vim.keymap.set({ 'n', }, '<leader>gmp', function() require 'config.git_gitsigns'.preview_hunk() end, M.opt 'preview_hunk')

vim.keymap.set({ 'n', }, '<leader>gmtb', function() require 'config.git_gitsigns'.toggle_current_line_blame() end, M.opt 'toggle_current_line_blame')
vim.keymap.set({ 'n', }, '<leader>gmtd', function() require 'config.git_gitsigns'.toggle_deleted() end, M.opt 'toggle_deleted')
vim.keymap.set({ 'n', }, '<leader>gmtl', function() require 'config.git_gitsigns'.toggle_linehl() end, M.opt 'toggle_linehl')
vim.keymap.set({ 'n', }, '<leader>gmtn', function() require 'config.git_gitsigns'.toggle_numhl() end, M.opt 'toggle_numhl')
vim.keymap.set({ 'n', }, '<leader>gmts', function() require 'config.git_gitsigns'.toggle_signs() end, M.opt 'toggle_signs')
vim.keymap.set({ 'n', }, '<leader>gmtw', function() require 'config.git_gitsigns'.toggle_word_diff() end, M.opt 'toggle_word_diff')

vim.keymap.set({ 'n', }, 'gl', function() require 'config.git_gitsigns'.lazygit() end, M.opt 'lazygit')
vim.keymap.set({ 'n', }, '<leader>gl', function() require 'config.git_gitsigns'.lazygit() end, M.opt 'lazygit')

------

B.register_whichkey('config.git_gitsigns', '<leader>gm', 'more')
B.register_whichkey('config.git_gitsigns', '<leader>gmt', 'Toggle')

B.merge_whichkeys()

-------------------

vim.keymap.set('n', '<leader>j', function()
  if vim.wo.diff then
    return ']c'
  end
  vim.schedule(function()
    require 'gitsigns'.next_hunk()
  end)
  return '<Ignore>'
end, { expr = true, desc = 'Gitsigns next_hunk', })

vim.keymap.set('n', '<leader>k', function()
  if vim.wo.diff then
    return '[c'
  end
  vim.schedule(function()
    require 'gitsigns'.prev_hunk()
  end)
  return '<Ignore>'
end, { expr = true, desc = 'Gitsigns prev_hunk', })

require 'gitsigns'.setup {
  signs                        = {
    add = { text = '+', },
    change = { text = '~', },
    delete = { text = '_', },
    topdelete = { text = '‾', },
    changedelete = { text = '', },
    untracked = { text = '?', },
  },
  signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl                        = true,  -- Toggle with `:Gitsigns toggle_numhl`
  linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir                 = {
    follow_files = true,
  },
  attach_to_untracked          = true,
  current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority                = 100,
  update_debounce              = 100,
  status_formatter             = nil,   -- Use default
  max_file_length              = 40000, -- Disable if file is longer than this (in lines)
  preview_config               = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1,
  },
  yadm                         = {
    enable = false,
  },
}

return M
