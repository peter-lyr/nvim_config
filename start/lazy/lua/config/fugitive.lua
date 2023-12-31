local rescanned_bufnr = 0

pcall(vim.api.nvim_del_autocmd, vim.g.fugitive_au_cursorhold)

vim.g.fugitive_au_cursorhold = vim.api.nvim_create_autocmd({ 'CursorHold', }, {
  callback = function(ev)
    if vim.g.edgy_autosize_en == 1 and rescanned_bufnr ~= ev.buf then
      rescanned_bufnr = ev.buf
      if vim.bo[ev.buf].ft == 'fugitive' then
        local width = 0
        local height = math.min(vim.fn.line '$', vim.opt.lines:get() - 6)
        for linenr = 2, height do
          local len = vim.fn.strdisplaywidth(vim.fn.getline(linenr))
          if len > width then
            width = len
          end
        end
        local win = require 'edgy.editor'.get_win()
        if not win then
          return
        end
        local save_cursor = vim.fn.getpos '.'
        local width_en = nil
        local height_en = nil
        if width - win.width + 6 > 0 then
          width_en = 1
        end
        if height - win.height + 6 > 0 then
          height_en = 1
        end
        if height_en then
          win:resize('height', (height - win.height) * 2 + 6)
        end
        if width_en then
          win:resize('width', width - win.width + 6)
        end
        if width_en or height_en then
          pcall(vim.fn.setpos, '.', save_cursor)
          vim.fn.timer_start(100, function()
            vim.cmd 'norm 99zH'
            vim.cmd 'norm zb'
          end)
        end
      end
    end
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.fugitive_au_bufleave)

vim.g.fugitive_au_bufleave = vim.api.nvim_create_autocmd({ 'BufLeave', }, {
  callback = function(ev)
    rescanned_bufnr = ev.buf
    if vim.bo[ev.buf].ft == 'fugitive' then
      local save_cursor = vim.fn.getpos '.'
      if vim.g.edgy_autosize_en == 1 then
        local max = 0
        for linenr = 1, vim.fn.line '$' do
          local len = vim.fn.strdisplaywidth(vim.fn.getline(linenr))
          if len > max then
            max = len
          end
        end
        local win = require 'edgy.editor'.get_win()
        if win then
          win.view.edgebar:equalize()
        end
      end
      pcall(vim.fn.setpos, '.', save_cursor)
      vim.cmd 'norm zb'
    end
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.fugitive_au_bufenter)

vim.g.fugitive_au_bufenter = vim.api.nvim_create_autocmd({ 'BufEnter', }, {
  callback = function(ev)
    if vim.bo[ev.buf].ft == 'fugitive' then
      vim.keymap.set('n', 'da', require 'config.nvimtree-func'.edgy_autosize_toggle, { buffer = ev.buf, })
      vim.cmd [[
        setlocal sidescrolloff=0
      ]]
    end
  end,
})

local M = {}

M.open = function(refresh, root)
  local opened = false
  local bufnr = -1
  local bufname = ''
  for winnr = 1, vim.fn.winnr '$' do
    bufnr = vim.fn.winbufnr(winnr)
    local ft = vim.bo[bufnr].ft
    if ft == 'fugitive' then
      opened = true
      bufname = vim.api.nvim_buf_get_name(bufnr)
      break
    end
  end
  if opened then
    local curroot = root
    if not root then
      curroot = string.gsub(vim.fn.tolower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0))), '/', '\\')
    end
    local fugitiveroot = string.gsub(vim.fn.tolower(string.match(bufname, 'fugitive:\\\\\\(.+)\\.git\\\\')), '/', '\\')
    if curroot ~= fugitiveroot then
      vim.cmd('bw!' .. tostring(bufnr))
    elseif refresh then
      pcall(vim.call, 'fugitive#ReloadStatus')
    else
      vim.cmd 'Git'
    end
  else
    if not refresh then
      vim.cmd 'Git'
    end
  end
end

-- pcall(vim.api.nvim_del_autocmd, vim.g.fugitive_au_bufwritepost)
--
-- vim.g.fugitive_au_bufwritepost = vim.api.nvim_create_autocmd({ "BufWritePost", }, {
--   callback = function()
--     M.open(1)
--   end,
-- })

require 'maps'.add('<F5>', 'n', function()
  pcall(vim.call, 'fugitive#ReloadStatus')
end, 'futigive status fresh')

return M
