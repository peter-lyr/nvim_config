local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then
  error 'This extension requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)'
end

local fb_actions = require 'telescope._extensions.file_browser.actions'
local fb_finders = require 'telescope._extensions.file_browser.finders'
local fb_picker = require 'telescope._extensions.file_browser.picker'
local fb_config = require 'telescope._extensions.file_browser.config'

local extract_keymap_opts = function(key_func)
  if type(key_func) == 'table' and key_func.opts ~= nil then
    -- we can't clear this because key_func could be a table from the config.
    -- If we clear it the table ref would lose opts after the first bind
    -- We need to copy it so noremap and silent won't be part of the table ref after the first bind
    return vim.deepcopy(key_func.opts)
  end
  return {}
end

local my_file_browser = function(opts)
  opts = opts or {}
  local defaults = (function()
    if fb_config.values.theme then
      return require 'telescope.themes'['get_' .. fb_config.values.theme](fb_config.values)
    end
    return vim.deepcopy(fb_config.values)
  end)()

  if fb_config.values.mappings then
    defaults.attach_mappings = function(prompt_bufnr, map)
      if fb_config.values.attach_mappings then
        fb_config.values.attach_mappings(prompt_bufnr, map)
      end
      for mode, tbl in pairs(fb_config.values.mappings) do
        for key, action in pairs(tbl) do
          map(mode, key, action, extract_keymap_opts(action))
        end
      end
      return true
    end
  end

  if opts.attach_mappings then
    local opts_attach = opts.attach_mappings
    opts.attach_mappings = function(prompt_bufnr, map)
      defaults.attach_mappings(prompt_bufnr, map)
      return opts_attach(prompt_bufnr, map)
    end
  end
  local popts = vim.tbl_deep_extend('force', defaults, opts)
  fb_picker(popts)
end

return telescope.register_extension {
  setup = fb_config.setup,
  exports = {
    my_file_browser = my_file_browser,
    actions = fb_actions,
    finder = fb_finders,
    _picker = fb_picker,
  },
}
