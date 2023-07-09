local M = {}

M.temp = require('plenary.path'):new(vim.fn.expand('$TEMP')):joinpath('temp_xxd.txt')

-- M.xxd_opt = 'xxd -c16 -g2' -- default
M.xxd_opt = 'xxd'

M.dict = {}

local function rep(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '/', '\\')
  return content
end

M.check = function(ev)
  vim.schedule(function()
    local info = vim.fn.system(string.format('file -b --mime-type --mime-encoding "%s"', ev.file))
    info = string.gsub(info, '%s', '')
    info = vim.fn.split(info, ';')
    if string.match(info[2], 'binary') and not string.match(info[1], 'empty') then
      local file = rep(ev.file)
      local ext = string.match(file, '.+%.(%w+)$')
      local ori = file
      local xxdout = string.format('%s/xxdout', vim.fn.fnamemodify(file, ':h'))
      if not require('plenary.path'):new(xxdout):exists() then
        vim.fn.mkdir(xxdout)
      end
      local txt = string.format('%s\\%s.txt', xxdout, vim.fn.fnamemodify(file, ':t'))
      local char = string.format('%s\\%s.c', xxdout, vim.fn.fnamemodify(file, ':t'))
      local xxdbak = string.format('%s/xxdbak', vim.fn.fnamemodify(file, ':h'))
      if not require('plenary.path'):new(xxdbak):exists() then
        vim.fn.mkdir(xxdbak)
      end
      local bak = string.format('%s\\%s-%s.%s', xxdbak, vim.fn.fnamemodify(file, ':t:r'), vim.fn.strftime('%Y%m%d%H%M%S'), ext)
      if vim.tbl_contains(vim.tbl_keys(M.dict), txt) == true then
        bak = M.dict[txt]
      end
      vim.fn.system(string.format('%s "%s" "%s"', M.xxd_opt, ori, txt))
      vim.fn.system(string.format('cd %s && %s -i "%s" "%s"', vim.fn.fnamemodify(ori, ':h'), M.xxd_opt,
        vim.fn.fnamemodify(ori, ':t'), char))
      vim.fn.system(string.format('copy /y "%s" "%s"', file, bak))
      vim.cmd('e ' .. txt)
      vim.cmd('setlocal ft=xxd')
      vim.loop.new_timer():start(1000, 0, function()
        vim.schedule(function()
          vim.cmd(ev.buf .. 'bw!')
        end)
      end)
      M.dict[txt] = {
        ori,
        char,
        bak,
      }
    end
  end)
end

require('maps').add('<F5>', 'n', function()
  vim.loop.new_timer():start(10, 0, function()
    vim.schedule(function()
      if string.match(vim.fn.getline(1), "^00000000:") then
        if vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'filetype') ~= 'xxd' then
          vim.cmd('setlocal ft=xxd')
        end
        local txt = vim.api.nvim_buf_get_name(0)
        vim.fn.system(string.format('%s -r "%s" > "%s" && %s "%s" "%s"', M.xxd_opt, txt, M.dict[txt][1], M.xxd_opt,
          M.dict[txt][1], M.temp))
        vim.fn.system(string.format('cd %s && %s -i "%s" "%s"', vim.fn.fnamemodify(M.dict[txt][1], ':h'), M.xxd_opt,
          vim.fn.fnamemodify(M.dict[txt][1], ':t'), M.dict[txt][2]))
        local lines = require('plenary.path'):new(M.temp):readlines()
        local len = #lines
        vim.fn.setline(1, lines)
        vim.fn.deletebufline(vim.fn.bufnr(), len, vim.fn.line('$'))
      end
    end)
  end)
end, 'xxd_save')

return M
