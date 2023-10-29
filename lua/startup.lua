local S = {}

S.whichkeys_txt = vim.fn.stdpath 'data' .. '\\whichkeys.txt'
S.gui_window_frameless_dir = vim.fn.stdpath 'data' .. '\\gui-window-frameless'
S.gui_window_frameless_txt = S.gui_window_frameless_dir .. '\\gui-window-frameless.txt'

S.load_whichkeys_txt_enable = 1
S.startup_with_frame_enable = 1

function S.load_require(plugin, lua)
  if not plugin then
    print('plugin nil, lua:', lua)
    require 'my_base'.notify_error('plugin nil, lua: ' .. lua)
    return
  end
  plugin = string.match(plugin, '/+([^/]+)$')
  if plugin then
    vim.cmd('Lazy load ' .. plugin)
  end
  if lua then
    lua = vim.fn.tolower(lua)
    if not package.loaded[lua] then
      vim.cmd(string.format('lua require"%s"', lua))
    end
  end
end

function S.prepare_whichkeys(mappings)
  for key, vals in pairs(mappings) do
    local new_desc = {}
    for _, val in ipairs(vals) do
      new_desc[#new_desc + 1] = val[3]
    end
    local desc = vim.fn.join(new_desc, ' ')
    vim.keymap.set({ 'n', 'v', }, key, function()
      if not package.loaded['config.extra_whichkey'] then
        vim.cmd 'Lazy load which-key.nvim'
      end
      for _, val in ipairs(vals) do
        S.load_require(val[1], string.format('map.%s', val[2]))
      end
      key = string.gsub(key, '<leader>', '<space>')
      -- vim.keymap.del({ 'n', 'v', }, key)
      vim.cmd('WhichKey ' .. key)
    end, { silent = true, desc = desc, })
  end
end

if S.load_whichkeys_txt_enable then
  local f = io.open(S.whichkeys_txt)
  if f then
    S.mappings = loadstring('return ' .. f:read '*a')()
    f:close()
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        S.prepare_whichkeys(S.mappings)
      end,
    })
  else
    S.load_whichkeys_txt_enable = nil
  end
end

if S.startup_with_frame_enable then
  if vim.fn.isdirectory(S.gui_window_frameless_dir) == 0 then
    vim.fn.mkdir(S.gui_window_frameless_dir)
  end
  local f = io.open(S.gui_window_frameless_txt)
  if f then
    if vim.fn.trim(loadstring('return ' .. f:read '*a')()) == '1' then
      vim.g.gui_window_frameless_timer = vim.fn.timer_start(20, function()
        if vim.fn.exists 'g:GuiLoaded' then
          vim.fn.timer_stop(vim.g.gui_window_frameless_timer)
          if vim.g.GuiLoaded == 1 then
            vim.fn['GuiWindowFrameless'](1)
          end
        end
      end, { ['repeat'] = 20, })
    end
    f:close()
  end
end

return S
