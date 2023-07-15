return {
  'CRAG666/code_runner.nvim',
  lazy = true,
  keys = {
    { '<leader>rr', ':<c-u>ProjectRootCD<cr>:RunCode<cr>', mode = { 'n', 'v', }, silent = true, desc = 'code runner run' },
  },
  dependencies = {
    require('wait.projectroot'),
  },
  config = function()
    require('code_runner').setup({
      filetype = {
        python = 'python -u',
        c = 'cd $dir && ' ..
          'taskkill /f /im $fileNameWithoutExt.exe & ' ..
          'gcc $fileName -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o $fileNameWithoutExt && ' ..
          'strip -s $dir\\$fileNameWithoutExt.exe && ' ..
          'upx --best $dir\\$fileNameWithoutExt.exe && ' ..
          'echo ============================================================ && ' ..
          '$dir\\$fileNameWithoutExt'
      },
    })
  end,
}
