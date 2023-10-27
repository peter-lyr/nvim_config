local M = {}

function M.merge_tables(...)
  local result = {}
  for _, t in ipairs { ..., } do
    for _, v in ipairs(t) do
      result[#result + 1] = v
    end
  end
  return result
end

function M.map(map_opts, lhs, lua, func, params, desc_more)
  local desc = { string.match(lua, '%.([^.]+)$'), }
  desc[#desc + 1] = func
  if desc_more then
    desc[#desc + 1] = desc_more
  end
  if type(params) == 'string' then
    desc[#desc + 1] = params
  elseif type(params) == 'table' then
    desc = M.merge_tables(desc, params)
  end
  vim.keymap.set({ 'n', 'v', }, lhs, function()
    if type(params) == 'string' then
      require(lua)[func](params)
    elseif type(params) == 'table' then
      require(lua)[func](unpack(params))
    else
      require(lua)[func]()
    end
  end, vim.tbl_deep_extend('force', map_opts, { desc = vim.fn.join(desc, ' '), }))
end

function M.register_whichkey(whichkeys, key, lua, desc)
  lua = string.match(lua, '%.*([^.]+)$')
  if not lua then
    return
  end
  if desc then
    desc = string.gsub(desc, ' ', '_')
    desc = lua .. '_' .. desc
  else
    desc = lua
  end
  if vim.tbl_contains(vim.tbl_keys(whichkeys), key) == true then
    local old = whichkeys[key]['name']
    if not string.match(old, desc) then
      whichkeys[key] = { name = old .. ' ' .. desc, }
    end
  else
    whichkeys[key] = { name = desc, }
  end
  return whichkeys
end

return M
