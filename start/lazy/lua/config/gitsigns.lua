require('gitsigns').setup {
  numhl     = true,
  linehl    = true,
  word_diff = true,

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', '<leader>j', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = 'Gitsigns next_hunk' })

    map('n', '<leader>k', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = 'Gitsigns prev_hunk' })

    -- Actions
    map('n', '<leader>gs', gs.stage_hunk, { desc = 'Gitsigns stage_hunk' })
    map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
    { desc = 'Gitsigns stage_hunk' })
    map('n', '<leader>gS', gs.stage_buffer, { desc = 'Gitsigns stage_buffer' })

    map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'Gitsigns undo_stage_hunk' })

    map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
    { desc = 'Gitsigns reset_hunk' })
    map('n', '<leader>gr', gs.reset_hunk, { desc = 'Gitsigns reset_hunk' })
    map('n', '<leader>gR', gs.reset_buffer, { desc = 'Gitsigns reset_buffer' })

    map('n', '<leader>gp', gs.preview_hunk, { desc = 'Gitsigns preview_hunk' })
    map('n', '<leader>gb', function() gs.blame_line { full = true } end, { desc = 'Gitsigns blame_line' })

    map('n', '<leader>gd', gs.diffthis, { desc = 'Gitsigns diffthis' })
    map('n', '<leader>gD', function() gs.diffthis('~') end, { desc = 'Gitsigns diffthis' })

    map('n', '<leader>gtb', gs.toggle_current_line_blame, { desc = 'Gitsigns toggle_current_line_blame' })
    map('n', '<leader>gtd', gs.toggle_deleted, { desc = 'Gitsigns toggle_deleted' })
    map('n', '<leader>gtn', gs.toggle_numhl, { desc = 'Gitsigns toggle_numhl' })
    map('n', '<leader>gtl', gs.toggle_linehl, { desc = 'Gitsigns toggle_linehl' })
    map('n', '<leader>gts', gs.toggle_signs, { desc = 'Gitsigns toggle_signs' })
    map('n', '<leader>gtw', gs.toggle_word_diff, { desc = 'Gitsigns toggle_word_diff' })

    -- Text object
    map({ 'o', 'x' }, 'ig', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Gitsigns select_hunk' })
  end
}
