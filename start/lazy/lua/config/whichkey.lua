local M = {}

M.mappings = {}

M.add = function(mapping)
  for key, val in pairs(mapping) do
    if vim.tbl_contains(vim.tbl_keys(M.mappings), key) == true then
      local new = M.mappings[key]['name']
      local old = val['name']
      if old ~= new then
        M.mappings[key] = { name = new .. ' ' .. old, }
      end
    else
      M.mappings[key] = val
    end
  end
end

vim.api.nvim_create_autocmd({ 'VimEnter', }, {
  callback = function()
    require 'which-key'.register(M.mappings)
  end,
})

return M
