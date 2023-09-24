local M = {}

M.MinimapUpdateHighlight_timer = 0
M.last_rescan_file = ''
M.opened = nil

pcall(vim.api.nvim_del_autocmd, vim.g.minimap_au_bufenter)

vim.g.minimap_au_bufenter = vim.api.nvim_create_autocmd('BufEnter', {
  callback = function(ev)
    if M.last_rescan_file ~= ev.file and vim.fn.filereadable(ev.file) == 1 then
      if M.MinimapUpdateHighlight_timer ~= 0 then
        M.MinimapUpdateHighlight_timer:stop()
      end
      M.MinimapUpdateHighlight_timer = vim.loop.new_timer()
      M.MinimapUpdateHighlight_timer:start(300, 0, function()
        vim.schedule(function()
          M.last_rescan_file = ev.file
          pcall(vim.cmd, 'MinimapUpdateHighlight')
          M.MinimapUpdateHighlight_timer = 0
        end)
      end)
    elseif vim.api.nvim_buf_get_option(ev.buf, 'filetype') == 'minimap' then
      vim.opt.cursorcolumn = false
      if vim.g.minimap_width ~= vim.opt.winwidth:get() then
        vim.cmd '999wincmd <'
        vim.api.nvim_win_set_width(0, vim.g.minimap_width)
      end
    end
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.minimap_au_tableave_1)

vim.g.minimap_au_tableave_1 = vim.api.nvim_create_autocmd({ 'TabLeave', }, {
  callback = function()
    vim.cmd 'MinimapClose'
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.minimap_au_tabenter_1)

vim.g.minimap_au_tabenter_1 = vim.api.nvim_create_autocmd({ 'TabEnter', }, {
  callback = function()
    if M.opened then
      vim.cmd 'Minimap'
    end
  end,
})

M.open = function()
  vim.cmd 'Minimap'
  M.opened = 1
end

M.close = function()
  vim.cmd 'MinimapClose'
  M.opened = nil
end

return M
