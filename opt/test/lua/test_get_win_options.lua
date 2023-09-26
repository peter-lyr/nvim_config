local all_options = vim.api.nvim_get_all_options_info()
local win_number = vim.api.nvim_get_current_win()
local v = vim.wo[win_number]
all_options = vim.api.nvim_get_all_options_info()
local result = ''
for key, val in pairs(all_options) do
  -- if val.global_local == false and val.scope == 'win' then
  if 1 and val.scope == 'win' then
    result = result .. '|' .. key .. '=' .. tostring(v[key] or '<not set>')
    -- vim.fn.append('.', key .. '=' .. tostring(v[key] or '<not set>'))
  end
end
print(result)

-- if val.global_local == false and val.scope == 'win' then
-- linebreak=<not set>
-- breakindent=<not set>
-- rightleftcmd=search
-- cursorlineopt=both
-- previewwindow=<not set>
-- rightleft=<not set>
-- scrollbind=<not set>
-- foldmethod=indent
-- diff=<not set>
-- cursorcolumn=true
-- cursorbind=<not set>
-- statuscolumn=
-- numberwidth=1
-- relativenumber=true
-- cursorline=true
-- foldlevel=99
-- signcolumn=auto:1
-- spell=<not set>
-- winhighlight=
-- wrap=<not set>
-- list=true
-- foldenable=true
-- colorcolumn=
-- winfixheight=<not set>
-- foldcolumn=0
-- winfixwidth=<not set>
-- conceallevel=3
-- concealcursor=
-- foldtext=foldtext()
-- foldnestmax=20
-- foldminlines=1
-- foldmarker={{{,}}}
-- foldignore=#
-- breakindentopt=
-- arabic=<not set>
-- scroll=19
-- foldexpr=0
-- number=true
-- winblend=0


-- if 1 and val.scope == 'win' then
-- listchars=tab:> ,trail:-,nbsp:+
-- fillchars=
-- linebreak=<not set>
-- breakindent=<not set>
-- rightleftcmd=search
-- cursorlineopt=both
-- previewwindow=<not set>
-- rightleft=<not set>
-- scrollbind=<not set>
-- scrolloff=0
-- sidescrolloff=0
-- foldmethod=indent
-- diff=<not set>
-- cursorcolumn=true
-- cursorbind=<not set>
-- statuscolumn=
-- numberwidth=1
-- relativenumber=true
-- cursorline=true
-- showbreak=
-- foldlevel=99
-- signcolumn=auto:1
-- spell=<not set>
-- winhighlight=
-- wrap=<not set>
-- winbar=
-- list=true
-- foldenable=true
-- colorcolumn=
-- winfixheight=<not set>
-- foldcolumn=0
-- winfixwidth=<not set>
-- conceallevel=3
-- concealcursor=
-- foldtext=foldtext()
-- foldnestmax=20
-- foldminlines=1
-- foldmarker={{{,}}}
-- foldignore=#
-- breakindentopt=
-- arabic=<not set>
-- scroll=19
-- foldexpr=0
-- number=true
-- statusline=%f %h%m%r%=%<%-14.(%l,%c%V%) %P
-- winblend=0
-- virtualedit=
