local B = {}

local S = require 'startup'

-----------------------------

B.load_require = S.load_require

B.load_post = nil

function B.load_require_common()
  if not B.is(B.load_post) then
    B.load_post = 1
    B.load_require 'navarasu/onedark.nvim'
    vim.cmd.colorscheme 'onedark'
  end
end

-----------------------------

function B.is(val)
  if not val or val == 0 or val == '' or val == false or val == {} then
    return nil
  end
  return 1
end

function B.is_buf_ft(buf, ft)
  if vim.api.nvim_buf_get_option(buf, 'filetype') == ft then
    return 1
  end
  return nil
end

function B.rep_slash(content)
  content = string.gsub(content, '/', '\\')
  return content
end

function B.rep_slash_lower(content)
  return vim.fn.tolower(B.rep_slash(content))
end

function B.rep_baskslash(content)
  content = string.gsub(content, '\\', '/')
  return content
end

function B.rep_baskslash_lower(content)
  return vim.fn.tolower(B.rep_baskslash(content))
end

-----------------------------

function B.get_base_source()
  return debug.getinfo(1)['source']
end

function B.get_source(source)
  if not source then
    source = B.get_base_source()
  end
  source = vim.fn.trim(source, '@')
  return B.rep_baskslash(source)
end

function B.get_loaded(source)
  source = B.get_source(source)
  local loaded = string.match(source, '.+lua/(.+)%.lua')
  if not loaded then
    return ''
  end
  loaded = string.gsub(loaded, '/', '.')
  return loaded
end

B.source = B.get_source(debug.getinfo(1)['source'])
B.loaded = B.get_loaded(B.source)

-----------------------------

function B.merge_tables(...)
  return B.call_sub(B.loaded, 'keymap', 'merge_tables', ...)
end

B.map_default_opts = {
  silent = true,
}
B.map_opts = B.map_default_opts

function B.map_set_opts(opts)
  B.map_opts = vim.tbl_deep_extend('force', B.map_default_opts, opts)
end

function B.map_reset_opts()
  B.map_opts = B.map_default_opts
end

function B.map(lhs, lua, func, params, desc_more)
  B.call_sub(B.loaded, 'keymap', 'map', B.merge_tables, B.map_opts, lhs, lua, func, params, desc_more)
end

-----------------------------

function B.rep_map_to_config(loaded)
  return string.gsub(loaded, 'map.', 'config.')
end

-----------------------------

B.whichkeys = {}

function B.register_whichkey(key, lua, desc)
  B.call_sub(B.loaded, 'keymap', 'register_whichkey', B.whichkeys, key, lua, desc)
end

function B.merge_whichkeys()
  require 'which-key'.register(B.whichkeys)
end

-----------------------------

function B.call_sub(main, sub, func, ...)
  return require(main .. '_' .. sub)[func](...)
end

-----------------------------

function B.get_desc(source, desc)
  return B.get_loaded(source) .. '-' .. desc, {}
end

function B.get_group(source, desc)
  return vim.api.nvim_create_augroup(B.get_desc(source, desc), {})
end

function B.aucmd(source, desc, event, opts)
  opts = vim.tbl_deep_extend('force', opts, { group = B.get_group(source, desc), desc = B.get_desc(source, desc), })
  vim.api.nvim_create_autocmd(event, opts)
end

-----------------------------

function B.set_timeout(timeout, callback)
  return vim.fn.timer_start(timeout, function()
    callback()
  end, { ['repeat'] = 1, })
end

function B.set_interval(interval, callback)
  return vim.fn.timer_start(interval, function()
    callback()
  end, { ['repeat'] = -1, })
end

function B.clear_interval(timer)
  vim.fn.timer_stop(timer)
end

return B
