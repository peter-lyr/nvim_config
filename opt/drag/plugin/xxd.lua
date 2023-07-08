local M = {}

M.temp = require('plenary.path'):new(vim.fn.expand('$TEMP')):joinpath('temp_xxd.txt')

-- M.xdd_opt = 'xdd -c16 -g2' -- default
M.xdd_opt = 'xxd -c32 -g2'

M.dict = {}

local function rep(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '\\', '/')
  return content
end

vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  pattern = { "*.jpg" },
  callback = function(ev)
    vim.schedule(function()
      local ext = string.match(ev.file, '.+%.(%w+)$')
      local txt = rep(string.format('%s.txt', ev.file))
      local ori = ev.file
      local bak = string.format('%s.%s.bak.%s', ev.file, vim.fn.strftime('%Y%m%d%H%M%S'), ext)
      vim.fn.system(string.format('%s "%s" "%s"', M.xdd_opt, ev.file, txt))
      vim.fn.system(string.format('copy /y "%s" "%s"', ev.file, bak))
      vim.cmd('e ' .. txt)
      vim.cmd('setlocal ft=xxd')
      vim.cmd(ev.buf .. 'bw!')
      M.dict[txt] = {
        ori,
        bak,
      }
    end)
  end,
})

require('maps').add('<F5>', 'n', function()
  vim.loop.new_timer():start(10, 0, function()
    vim.schedule(function()
      if string.match(vim.fn.getline(1), "^00000000:") then
        if vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'filetype') ~= 'xxd' then
          vim.cmd('setlocal ft=xxd')
        end
        local txt = vim.api.nvim_buf_get_name(0)
        vim.fn.system(string.format('%s -r "%s" > "%s" && %s "%s" "%s"', M.xdd_opt, txt, M.dict[txt][1], M.xdd_opt, M.dict[txt][1], M.temp))
        local lines = require('plenary.path'):new(M.temp):readlines()
        local len = #lines
        vim.fn.setline(1, lines)
        vim.fn.deletebufline(vim.fn.bufnr(), len, vim.fn.line('$'))
      end
    end)
  end)
end, 'xxd_save')
