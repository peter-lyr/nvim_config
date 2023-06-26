if vim.fn.exists('g:GuiLoaded') and vim.g.GuiLoaded == 1 then
  vim.api.nvim_create_autocmd({ "VimEnter", }, {
    callback = function()
      vim.loop.new_timer():start(10, 0, function()
        vim.schedule(function()
          vim.fn['GuiWindowFrameless'](1)
        end)
      end)
    end,
  })
end
