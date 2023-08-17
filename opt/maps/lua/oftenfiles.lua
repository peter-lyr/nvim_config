local M = {}

local files = {
  string.sub(debug.getinfo(1).source, 2),
  vim.fn.expand [[$HOME\.gitconfig]],
  vim.fn.expand [[$HOME\.gitignore_global]],
  -- vim.fn.expand([[$localappdata\nvim\init.lua]]),
}

local existsfiles = {}

for _, file in ipairs(files) do
  if vim.fn.filereadable(file) then
    table.insert(existsfiles, file)
  end
end

M.open = function()
  vim.ui.select(existsfiles, { prompt = 'oftenfiles', }, function(choice)
    if not choice then
      return
    end
    vim.cmd('e ' .. choice)
  end)
end

return M
