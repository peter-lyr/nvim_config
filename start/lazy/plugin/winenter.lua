vim.api.nvim_create_autocmd({ "VimEnter", }, {
  callback = function()
    vim.loop.new_timer():start(10, 0, function()
      vim.schedule(function()
        vim.fn['GuiWindowFrameless'](1)
      end)
    end)
  end,
})
