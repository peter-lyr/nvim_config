vim.cmd([[
cab cpx sort " 排序
cab cqc g/^\(.*\)$\n\1$/d " 去重
cab cpq sort\|g/^\(.*\)$\n\1$/d " 排序+去重
cab cd =strftime("%Y%m%d")
cab ct =strftime("%H%M%S")
cab cdt =strftime("%Y%m%d-%H%M%S")
]])
