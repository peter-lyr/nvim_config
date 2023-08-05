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
      mode = 'float',
      startinsert = true,
      filetype = {
        python = 'python -u',
        c = {
          'cd $dir &&',
          'pwd &&',
          'echo ============================================================ &&',
          'taskkill /f /im $fileNameWithoutExt.exe &',
          'echo ============================================================ &&',
          'gcc $fileName -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o $fileNameWithoutExt &&',
          'echo ============================================================ &&',
          'strip -s $dir\\$fileNameWithoutExt.exe &&',
          'echo ============================================================ &&',
          'upx -qq --best $dir\\$fileNameWithoutExt.exe &&',
          'echo ============================================================ &&',
          '$dir\\$fileNameWithoutExt.exe'
        },
      },
    })
  end,
}
