return {
  'wfxr/minimap.vim',
  lazy = true,
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "Minimap", },
  keys = {
    { '<leader>4', function()
      if vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) == 1 then
        vim.cmd('Minimap')
        vim.loop.new_timer():start(50, 0, function()
          vim.schedule(function()
            local winnr = vim.fn.bufwinnr('-MINIMAP-')
            if winnr ~= -1 then
              vim.cmd('MinimapRescan')
              pcall(vim.fn.win_gotoid, vim.fn.win_getid(winnr))
            end
          end)
        end)
      end
    end, mode = { 'n', 'v' }, desc = 'Minimap' },
  },
  dependencies = {
    'wfxr/code-minimap',
  },
  init = function()
    vim.g.minimap_width = 30
  end,
  config = function()
    vim.api.nvim_create_autocmd({ "WinClosed", }, {
      callback = function()
        if vim.fn.bufnr() == vim.fn.bufnr('-MINIMAP-') then
          vim.g.minimap_opening = 1
        end
      end,
    })
  end
}
