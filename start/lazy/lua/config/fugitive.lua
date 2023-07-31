local rescanned_bufnr = 0

pcall(vim.api.nvim_del_autocmd, vim.g.fugitive_au_cursorhold)

vim.g.fugitive_au_cursorhold = vim.api.nvim_create_autocmd({ "CursorHold", }, {
  callback = function(ev)
    if vim.g.edgy_autosize_en == 1 and rescanned_bufnr ~= ev.buf then
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

pcall(vim.api.nvim_del_autocmd, vim.g.fugitive_au_bufleave)

vim.g.fugitive_au_bufleave = vim.api.nvim_create_autocmd({ "BufLeave", }, {
  callback = function(ev)
    rescanned_bufnr = ev.buf
    if vim.g.edgy_autosize_en == 1 and vim.bo[ev.buf].ft == 'fugitive' then
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

pcall(vim.api.nvim_del_autocmd, vim.g.fugitive_au_bufenter)

vim.g.fugitive_au_bufenter = vim.api.nvim_create_autocmd({ "BufEnter", }, {
  callback = function(ev)
    if vim.bo[ev.buf].ft == 'fugitive' then
      vim.keymap.set('n', 'da', require('config.nvimtree-func').edgy_autosize_toggle, { buffer = ev.buf })
      vim.cmd([[
        setlocal sidescrolloff=0
      ]])
    end
  end,
})

local M = {}

M.open = function(refresh)
  local opened = false
  local bufnr = -1
  local bufname = ''
  for winnr = 1, vim.fn.winnr('$') do
    bufnr = vim.fn.winbufnr(winnr)
    local ft = vim.bo[bufnr].ft
    if ft == 'fugitive' then
      opened = true
      bufname = vim.api.nvim_buf_get_name(bufnr)
      break
    end
  end
  if opened then
    local curroot = string.gsub(vim.fn.tolower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0))), '/', '\\')
    local fugitiveroot = string.gsub(vim.fn.tolower(string.match(bufname, 'fugitive:\\\\\\(.+)\\.git\\\\')), '/', '\\')
    if curroot ~= fugitiveroot then
      vim.cmd('bw!' .. tostring(bufnr))
    elseif refresh then
      pcall(vim.call, 'fugitive#ReloadStatus')
    else
      vim.cmd('Git')
    end
  else
    if not refresh then
      vim.cmd('Git')
    end
  end
end

pcall(vim.api.nvim_del_autocmd, vim.g.fugitive_au_bufwritepost)

vim.g.fugitive_au_bufwritepost = vim.api.nvim_create_autocmd({ "BufWritePost", }, {
  callback = function()
    M.open(1)
  end,
})

return M
