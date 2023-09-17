local M = {}

M.explorer_cur = function()
  vim.fn.system(string.format([[start /b cmd /c "explorer "%s""]], vim.fn.substitute(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h'), '/', '\\\\', 'g')))
end

M.explorer_up = function()
  vim.fn.system [[start /b cmd /c "explorer .."]]
end

M.explorer_cwd = function()
  vim.fn.system(string.format([[start /b cmd /c "explorer "%s""]], vim.call 'ProjectRootGet'))
end

M.system_cur = function()
  local fname = vim.api.nvim_buf_get_name(0)
  local ext = string.match(fname, '%.([^.]+)$')
  if vim.tbl_contains({ 'exe', 'bat', }, ext) == true then
    vim.fn.system(string.format([[chcp 936 && start cmd /c "%s"]], fname))
  else
    vim.fn.system(string.format([[chcp 936 && start /min cmd /c "%s"]], fname))
  end
end

M.source_lua_vim = function()
  vim.cmd [[
    if (&ft == "vim" || &ft == "lua")
      source %:p
    endif
  ]]
end

return M
