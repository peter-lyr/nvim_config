local scan = require('plenary.scandir')
local data = scan.scan_dir([[D:\users\depei_liu\B\nvim091\share\nvim\runtime\pack\lazy\plugins]], {
  depth = 1,
  add_dirs = true,
})

print(#data)

for _, entry in ipairs(data) do
  print(entry)
  require('gitpushinit').initdo(entry, '!')
end
