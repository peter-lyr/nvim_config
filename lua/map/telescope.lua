local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.load_require 'nvim-lua/plenary.nvim'
B.load_require 'nvim-tree/nvim-web-devicons'

B.map_set_lua(M.config)

B.map('<leader>fl', 'lsp_document_symbols', {})
B.map('<leader>fr', 'lsp_references', {})
B.map('<leader>gf', 'git_status', {})
B.map('<leader>gh', 'git_branches', {})
B.map('<leader>gtb', 'git_bcommits', {})
B.map('<leader>gtc', 'git_commits', {})
B.map('<leader>s<c-l>', 'live_grep_rg', {})
B.map('<leader>s<leader>', 'find_files', {})
B.map('<leader>sL', 'live_grep_def', {})
B.map('<leader>sO', 'open', {})
B.map('<leader>sb', 'buffers', {})
B.map('<leader>sc', 'command_history', {})
B.map('<leader>sd', 'diagnostics', {})
B.map('<leader>sf', 'filetypes', {})
B.map('<leader>sh', 'search_history', {})
B.map('<leader>sj', 'jumplist', {})
B.map('<leader>sl', 'live_grep', {})
B.map('<leader>sm', 'keymaps', {})
B.map('<leader>sq', 'quickfix', {})
B.map('<leader>ss', 'grep_string', {})
B.map('<leader>sv<leader>', 'find_files_all', {})
B.map('<leader>svb', 'buffers_cur', {})
B.map('<leader>svc', 'colorscheme', {})
B.map('<leader>svc', 'commands', {})
B.map('<leader>svh', 'help_tags', {})
B.map('<leader>svl', 'live_grep_all', {})
B.map('<leader>svq', 'quickfixhistory', {})
B.map('<leader>svva', 'builtin', {})
B.map('<leader>svvo', 'vim_options', {})
B.map('<leader>svvp', 'planets', {})

B.map('<leader>sk', 'my_projects', {})

B.map('<leader>st', 'buffers_term', {})

-----------------------------------

B.map('<c-s-f12><f1>', 'git_status', {})
B.map('<c-s-f12><f2>', 'buffers_cur', {})
B.map('<c-s-f12><f3>', 'find_files', {})
B.map('<c-s-f12><f4>', 'jumplist', {})
B.map('<c-s-f12><f6>', 'command_history', {})
B.map('<c-s-f12><f7>', 'lsp_document_symbols', {})
B.map('<c-s-f12><f8>', 'buffers', {})

B.map_i('<c-s-f12><f1>', 'nop', {})
B.map_i('<c-s-f12><f2>', 'nop', {})
B.map_i('<c-s-f12><f3>', 'nop', {})
B.map_i('<c-s-f12><f4>', 'nop', {})
B.map_i('<c-s-f12><f6>', 'nop', {})
B.map_i('<c-s-f12><f7>', 'nop', {})
B.map_i('<c-s-f12><f8>', 'nop', {})
-----------------------------------

B.register_whichkey('<leader>gt', 'Git more')
B.register_whichkey('<leader>sv', 'more')
B.register_whichkey('<leader>svv', 'more more')

B.merge_whichkeys()

return M
