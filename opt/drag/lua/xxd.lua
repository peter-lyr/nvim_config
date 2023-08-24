package.loaded['xxd'] = nil

local M = {}

M.temp = require 'plenary.path':new(vim.fn.expand '$TEMP'):joinpath 'temp_xxd.txt'

-- M.xxd_opt = 'xxd -c16 -g2' -- default
M.xxd_opt = 'xxd'

M.dict = {}

local function rep(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '/', '\\')
  return content
end

local function systemcd(path)
  local s = ''
  if string.sub(path, 2, 2) == ':' then
    s = s .. string.sub(path, 1, 2) .. ' && '
  end
  if require 'plenary.path'.new(path):is_dir() then
    s = s .. 'cd ' .. path
  else
    s = s .. 'cd ' .. require 'plenary.path'.new(path):parent().filename
  end
  return s
end

M.check = function(ev)
  vim.schedule(function()
    local info = vim.fn.system(string.format('file -b --mime-type --mime-encoding "%s"', ev.file))
    info = string.gsub(info, '%s', '')
    info = vim.fn.split(info, ';')
    if info[2] and string.match(info[2], 'binary') or info[1] and not string.match(info[1], 'empty') then
      local file = rep(ev.file)
      local xxdout = string.format('%s\\.xxdout', vim.fn.fnamemodify(file, ':h'))
      if not require 'plenary.path':new(xxdout):exists() then
        vim.fn.mkdir(xxdout)
      end
      local txt = string.format('%s\\%s.xxd', xxdout, vim.fn.fnamemodify(file, ':t'))
      local char = string.format('%s\\%s.c', xxdout, vim.fn.fnamemodify(file, ':t'))
      local mod = string.format('%s\\%s', xxdout, vim.fn.fnamemodify(file, ':t'))
      vim.fn.system(string.format('copy /y "%s" "%s"', file, mod))
      vim.fn.system(string.format('%s "%s" "%s"', M.xxd_opt, mod, txt))
      vim.fn.system(string.format('%s && %s -i "%s" "%s"', systemcd(mod), M.xxd_opt,
        vim.fn.fnamemodify(mod, ':t'), char))
      vim.cmd('e ' .. txt)
      vim.cmd 'setlocal ft=xxd'
      vim.loop.new_timer():start(1000, 0, function()
        vim.schedule(function()
          vim.cmd(ev.buf .. 'bw!')
        end)
      end)
      M.dict[txt] = {
        mod,
        char,
      }
    end
  end)
end

require 'maps'.add('<F5>', 'n', function()
  vim.loop.new_timer():start(10, 0, function()
    vim.schedule(function()
      if string.match(vim.fn.getline(1), '^00000000:') then
        if vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'filetype') ~= 'xxd' then
          vim.cmd 'setlocal ft=xxd'
        end
        local txt = vim.api.nvim_buf_get_name(0)
        if vim.tbl_contains(vim.tbl_keys(M.dict), txt) == false then
          M.dict[txt] = {
            string.sub(txt, 1, #txt - 4),
            string.sub(txt, 1, #txt - 4) .. '.c',
          }
        end
        vim.fn.system(string.format('%s -r "%s" > "%s" && %s "%s" "%s"', M.xxd_opt, txt, M.dict[txt][1], M.xxd_opt,
          M.dict[txt][1], M.temp))
        vim.fn.system(string.format('%s && %s -i "%s" "%s"', systemcd(M.dict[txt][1]), M.xxd_opt,
          vim.fn.fnamemodify(M.dict[txt][1], ':t'), M.dict[txt][2]))
        local lines = require 'plenary.path':new(M.temp):readlines()
        local len = #lines
        vim.fn.setline(1, lines)
        vim.fn.deletebufline(vim.fn.bufnr(), len, vim.fn.line '$')
      end
      M.check { buf = vim.fn.bufnr(), file = vim.api.nvim_buf_get_name(0), }
    end)
  end)
end, 'xxd_save')

return M
