local M = {}

M.minimize = function()
  local f = [[
    try
      %s
    catch
    endtry
  ]]
  local cmd = ''
  for _, v in ipairs {
    [[%s/\s\+$\|^\s\+//g]],
    [[%s/\s\+/ /g]],
    [[g/^$/d]],
    [[%s/>[\s\r\n\t]\+</></g]],
    [[%s/\n//g]],
    [[%s/<!--.\{-}-->//g]],
    [[%s/<script[^>]*>.*<\/script>]],
    [[%s/<style[^>]*>.*<\/style>]],
  } do
    cmd = cmd .. string.format(f, v)
  end
  vim.cmd(cmd)
end

return M
