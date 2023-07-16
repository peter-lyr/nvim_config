vim.api.nvim_create_autocmd({ "BufEnter", }, {
  callback = function(ev)
    if vim.bo[ev.buf].ft == 'fugitive' then
      local width = 0
      local height = vim.fn.line('$')
      for linenr = 1, height do
        local len = vim.fn.strdisplaywidth(vim.fn.getline(linenr))
        if len > width then
          width = len
        end
      end
      vim.loop.new_timer():start(50, 0, function()
        vim.schedule(function()
          local win = require("edgy.editor").get_win()
          if not win then
            return
          end
          if width - win.width + 4 > 0 then
            win:resize("width", width - win.width + 4)
          end
          if height - win.height > 0 then
            win:resize("height", height - win.height)
          end
        end)
      end)
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", }, {
  callback = function(ev)
    if vim.bo[ev.buf].ft == 'fugitive' then
      local max = 0
      for linenr = 1, vim.fn.line('$') do
        local len = vim.fn.strdisplaywidth(vim.fn.getline(linenr))
        if len > max then
          max = len
        end
      end
      local win = require("edgy.editor").get_win()
      if win then
        win.view.edgebar:equalize()
      end
    end
  end,
})
