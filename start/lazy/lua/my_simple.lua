local S = {}

function S.load_require(plugin, map)
  pcall(vim.cmd, 'Lazy load ' .. string.match(plugin, '%/*([^.]+)$'))
  if map and not package.loaded['map.' .. map] then
    print('lua require"map."', map)
    vim.cmd(string.format('lua require"map.%s"', map))
  else
    print('LUA REQUIRE"CONFIG".', map)
  end
end

function S.func_wrap(key, plugin, map, desc)
  return function()
    S.load_require(plugin, map)
    key = string.gsub(key, '<leader>', '<space>')
    vim.cmd('WhichKey ' .. key)
  end
end

function S.gkey(key, plugin, map, desc)
  return {
    key,
    S.func_wrap(key, plugin, map, desc),
    mode = { 'n', 'v', },
    silent = true,
    desc = desc and map .. ' ' .. desc or map,
  }
end

return S
