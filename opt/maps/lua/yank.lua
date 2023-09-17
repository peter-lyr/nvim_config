local M = {}

M.fname = function()
  vim.cmd [[
    let @+ = expand("%:t")
    echo expand("%:t")
  ]]
end

M.absfname = function()
  vim.cmd [[
    let @+ = substitute(nvim_buf_get_name(0), "/", "\\\\", "g")
    echo substitute(nvim_buf_get_name(0), "/", "\\\\", "g")
  ]]
end

M.cwd = function()
  vim.cmd [[
    let @+ = substitute(getcwd(), "/", "\\\\", "g")
    echo substitute(getcwd(), "/", "\\\\", "g")
  ]]
end

return M
