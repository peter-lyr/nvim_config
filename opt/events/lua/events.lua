local M = {}
local B = require 'my_base'
M.source = debug.getinfo(1)['source']
package.loaded[B.get_loaded(M.source)] = nil
--------------------------------------------

-- Highlight on yank
B.aucmd(M.source, 'TextYankPost', 'TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- go to last loc when opening a buffer
B.aucmd(M.source, 'BufReadPost', 'BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
B.aucmd(M.source, 'BufWritePre', { 'BufWritePre', }, {
  callback = function(event)
    if event.match:match '^%w%w+://' then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})


-- close some filetypes with <q>
B.aucmd(M.source, 'FileType', 'FileType', {
  pattern = {
    'lazy',
    'help',
    'lspinfo',
    'man',
    'mason',
    'git',
    'notify',
    'fugitive',
    'fugitiveblame',
    'qf',
    'spectre_panel',
    'startuptime',
    'checkhealth',
  },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.loop.new_timer():start(30, 0, function()
      vim.schedule(function()
        vim.keymap.set('n', 'q', function()
          pcall(vim.cmd, 'close')
        end, { buffer = ev.buf, nowait = true, silent = true, })
        vim.keymap.set('n', '<esc>', function()
          pcall(vim.cmd, 'close')
        end, { buffer = ev.buf, nowait = true, silent = true, })
      end)
    end)
  end,
})

B.aucmd(M.source, 'VimLeave', 'VimLeave', {
  callback = function()
    if vim.fn.exists 'g:GuiLoaded' and vim.g.GuiLoaded == 1 then
      if vim.g.GuiWindowMaximized == 1 then
        vim.fn['GuiWindowMaximized'](0)
      end
      if vim.g.GuiWindowFrameless == 1 then
        vim.fn['GuiWindowFrameless'](0)
        vim.loop.new_timer():start(10, 0, function()
          vim.schedule(function()
            vim.fn['GuiWindowFrameless'](0)
          end)
        end)
      end
    end
  end,
})

local tab_4_fts = {
  'c', 'cpp',
  'python',
  'ld',
}

B.aucmd(M.source, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    if vim.fn.filereadable(ev.file) == 1 and vim.o.modifiable == true then
      vim.opt.cursorcolumn = true
      vim.opt.signcolumn   = 'auto:1'
    end
    vim.opt.mouse = 'a'
    if vim.tbl_contains(tab_4_fts, vim.opt.filetype:get()) == true then
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
    else
      vim.opt.tabstop = 2
      vim.opt.softtabstop = 2
      vim.opt.shiftwidth = 2
    end
    local buftype = vim.api.nvim_buf_get_option(ev.buf, 'buftype')
    if vim.fn.bufname() == '' and byftype == '' then
      vim.api.nvim_buf_set_option(ev.buf, 'buftype', 'nofile') -- for [No Name] buffers
    end
    if buftype == 'nofile' and vim.fn.bufname() == '' then
      vim.cmd 'setlocal signcolumn=no' -- for lsp hover
    elseif buftype == 'help' then
      vim.cmd [[
        setlocal nu
        setlocal iskeyword=@,48-57,_,192-255
        setlocal conceallevel=0
      ]]
    end
  end,
})

B.aucmd(M.source, 'BufLeave', 'BufLeave', {
  callback = function()
    vim.opt.cursorcolumn = false
  end,
})

-- B.aucmd(M.source, 'BufReadPost-2', 'BufReadPost', {
--   callback = function()
--     pcall(vim.cmd, 'retab')
--     pcall(vim.cmd, [[silent %s/\s\+$//]])
--     pcall(vim.cmd, 'silent w!')
--   end,
-- })

return M
