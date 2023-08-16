for winnr=1, vim.fn.winnr('$') do
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
