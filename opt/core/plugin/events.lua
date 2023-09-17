local tab_4_fts = {
  'c', 'cpp',
  'python',
  'ld',
}

pcall(vim.api.nvim_del_autocmd, vim.g.events_au_bufenter)

vim.g.events_au_bufenter = vim.api.nvim_create_autocmd({ 'BufEnter', }, {
  callback = function(ev)
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
      vim.api.nvim_buf_set_option(ev.buf, 'buftype', 'nofile')
    end
    if buftype == 'nofile' then
      vim.cmd 'setlocal signcolumn=no'
    elseif buftype == 'help' then
      vim.cmd 'setlocal nu'
    end
  end,
})

-- vim.api.nvim_create_autocmd({ 'VimEnter', }, {
--   callback = function()
--     if vim.fn.exists 'g:GuiLoaded' and vim.g.GuiLoaded == 1 then
--       vim.loop.new_timer():start(10, 0, function()
--         vim.schedule(function()
--           vim.fn['GuiWindowFrameless'](1)
--         end)
--       end)
--     end
--   end,
-- })
-- 
-- vim.api.nvim_create_autocmd({ 'VimLeave', }, {
--   callback = function()
--     if vim.fn.exists 'g:GuiLoaded' and vim.g.GuiLoaded == 1 then
--       if vim.g.GuiWindowMaximized == 1 then
--         vim.fn['GuiWindowMaximized'](0)
--       end
--       if vim.g.GuiWindowFrameless == 1 then
--         vim.fn['GuiWindowFrameless'](0)
--         vim.loop.new_timer():start(10, 0, function()
--           vim.schedule(function()
--             vim.fn['GuiWindowFrameless'](0)
--           end)
--         end)
--       end
--     end
--   end,
-- })

local function augroup(name)
  return vim.api.nvim_create_augroup('events_' .. name, { clear = true, })
end

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup 'highlight_yank',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup 'last_loc',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre', }, {
  group = augroup 'auto_create_dir',
  callback = function(event)
    if event.match:match '^%w%w+://' then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})
