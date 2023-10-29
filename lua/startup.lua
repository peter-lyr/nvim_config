local S = {}

S.whichkeys_txt = vim.fn.stdpath 'data' .. '\\whichkeys.txt'

S.enable = 1

function S.load_require(plugin, lua)
  if not plugin then
    print('plugin nil, lua:', lua)
    require 'my_base'.notify_error('plugin nil, lua: ' .. lua)
    print('plugin nil, lua:', lua)
    return
  end
  plugin = string.match(plugin, '/+([^/]+)$')
  if plugin then
    vim.cmd('Lazy load ' .. plugin)
  end
  if lua then
    lua = vim.fn.tolower(lua)
    if not package.loaded[lua] then
      vim.cmd(string.format('lua require"%s"', lua))
    end
  end
end

function S.prepare_whichkeys(mappings)
  for key, vals in pairs(mappings) do
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
      -- vim.keymap.del({ 'n', 'v', }, key)
      vim.cmd('WhichKey ' .. key)
    end, { silent = true, desc = desc, })
  end
end

if S.enable then
  local f = io.open(S.whichkeys_txt)
  if f then
    S.mappings = loadstring('return ' .. f:read '*a')()
    f:close()
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        S.prepare_whichkeys(S.mappings)
      end,
    })
  else
    S.enable = nil
  end
end

return S
