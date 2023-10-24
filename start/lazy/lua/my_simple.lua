local S = {}

function S.load_require(plugin, map)
  plugin = string.match(plugin, '%/*([^.]+)$')
  if not plugin then
    return
  end
  pcall(vim.cmd, 'Lazy load ' .. plugin)
  if map and not package.loaded['map.' .. map] then
    vim.cmd(string.format('lua require"map.%s"', map))
  else
    print('LUA REQUIRE"CONFIG".', map)
  end
end

print(debug.getinfo(1)['source'], '8888')

if not S.mappings then
  S.mappings = {}
end

function S.wkey(key, plugin, map, desc)
  if vim.tbl_contains(vim.tbl_keys(S.mappings), key) == false then
    print(key, plugin, map, '=====')
    S.mappings[key] = { map, }
    vim.keymap.set({ 'n', 'v', }, key, function()
      if not package.loaded['config.whichkey'] then
        vim.cmd 'Lazy load which-key.nvim'
      end
      for _, m in ipairs(S.mappings[key]) do
        vim.cmd(string.format('lua require"map.%s"', m))
      end
      key = string.gsub(key, '<leader>', '<space>')
      vim.cmd('WhichKey ' .. key)
    end, { silent = true, desc = desc and map .. ' ' .. desc or map, })
  else
    print(key, plugin, map, '-----')
    S.mappings[key][#S.mappings[key] + 1] = map
  end
end

return S
