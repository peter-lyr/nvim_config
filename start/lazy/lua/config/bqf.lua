local M = {}

local bqf = require "bqf"

local hi = function()
  vim.cmd [[
    hi BqfPreviewBorder guifg=#50a14f ctermfg=71
    hi link BqfPreviewRange Search
  ]]
end

hi()

pcall(vim.api.nvim_del_autocmd, vim.g.bqf_au_bufenter)

vim.g.bqf_au_bufenter = vim.api.nvim_create_autocmd({ 'BufEnter', }, {
  callback = function()
    if vim.bo.ft == 'qf' then
      if string.match(vim.fn.getline(1), 'mingw32%-make') then
        bqf.disable()
      else
        bqf.enable()
      end
    end
  end,
})

vim.api.nvim_create_autocmd({ 'ColorScheme', }, {
  callback = function()
    hi()
  end,
})

bqf.setup {
  auto_resize_height = true,
  preview = {
    win_height = 50,
    win_vheight = 50,
    wrap = true,
  },
}

local is_copened = function()
  for i = 1, vim.fn.winnr '$' do
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
      vim.cmd 'wincmd p'
      vim.loop.new_timer():start(10, 0, function()
        vim.schedule(function()
          if vim.b[vim.fn.bufnr()].neo_tree_source == "git_status" then
            vim.cmd 'wincmd l'
          elseif vim.b[vim.fn.bufnr()].source_buffer then
            vim.cmd 'wincmd h'
          end
        end)
      end)
    end
    vim.cmd 'ccl'
  else
    vim.cmd 'copen'
  end
end

return M
