local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

local word_diff_en = 1
local word_diff = 1
local moving = nil

B.aucmd(M.source, 'InsertEnter', { 'InsertEnter', 'CursorMoved', }, {
  callback = function()
    moving = 1
    if word_diff then
      word_diff = require 'gitsigns'.toggle_word_diff(nil)
    end
  end,
})

B.aucmd(M.source, 'CursorHold', { 'CursorHold', }, {
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
end

M.stage_hunk_v = function()
  require 'gitsigns'.stage_hunk { vim.fn.line '.', vim.fn.line 'v', }
end

M.stage_buffer = function()
  require 'gitsigns'.stage_buffer()
end

M.undo_stage_hunk = function()
  require 'gitsigns'.undo_stage_hunk()
end

M.reset_hunk = function()
  require 'gitsigns'.reset_hunk()
end

M.reset_hunk_v = function()
  require 'gitsigns'.reset_hunk { vim.fn.line '.', vim.fn.line 'v', }
end

M.reset_buffer = function()
  require 'gitsigns'.reset_buffer()
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
