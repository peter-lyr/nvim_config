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

M.start = function()
  require 'which-key'.setup {}
  require 'which-key'.register(M.mappings)
end

vim.fn.timer_start(100, M.start)

return M
