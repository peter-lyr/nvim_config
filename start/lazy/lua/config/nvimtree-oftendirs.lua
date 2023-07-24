package.loaded['config.nvimtree-oftendirs'] = nil

local M = {}

local nv = require('plenary.path'):new(vim.fn.expand('$VIMRUNTIME')):parent():parent():parent():parent()

local dirs = {
  vim.fn.expand([[$HOME]]),
  vim.fn.expand([[$TEMP]]),
  vim.fn.expand([[$LOCALAPPDATA]]),
  vim.fn.expand([[$VIMRUNTIME\pack]]),
  vim.fn.expand([[$VIMRUNTIME\pack\nvim_config]]),
  vim.fn.expand([[$VIMRUNTIME\pack\lazy\plugins]]),
  nv.filename,
}

local existsdirs = {}

for _, dir in ipairs(dirs) do
  if vim.fn.isdirectory(dir) then
    table.insert(existsdirs, dir)
  end
end

for i = 1, 26 do
  local dir = vim.fn.nr2char(64 + i) .. [[:\]]
  if vim.fn.isdirectory(dir) == 1 then
    table.insert(existsdirs, dir)
  end
end

M.open = function()
  vim.ui.select(vim.fn.sort(existsdirs), { prompt = 'oftendirs' }, function(choice)
    if not choice then
      return
    end
    vim.cmd('NvimTreeOpen')
    vim.loop.new_timer():start(10, 0, function()
      vim.schedule(function()
        vim.cmd('cd ' .. choice)
      end)
    end)
  end)
end

M.explorer = function()
  vim.ui.select(vim.fn.sort(existsdirs), { prompt = 'oftendirs' }, function(choice)
    if not choice then
      return
    end
    vim.cmd('!explorer "' .. choice .. '"')
  end)
end

local pathdirs = {}

for pathdir in string.gmatch(vim.fn.expand([[$PATH]]), '([^;]+);') do
  if vim.fn.isdirectory(pathdir) == 1 then
    table.insert(pathdirs, pathdir)
  end
end

M.openpathdir = function()
  vim.ui.select(vim.fn.sort(pathdirs), { prompt = 'pathdirs' }, function(choice)
    if not choice then
      return
    end
    vim.cmd('NvimTreeOpen')
    vim.loop.new_timer():start(10, 0, function()
      vim.schedule(function()
        vim.cmd('cd ' .. choice)
      end)
    end)
  end)
end

return M
