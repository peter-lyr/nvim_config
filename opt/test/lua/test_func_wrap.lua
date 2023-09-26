local function func_wrap(file, func, params)
  return function()
    if type(params) == table then
      pcall(loadstring('require("' .. file .. '").' .. func .. '(' .. unpack(params) .. ')'))
    elseif type(params) == string then
      pcall(loadstring('require("' .. file .. '").' .. func .. '(' .. params .. ')'))
    else
      pcall(loadstring('require("' .. file .. '").' .. func .. '()'))
    end
  end
end

func_wrap('change_dir', 'cur', {'we', 'bwe'})()
