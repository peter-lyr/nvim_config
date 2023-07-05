------------------
-- dragimage
------------------

local cancelopen
local dragimagename
local getimagealways
local gobackbufnr
local lastbufnr

local ft = {
  'jpg', 'png',
}

vim.api.nvim_create_autocmd({ 'BufReadPre' }, {
  callback = function()
    local cur_fname = vim.api.nvim_buf_get_name(0)
    local extension = string.match(cur_fname, '.+%.(%w+)$')
    if vim.tbl_contains(ft, extension) == true then
      local last_extension = vim.bo[lastbufnr].ft
      if last_extension == 'markdown' then
        local lastbufname = vim.api.nvim_buf_get_name(lastbufnr)
        local projectroot_path = require('plenary.path'):new(vim.fn['projectroot#get'](lastbufname))
        if projectroot_path.filename == '' then
          gobackbufnr = lastbufnr
          cancelopen = true
          print('not projectroot:', lastbufname)
          print('cancelopen')
          return
        end
        if getimagealways == true then
          gobackbufnr = lastbufnr
        else
          local input = vim.fn.input('get image? [y(es)/a(lwayse)/o(pen)]: ', 'y')
          if vim.tbl_contains({ 'y', 'Y' }, input) == true then
            gobackbufnr = lastbufnr
          elseif vim.tbl_contains({ 'a', 'A' }, input) == true then
            gobackbufnr = lastbufnr
            getimagealways = true
          elseif input == '' then
            gobackbufnr = lastbufnr
            cancelopen = true
          end
        end
        dragimagename = cur_fname
      else
        getimagealways = false
      end
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  callback = function()
    if gobackbufnr then
      local curbufnr = vim.fn.bufnr()
      vim.cmd('b' .. gobackbufnr)
      gobackbufnr = nil
      if cancelopen then
        cancelopen = nil
        vim.cmd('bw! ' .. curbufnr)
        return
      end
      require('mkdimage').dragimage('sel_png', dragimagename)
      vim.cmd('w!')
      vim.cmd('bw! ' .. curbufnr)
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  callback = function()
    lastbufnr = vim.fn.bufnr()
  end,
})
