local S = {}

function S.get_opt_dir(dir)
  local opt = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\'
  return opt .. dir
end

return S
