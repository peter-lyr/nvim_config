local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.load_require_common()
B.load_require 'nvim-lua/plenary.nvim'
B.load_require 'nvim-tree/nvim-web-devicons'

B.map('<leader>fl', M.config, 'lsp_document_symbols', {})
B.map('<leader>fr', M.config, 'lsp_references', {})
B.map('<leader>gf', M.config, 'git_status', {})
B.map('<leader>gh', M.config, 'git_branches', {})
B.map('<leader>gtb', M.config, 'git_bcommits', {})
B.map('<leader>gtc', M.config, 'git_commits', {})
-- B.map('<leader>s<c-l>', M.config, 'live_grep_rg', {})
B.map('<leader>s<leader>', M.config, 'find_files', {})
B.map('<leader>sL', M.config, 'live_grep_def', {})
B.map('<leader>sO', M.config, 'open', {})
B.map('<leader>sb', M.config, 'buffers', {})
B.map('<leader>sc', M.config, 'command_history', {})
B.map('<leader>sd', M.config, 'diagnostics', {})
B.map('<leader>sf', M.config, 'filetypes', {})
B.map('<leader>sh', M.config, 'search_history()', {})
B.map('<leader>sj', M.config, 'jumplist', {})
B.map('<leader>sl', M.config, 'live_grep', {})
B.map('<leader>sm', M.config, 'keymaps', {})
B.map('<leader>sq', M.config, 'quickfix', {})
B.map('<leader>ss', M.config, 'grep_string', {})
B.map('<leader>sv<leader>', M.config, 'find_files_all', {})
B.map('<leader>svb', M.config, 'buffers_cur', {})
B.map('<leader>svc', M.config, 'colorscheme', {})
B.map('<leader>svc', M.config, 'commands', {})
B.map('<leader>svh', M.config, 'help_tags', {})
B.map('<leader>svl', M.config, 'live_grep_all', {})
B.map('<leader>svq', M.config, 'quickfixhistory', {})
B.map('<leader>svva', M.config, 'builtin', {})
B.map('<leader>svvo', M.config, 'vim_options', {})
B.map('<leader>svvp', M.config, 'planets', {})

B.register_whichkey('<leader>gt', M.config, 'Git more')
B.register_whichkey('<leader>sv', M.config, 'more')
B.register_whichkey('<leader>svv', M.config, 'more more')

B.merge_whichkeys()

return M
