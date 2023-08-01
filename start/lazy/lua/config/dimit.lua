local M = {}

local dimit = require("dimit")

dimit.setup({
  bgcolor = "#000000",
})

if dimit.autocmd ~= nil then
  vim.api.nvim_del_autocmd(dimit.autocmd)
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "WinClosed" }, {
  callback = function()
    vim.schedule(function()
      if not string.match(vim.bo.ft, "aerial") then
        dimit.dim_inactive()
      end
    end)
  end,
})

return M
