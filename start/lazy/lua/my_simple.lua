local S = {}

function S.load_require(plugin, config)
  pcall(vim.cmd, 'Lazy load ' .. string.match(plugin, '%/*([^.]+)$'))
  if config and not package.loaded['config.' .. config] then
    print('lua require"config."', config)
    vim.cmd(string.format('lua require"config.%s"', config))
  else
    print('LUA REQUIRE"CONFIG".', config)
  end
end

function S.func_wrap(key, plugin, config, desc)
  return function()
    if not require 'config.whichkey'.started then
      require 'config.whichkey'.start()
    end
    S.load_require(plugin, config)
    key = string.gsub(key, '<leader>', '<space>')
    vim.cmd('WhichKey ' .. key)
  end
end

function S.gkey(key_major, key_minor, plugin, config, desc)
  local temp = string.match(config, '%.*([^.]+)$')
  desc = desc and temp .. ' ' .. desc or temp
  -- if key_major ~= '<leader>' then
  --   require 'config.whichkey'.add { [key_major] = { name = desc, }, }
  -- else
  -- end
  return {
    key_major,
    -- S.func_wrap(key_major, plugin, config, desc),
    function()
      print(key_major, key_minor, plugin, config, desc)
      print("key_major:", key_major, '|')
      print("key_minor:", key_minor, '|')
      print("plugin:", plugin, '|')
      print("config:", config, '|')
      print("desc:", desc, '|')
    end,
    mode = { 'n', 'v', },
    silent = true,
    desc = desc,
  }
end

return S
