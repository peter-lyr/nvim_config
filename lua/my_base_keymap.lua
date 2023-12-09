local M = {}

function M.register_whichkey(whichkeys, lua, key, desc)
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
