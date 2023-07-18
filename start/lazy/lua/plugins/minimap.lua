return {
  'wfxr/minimap.vim',
  lazy = true,
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "Minimap", },
  keys = {
    {
      '<leader><leader><tab>',
      function()
        if vim.g.loaded_minimap then
          if vim.fn.buflisted(vim.fn.bufnr()) == 0 then
            if vim.g.lastbufwinid ~= -1 then
              vim.fn.win_gotoid(vim.g.lastbufwinid)
            else
              return
            end
          end
          if vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) == 1 then
            local winnr = vim.fn.bufwinnr('-MINIMAP-')
            if winnr == -1 then
              vim.cmd('Minimap')
              vim.loop.new_timer():start(50, 0, function()
                vim.schedule(function()
                  winnr = vim.fn.bufwinnr('-MINIMAP-')
                  if winnr ~= -1 then
                    vim.cmd([[
                      try
                        MinimapRefresh
                      catch
                      endtry
                    ]])
                    pcall(vim.fn.win_gotoid, vim.fn.win_getid(winnr))
                  end
                end)
              end)
            else
              pcall(vim.fn.win_gotoid, vim.fn.win_getid(winnr))
            end
          end
        end
      end,
      mode = { 'n', 'v' },
      desc = 'Minimap'
    },
    {
      '<leader>#',
      function()
        vim.g.minimap_autostart = 1 - vim.g.minimap_autostart
        if vim.g.minimap_autostart == 1 then
          print('minimap autostart')
        else
          print('minimap donot autostart')
        end
      end,
      mode = { 'n', 'v' },
      desc = 'Minimap'
    },
  },
  dependencies = {
    require('plugins.edgy'),
    'wfxr/code-minimap',
  },
  init = function()
    vim.g.minimap_width = 30
    vim.g.minimap_block_filetypes = { 'aerial', 'NvimTree', 'fugitive', 'help', }
  end,
  config = function()
    if vim.g.loaded_minimap then
      vim.g.minimap_autostart = 0
      vim.api.nvim_create_autocmd({ "WinClosed", }, {
        callback = function()
          if vim.fn.bufnr() == vim.fn.bufnr('-MINIMAP-') then
            if vim.fn.expand('<afile>') == tostring(vim.fn.win_getid()) then
              vim.cmd('MinimapClose')
            end
          end
        end,
      })
      local rescanned_bufnr = 0
      vim.api.nvim_create_autocmd({ "CursorHold", }, {
        callback = function()
          local bufnr = vim.fn.bufnr()
          if rescanned_bufnr ~= bufnr then
            rescanned_bufnr = bufnr
            vim.cmd([[
              try
                MinimapRescan
              catch
              endtry
            ]])
          end
        end,
      })
      local minimap_rescan_allow = 1
      local lastbufnr = 0
      vim.api.nvim_create_autocmd({ "BufEnter", }, {
        callback = function(ev)
          if vim.g.minimap_autostart == 1 and lastbufnr ~= ev.buf and #ev.file > 0 and ev.buf ~= vim.fn.bufnr('-MINIMAP-') and vim.api.nvim_buf_get_option(ev.buf, 'buftype') ~= 'nofile' then
            -- print(ev.buf, ev.file, vim.api.nvim_buf_get_option(ev.buf, 'buftype'), '|', vim.api.nvim_buf_get_option(ev.buf, 'filetype'))
            lastbufnr = ev.buf
            local bufnr = vim.fn.bufnr('-MINIMAP-')
            if bufnr == -1 then
              vim.loop.new_timer():start(10, 0, function()
                vim.schedule(function()
                  vim.cmd('Minimap')
                end)
              end)
            end
            vim.loop.new_timer():start(300, 0, function()
              vim.schedule(function()
                if minimap_rescan_allow == 1 and lastbufnr == vim.fn.bufnr() then
                  minimap_rescan_allow = 0
                  if vim.fn.bufnr() ~= vim.fn.bufnr('-MINIMAP-') then
                    vim.cmd([[
                    try
                      MinimapRefresh
                    catch
                    endtry
                    ]])
                  end
                  vim.loop.new_timer():start(5000, 0, function()
                    vim.schedule(function()
                      minimap_rescan_allow = 1
                    end)
                  end)
                end
              end)
            end)
          end
        end,
      })
      vim.api.nvim_create_autocmd({ "TabLeave", }, {
        callback = function()
          vim.cmd('MinimapClose')
        end,
      })
      local minimap_rescan_allow2 = 1
      vim.api.nvim_create_autocmd({ "VimResized", }, {
        callback = function()
          if minimap_rescan_allow2 == 1 then
            minimap_rescan_allow2 = 0
            vim.loop.new_timer():start(800, 0, function()
              vim.schedule(function()
                vim.cmd('MinimapRefresh')
              end)
            end)
            vim.loop.new_timer():start(1800, 0, function()
              vim.schedule(function()
                minimap_rescan_allow2 = 1
              end)
            end)
          end
        end,
      })
    end
  end
}
