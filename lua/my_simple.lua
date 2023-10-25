local S = {}

local Startup = require 'startup'

S.mappings = {}

S.load_require = Startup.load_require
S.map = Startup.map

function S.add_whichkey(key, plugin, map, desc)
  desc = desc and map .. '_' .. desc or map
  key = vim.fn.tolower(key)
  if vim.tbl_contains(vim.tbl_keys(S.mappings), key) == false then
    S.mappings[key] = { { plugin, map, desc, }, }
  else
    S.mappings[key][#S.mappings[key] + 1] = { plugin, map, desc, }
  end
end

if not Startup.enable then
  vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
      S.prepare_whichkeys(S.mappings)
    end,
  })
  S.autocmd_startup = vim.api.nvim_create_autocmd('VimLeave', {
    callback = function()
      local mappings = string.gsub(vim.inspect(S.mappings), '%s+', ' ')
      vim.fn.writefile({ mappings, }, require 'startup'.whichkeys_txt)
    end,
  })
end

return S
