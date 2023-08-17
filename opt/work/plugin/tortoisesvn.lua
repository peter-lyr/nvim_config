local path = require "plenary.path"

local system_cd_string = function(absfolder)
  local fpath = path:new(absfolder)
  if not fpath:exists() then
    return ''
  end
  if fpath:is_dir() then
    return string.sub(absfolder, 1, 1) .. ': && cd ' .. absfolder
  end
  return string.sub(absfolder, 1, 1) .. ': && cd ' .. fpath:parent()['filename']
end

local tortoisesvn = function(params)
  if not params or #params < 3 then
    return
  end
  local cmd, cmd1, cmd2, root, yes = unpack(params)
  if #params == 3 then
    cmd, root, yes = unpack(params)
  elseif #params == 4 then
    cmd1, cmd2, root, yes = unpack(params)
    cmd = cmd1 .. ' ' .. cmd2
  end
  if not cmd then
    return
  end
  local abspath = (root == 'root') and vim.fn['projectroot#get'](vim.api.nvim_buf_get_name(0)) or vim.api.nvim_buf_get_name(0)
  if yes == 'yes' or vim.tbl_contains({ 'y', 'Y', }, vim.fn.trim(vim.fn.input("Sure to update? [Y/n]: ", 'Y'))) == true then
    vim.fn.execute(string.format("silent !%s && start tortoiseproc.exe /command:%s /path:\"%s\"",
      system_cd_string(abspath),
      cmd, abspath))
  end
end

vim.api.nvim_create_user_command('TortoisesvN', function(params)
  tortoisesvn(params['fargs'])
end, { nargs = "*", })
