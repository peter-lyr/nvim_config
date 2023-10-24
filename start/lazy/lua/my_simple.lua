local S = {}

S.mappings = {}

function S.load_require(plugin, lua)
  vim.cmd('Lazy load ' .. string.match(plugin, '/*([^/]+)$'))
  if lua and not package.loaded[lua] then
    vim.cmd(string.format('lua require"%s"', lua))
  end
end

function S.wkey(key, plugin, map, desc)
  desc = desc and map .. '_' .. desc or map
  key = vim.fn.tolower(key)
  if vim.tbl_contains(vim.tbl_keys(S.mappings), key) == false then
    S.mappings[key] = { { plugin, map, desc, }, }
  else
    S.mappings[key][#S.mappings[key] + 1] = { plugin, map, desc, }
  end
end

function S.map()
  for key, vals in pairs(S.mappings) do
    local new_desc = {}
    for _, val in ipairs(vals) do
      new_desc[#new_desc + 1] = val[3]
    end
    local desc = vim.fn.join(new_desc, ' ')
    vim.keymap.set({ 'n', 'v', }, key, function()
      if not package.loaded['config.whichkey'] then
        vim.cmd 'Lazy load which-key.nvim'
      end
      for _, val in ipairs(vals) do
        S.load_require(val[1], string.format('map.%s', val[2]))
      end
      key = string.gsub(key, '<leader>', '<space>')
      vim.keymap.del({ 'n', 'v', }, key)
      vim.cmd('WhichKey ' .. key)
    end, { silent = true, desc = desc, })
  end
end

vim.api.nvim_create_autocmd('VimEnter', { callback = S.map, })

---------------------------------

function S.get_opt_dir(dir)
  return vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\' .. dir
end

return S
