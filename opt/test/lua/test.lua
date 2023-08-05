require('code_runner').setup({
  mode = 'float',
  filetype = {
    python = 'python -u',
    c = {
      'cd $dir &&',
      'taskkill /f /im $fileNameWithoutExt.exe &',
      'gcc $fileName -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o $fileNameWithoutExt &&',
      'strip -s $dir\\$fileNameWithoutExt.exe &&',
      'upx --best $dir\\$fileNameWithoutExt.exe &&',
      'echo ============================================================ &&',
      '$dir\\$fileNameWithoutExt'
    },
  },
})
