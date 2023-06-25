local M = {}

local hi = function()
  vim.cmd([[
    hi BqfPreviewBorder guifg=#50a14f ctermfg=71
    hi link BqfPreviewRange Search
  ]])
end

hi()

vim.api.nvim_create_autocmd({ 'ColorScheme', }, {
  callback = function()
    hi()
  end,
})

require("bqf").setup({
  auto_resize_height = true,
  preview = {
    win_height = 50,
    win_vheight = 50,
    wrap = true,
  },
})

local is_copened = function()
  for i = 1, vim.fn.winnr('$') do
    local bnum = vim.fn.winbufnr(i)
    if vim.fn.getbufvar(bnum, '&buftype') == 'quickfix' then
      return 1
    end
  end
  return nil
end

M.toggle = function()
  if is_copened() then
    if vim.bo.ft == 'qf' then
      vim.cmd('wincmd p')
      vim.loop.new_timer():start(10, 0, function()
        vim.schedule(function()
          if vim.bo.ft == 'neo-tree' then
            vim.cmd('wincmd l')
          end
        end)
      end)
    end
    vim.cmd('ccl')
  else
    vim.cmd('copen')
    vim.cmd('wincmd J')
  end
end

return M
