local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
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

function M.next_hunk()
  if vim.wo.diff then
    return ']c'
  end
  vim.schedule(function()
    require 'gitsigns'.next_hunk()
  end)
  return '<Ignore>'
end

function M.prev_hunk()
  if vim.wo.diff then
    return '[c'
  end
  vim.schedule(function()
    require 'gitsigns'.prev_hunk()
  end)
  return '<Ignore>'
end

function M.stage_hunk()
  require 'gitsigns'.stage_hunk()
end

function M.stage_hunk_v()
  require 'gitsigns'.stage_hunk { vim.fn.line '.', vim.fn.line 'v', }
end

function M.stage_buffer()
  require 'gitsigns'.stage_buffer()
end

function M.undo_stage_hunk()
  require 'gitsigns'.undo_stage_hunk()
end

function M.reset_hunk()
  require 'gitsigns'.reset_hunk()
end

function M.reset_hunk_v()
  require 'gitsigns'.reset_hunk { vim.fn.line '.', vim.fn.line 'v', }
end

function M.reset_buffer()
  require 'gitsigns'.reset_buffer()
end

function M.preview_hunk()
  require 'gitsigns'.preview_hunk()
end

function M.blame_line()
  require 'gitsigns'.blame_line { full = true, }
end

function M.diffthis()
  require 'gitsigns'.diffthis()
end

function M.diffthis_l()
  require 'gitsigns'.diffthis '~'
end

function M.toggle_current_line_blame()
  require 'gitsigns'.toggle_current_line_blame()
end

function M.toggle_deleted()
  require 'gitsigns'.toggle_deleted()
end

function M.toggle_numhl()
  require 'gitsigns'.toggle_numhl()
end

function M.toggle_linehl()
  require 'gitsigns'.toggle_linehl()
end

function M.toggle_signs()
  require 'gitsigns'.toggle_signs()
end

function M.toggle_word_diff()
  local temp = require 'gitsigns'.toggle_word_diff()
  if temp == false then
    word_diff_en = 0
  else
    word_diff_en = 1
  end
end

------

function M.lazygit()
  B.system_run('start', 'lazygit')
end

return M
