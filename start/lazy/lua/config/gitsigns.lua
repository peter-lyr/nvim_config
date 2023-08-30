package.loaded['config.gitsigns'] = nil

local rf = function()
  require 'config.fugitive'.open(1)
end

require 'gitsigns'.setup {
  numhl     = true,
  linehl    = false,
  word_diff = true,

  signs     = {
    add = { text = '+', },
    change = { text = '~', },
    delete = { text = '_', },
    topdelete = { text = '‾', },
    changedelete = { text = '', },
    untracked = { text = '?', },
  },
  sign_priority = 100;
}

local word_diff_en = 1
local word_diff = 1
local moving = nil

pcall(vim.api.nvim_del_autocmd, vim.g.gitsigns_insertenter)

vim.g.gitsigns_insertenter = vim.api.nvim_create_autocmd({ 'InsertEnter', 'CursorMoved', }, {
  callback = function()
    moving = 1
    if word_diff then
      word_diff = require 'gitsigns'.toggle_word_diff(nil)
    end
  end,
})

require 'which-key'.register { ['<leader>gm'] = { name = 'Gitsigns', }, }

pcall(vim.api.nvim_del_autocmd, vim.g.gitsigns_insertleave)

vim.g.gitsigns_insertleave = vim.api.nvim_create_autocmd({ 'CursorHold', }, {
  callback = function()
    moving = nil
    vim.fn.timer_start(500, function()
      vim.schedule(function()
        if not moving then
          if word_diff_en == 1 then
            word_diff = require 'gitsigns'.toggle_word_diff(1)
          end
        end
      end)
    end)
  end,
})

M = {}

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

M.next_hunk = function()
  if vim.wo.diff then
    return ']c'
  end
  vim.schedule(function()
    require 'gitsigns'.next_hunk()
  end)
  return '<Ignore>'
end

M.prev_hunk = function()
  if vim.wo.diff then
    return '[c'
  end
  vim.schedule(function()
    require 'gitsigns'.prev_hunk()
  end)
  return '<Ignore>'
end

M.stage_hunk = function()
  require 'gitsigns'.stage_hunk()
  rf()
end

M.stage_hunk_v = function()
  require 'gitsigns'.stage_hunk { vim.fn.line '.', vim.fn.line 'v', }
end

M.stage_buffer = function()
  require 'gitsigns'.stage_buffer()
  rf()
end

M.undo_stage_hunk = function()
  require 'gitsigns'.undo_stage_hunk()
  rf()
end

M.reset_hunk = function()
  require 'gitsigns'.reset_hunk { vim.fn.line '.', vim.fn.line 'v', }
  rf()
end

M.reset_hunk_v = function()
  require 'gitsigns'.reset_hunk()
  rf()
end

M.reset_buffer = function()
  require 'gitsigns'.reset_buffer()
  rf()
end

M.preview_hunk = function()
  require 'gitsigns'.preview_hunk()
end

M.blame_line = function()
  require 'gitsigns'.blame_line { full = true, }
end

M.diffthis = function()
  require 'gitsigns'.diffthis()
end

M.diffthis_l = function()
  require 'gitsigns'.diffthis '~'
end

M.toggle_current_line_blame = function()
  require 'gitsigns'.toggle_current_line_blame()
end

M.toggle_deleted = function()
  require 'gitsigns'.toggle_deleted()
end

M.toggle_numhl = function()
  require 'gitsigns'.toggle_numhl()
end

M.toggle_linehl = function()
  require 'gitsigns'.toggle_linehl()
end

M.toggle_signs = function()
  require 'gitsigns'.toggle_signs()
end

M.toggle_word_diff = function()
  local temp = require 'gitsigns'.toggle_word_diff()
  if temp == false then
    word_diff_en = 0
  else
    word_diff_en = 1
  end
end

return M
