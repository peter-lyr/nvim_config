vim.cmd [[
cab xpx sort " 排序
cab xqc g/^\(.*\)$\n\1$/d " 去重
cab xpq sort\|g/^\(.*\)$\n\1$/d " 排序+去重
cab xd =strftime("%Y%m%d")
cab xt =strftime("%H%M%S")
cab xdt =strftime("%Y%m%d-%H%M%S")
]]
