local curline = 0
local curcol = 0

vim.api.nvim_create_autocmd({ "BufEnter", }, {
  callback = function(ev)
    if vim.bo[ev.buf].ft == 'fugitive' then
      local width = 0
      local height = math.min(vim.fn.line('$'), vim.opt.lines:get() - 6)
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
          if width - win.width + 6 > 0 then
            win:resize("width", width - win.width + 6)
          end
          if height - win.height > 0 then
            win:resize("height", height - win.height)
          end
          vim.loop.new_timer():start(50, 0, function()
            vim.schedule(function()
              vim.cmd(string.format("norm %dgg%d|", curline, curcol))
              vim.cmd("norm 99zH")
              vim.cmd("norm zb")
            end)
          end)
        end)
      end)
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", }, {
  callback = function(ev)
    if vim.bo[ev.buf].ft == 'fugitive' then
      local win = require("edgy.editor").get_win()
      curline = vim.fn.line('.')
      curcol = vim.fn.col('.')
      if win then
        win.view.edgebar:equalize()
        if vim.fn.line('$') == 3 then
          win:close()
        end
      end
    end
  end,
})
