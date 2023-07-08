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
          vim.fn.fnamemodify(M.dict[txt][1], ':t'), M.dict[txt][1]))
        local lines = require('plenary.path'):new(M.temp):readlines()
        local len = #lines
        vim.fn.setline(1, lines)
        vim.fn.deletebufline(vim.fn.bufnr(), len, vim.fn.line('$'))
      end
    end)
  end)
end, 'xxd_save')
