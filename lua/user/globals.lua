P = function(v)
  print(vim.inspect(v))
  return v
end

K = function(v)
  if type(v) ~= "table" then
    return P(v)
  end

  local table = {}
  for key, value in pairs(v) do
    table[key] = type(value) .. " => " .. tostring(value)
  end

  return P(table)
end

RELOAD = function(...)
  local modules = vim.tbl_flatten({ ... })

  for _, module in ipairs(modules) do
    require("plenary.reload").reload_module(module)
  end

  return require(modules[1])
end

-- backwards compatibility
table.unpack = table.unpack or unpack
