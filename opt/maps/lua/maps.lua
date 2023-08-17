local M = {}

local function callback_rhs(lhs, mode)
  for _, v in ipairs(vim.api.nvim_get_keymap(mode)) do
    if v.lhs == lhs then
      local callback = nil
      local rhs = nil
      if v.callback then
        callback = v.callback
      elseif v.rhs then
        rhs = v.rhs
      end
      return { callback, rhs, v.desc, }
    end
  end
  return nil
end

local function old_callback(rhs)
  if rhs[1] then
    return function()
      rhs[1]()
    end
  elseif rhs[2] then
    return function()
      local r = string.gsub(rhs[2], '<Cmd>', ':')
      r = string.gsub(r, '\\', '')
      r = string.gsub(r, '<', '\\<')
      r = string.gsub(r, '^:', ':\\<C-u>')
      vim.cmd(string.format([[call feedkeys("%s")]], r))
    end
  else
    return function()
    end
  end
end

M.add = function(lhs, mode, new, desc)
  local rhs = callback_rhs(lhs, mode)
  local old = old_callback(rhs)
  vim.keymap.set({ mode, }, lhs, function()
    old()
    new()
  end, { desc = (rhs and rhs[3] and #rhs[3] > 0) and rhs[3] .. ' & ' .. desc or desc, })
end

-- require('maps').add(' bw', 'n', function()
--   print('33333333333')
-- end, 'xxxx')

return M
