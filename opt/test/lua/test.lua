-- vim.cmd(string.format([[ call feedkeys("\<esc>:AsyncRun rg --no-heading --with-filename --line-number --column --smart-case --no-ignore -g !*.js [\u4e00-\u9fa5]+ \<c-r>=expand('%:p:h')\<cr>") ]]))


-- Define the table to be sorted
local myTable = { 'apple', 'banana', 'cherry', 'date', }

-- Define the custom comparator function
local function reverseSort(a, b)
  return a < b
end

-- Sort the table in reverse order
table.sort(myTable, reverseSort)

-- Print the sorted table
for i, v in ipairs(myTable) do
  print(i, v)
end
