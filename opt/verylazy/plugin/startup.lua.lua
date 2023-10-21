if vim.fn.exists 'g:GuiLoaded' and vim.g.GuiLoaded == 1 then
  vim.loop.new_timer():start(10, 0, function()
    vim.schedule(function()
      vim.fn['GuiWindowFrameless'](1)
    end)
  end)
end
