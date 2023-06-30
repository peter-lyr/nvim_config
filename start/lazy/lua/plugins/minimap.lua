return {
  'wfxr/minimap.vim',
  lazy = true,
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "Minimap", },
  keys = {
    { '<leader>4', function()
      vim.cmd('Minimap')
      vim.loop.new_timer():start(50, 0, function()
        vim.schedule(function()
          local bufnr = vim.fn.bufnr('-MINIMAP-')
          local winnr = vim.fn.bufwinnr('-MINIMAP-')
          if winnr ~= -1 then
            vim.cmd('MinimapRescan')
            vim.fn.win_gotoid(vim.fn.win_getid(winnr))
            vim.keymap.set({ 'n', 'v', }, 'q', '<cmd>wincmd p<cr>', { desc = 'enter', buffer = bufnr })
          end
        end)
      end)
    end, mode = { 'n', 'v' }, desc = 'Minimap' },
  },
  dependencies = {
    'wfxr/code-minimap',
  },
  init = function()
    vim.g.minimap_width = 30
  end
}
