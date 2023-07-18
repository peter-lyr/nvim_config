local rescanned_bufnr = 0

vim.api.nvim_create_autocmd({ "CursorHold", }, {
  callback = function(ev)
    if rescanned_bufnr ~= ev.buf then
      rescanned_bufnr = ev.buf
    if vim.bo[ev.buf].ft == 'fugitive' then
        local width = 0
        local height = math.min(vim.fn.line('$'), vim.opt.lines:get() - 6)
        for linenr = 2, height do
          local len = vim.fn.strdisplaywidth(vim.fn.getline(linenr))
          if len > width then
            width = len
          end
        end
        local win = require("edgy.editor").get_win()
        if not win then
          return
        end
        local curline = vim.fn.line('.')
        local curcol = vim.fn.col('.')
        if width - win.width + 6 > 0 then
          win:resize("width", width - win.width + 6)
        end
        if height - win.height > 0 then
          win:resize("height", height - win.height)
        end
        vim.cmd(string.format("norm %dgg%d|", curline, curcol))
        vim.cmd("norm 99zH")
      end
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", }, {
  callback = function(ev)
    rescanned_bufnr = ev.buf
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

vim.api.nvim_create_autocmd({ "BufEnter", }, {
  callback = function(ev)
    if vim.bo[ev.buf].ft == 'fugitive' then
      vim.cmd([[
        setlocal sidescrolloff=0
      ]])
    end
  end,
})
