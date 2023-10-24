local S = {}

S.mappings = {}

function S.load_require(plugin, lua)
  vim.cmd('Lazy load ' .. string.match(plugin, '/*([^/]+)$'))
  if not package.loaded[lua] then
    vim.cmd(string.format('lua require"%s"', lua))
  end
end

function S.wkey(key, plugin, map, desc)
  desc = desc and map .. '_' .. desc or map
  if vim.tbl_contains(vim.tbl_keys(S.mappings), key) == false then
    S.mappings[key] = { { plugin, map, desc, }, }
  else
    S.mappings[key][#S.mappings[key] + 1] = { plugin, map, desc, }
  end
  local new_desc = {}
  for _, val in ipairs(S.mappings[key]) do
    new_desc[#new_desc + 1] = val[3]
  end
  desc = vim.fn.join(new_desc, ' ')
  vim.keymap.set({ 'n', 'v', }, key, function()
    if not package.loaded['config.whichkey'] then
      vim.cmd 'Lazy load which-key.nvim'
    end
    for _, pm in ipairs(S.mappings[key]) do
      S.load_require(pm[1], string.format('map.%s', pm[2]))
    end
    key = string.gsub(key, '<leader>', '<space>')
    vim.keymap.del({ 'n', 'v', }, key)
    vim.cmd('WhichKey ' .. key)
  end, { silent = true, desc = desc, })
end

return S
