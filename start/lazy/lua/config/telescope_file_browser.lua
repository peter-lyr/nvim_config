local M = {}

local fb_actions = require 'telescope._extensions.file_browser.actions'

require 'telescope'.setup {
  extensions = {
    my_file_browser = {
      grouped = true,
      select_buffer = true,
      prompt_path = true,
      collapse_dirs = true,
      files = false,
      mappings = {
        ['i'] = {
          ['<A-c>'] = fb_actions.create,
          ['<S-CR>'] = fb_actions.create_from_prompt,
          ['<A-r>'] = fb_actions.rename,
          ['<A-m>'] = fb_actions.move,
          ['<A-y>'] = fb_actions.copy,
          ['<A-d>'] = fb_actions.remove,
          ['<C-o>'] = fb_actions.open,
          ['<C-g>'] = fb_actions.goto_parent_dir,
          ['<C-e>'] = fb_actions.goto_home_dir,
          ['<C-w>'] = fb_actions.goto_cwd,
          ['<C-t>'] = fb_actions.change_cwd,
          ['<C-f>'] = fb_actions.toggle_browser,
          ['<C-h>'] = fb_actions.toggle_hidden,
          ['<C-s>'] = fb_actions.toggle_all,
          ['<bs>'] = fb_actions.backspace,
        },
        ['n'] = {
          ['c'] = fb_actions.create,
          ['r'] = fb_actions.rename,
          ['m'] = fb_actions.move,
          ['y'] = fb_actions.copy,
          ['d'] = fb_actions.remove,
          ['o'] = fb_actions.open,
          ['g'] = fb_actions.goto_parent_dir,
          ['e'] = fb_actions.goto_home_dir,
          ['w'] = fb_actions.goto_cwd,
          ['t'] = fb_actions.change_cwd,
          ['f'] = fb_actions.toggle_browser,
          ['h'] = fb_actions.toggle_hidden,
          ['s'] = fb_actions.toggle_all,
          ['<leader>'] = fb_actions.open,
        },
      },
    },
  },
}

pcall(require 'telescope'.load_extension, 'my_file_browser')

M.my_file_browser = function()
  vim.cmd 'Telescope my_file_browser'
end

M.my_file_browser_cur = function()
  vim.cmd(string.format('Telescope my_file_browser path=%s cwd_to_path=true files=true', vim.fn.expand '%:h'))
end

return M
