return {
  'CRAG666/code_runner.nvim',
  lazy = true,
  keys = {
    { '<leader>rr',          ':<c-u>RunCode<cr>',     mode = { 'n', 'v', }, silent = true, desc = 'code runner run' },
  },
  config = function()
    require('code_runner').setup({
      filetype = {
        python = 'python -u',
        c = 'cd $dir && ' ..
          'gcc $fileName -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o $fileNameWithoutExt && ' ..
          'strip -s $dir/$fileNameWithoutExt.exe && ' ..
          'upx --best $dir/$fileNameWithoutExt.exe && ' .. '$dir/$fileNameWithoutExt'
      },
    })
  end,
}
