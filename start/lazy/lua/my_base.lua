local B = {}

local S = require 'my_simple'

function B.is(val)
  if not val or val == 0 or val == '' or val == false or val == {} then
    return nil
  end
  return 1
end

function B.is_buf_ft(buf, ft)
  if vim.api.nvim_buf_get_option(buf, 'filetype') == ft then
    return 1
  end
  return nil
end

function B.rep_slash(content)
  content = string.gsub(content, '/', '\\')
  return content
end

function B.rep_slash_lower(content)
  return vim.fn.tolower(B.rep_slash(content))
end

function B.rep_baskslash(content)
  content = string.gsub(content, '\\', '/')
  return content
end

function B.rep_baskslash_lower(content)
  return vim.fn.tolower(B.rep_baskslash(content))
end

----------------------

function B.get_base_source()
  return debug.getinfo(1)['source']
end

function B.get_source(source)
  if not source then
    source = B.get_base_source()
  end
  source = vim.fn.trim(source, '@')
  return B.rep_baskslash(source)
end

function B.get_loaded(source)
  source = B.get_source(source)
  local loaded = string.match(source, '.+lua/(.+)%.lua')
  loaded = string.gsub(loaded, '/', '.')
  return loaded
end

----------------------

function B.merge_tables(...)
  local result = {}
  for _, t in ipairs { ..., } do
    for _, v in ipairs(t) do
      result[#result + 1] = v
    end
  end
  return result
end

function B.map(lhs, lua, func, params, desc_more)
  print("lhs:", lhs)
  print("lua:", lua, '000')
  print("lua:", vim.inspect(lua), '999')
  print("lua:", type(lua))
  local desc = { string.match(lua, '%.([^.]+)$'), }
  desc[#desc + 1] = func
  if desc_more then
    desc[#desc + 1] = desc_more
  end
  if type(params) == 'string' then
    desc[#desc + 1] = params
  elseif type(params) == 'table' then
    desc = B.merge_tables(desc, params)
  end
  vim.keymap.set({ 'n', 'v', }, lhs, function()
    if type(params) == 'string' then
      require(lua)[func](params)
    elseif type(params) == 'table' then
      require(lua)[func](unpack(params))
    else
      require(lua)[func]()
    end
  end, { silent = true, desc = vim.fn.join(desc, ' '), })
end

----------------------

function B.rep_map_to_config(loaded)
  return string.gsub(loaded, 'map.', 'config.')
end

return B
