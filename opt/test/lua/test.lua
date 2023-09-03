for winnr = 1, vim.fn.winnr '$' do
  -- print(winnr)
  local bufnr = vim.fn.winbufnr(winnr)
  -- print(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if vim.fn.filereadable(fname) == 1 then
    -- print(fname)
  end
  local winid = vim.fn.win_getid(winnr)
  -- print(winid)
  print(winnr, vim.fn.bufwinnr(bufnr))
end

local title = vim.fn.getqflist { title = 0, }.title
local l = {}
local L = vim.fn.getqflist()
local D = {}
for _, i in ipairs(L) do
  if vim.tbl_contains(D, i.text) == false then
    i.text = vim.fn.trim(i.text)
    D[#D + 1] = i.text
    l[#l + 1] = i
  end
end
vim.fn.setqflist(l, 'r')
vim.fn.setqflist({}, 'a', { title = title, })
