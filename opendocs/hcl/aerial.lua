local handlers = {
  function(item, _)
    if item.kind ~= "Class" then
      return false
    end

    local pattern = [[^\(resource\|data\) "\(.*\)" "\(.*\)"$]]

    if vim.fn.match(item.name, pattern) == -1 then
      return false
    end

    local result = ""
    local _, type, resource, name = table.unpack(vim.fn.matchlist(item.name, pattern))
    if type ~= "resource" then
      result = result .. type .. "."
    end

    return true, result .. resource .. "." .. name
  end,

  function(item, _)
    if item.kind ~= "Class" then
      return false
    end

    local pattern = [[^variable "\(.*\)"$]]

    if vim.fn.match(item.name, pattern) == -1 then
      return false
    end

    local _, name = table.unpack(vim.fn.matchlist(item.name, pattern))

    return true, "var." .. name
  end,

  function(item, _)
    if item.kind ~= "Class" then
      return false
    end

    local pattern = [[^output "\(.*\)"$]]

    if vim.fn.match(item.name, pattern) == -1 then
      return false
    end

    local _, name = table.unpack(vim.fn.matchlist(item.name, pattern))

    return true, name
  end,

  function(item, _)
    if item.name ~= "locals" or item.kind ~= "Class" then
      return false
    end

    return true, "local"
  end,

  function(item, previous)
    if item.kind == "Variable" then
      return true, previous .. "." .. item.name
    end

    return false
  end,
}

function M.get_ref(_)
  local location = require("aerial").get_location(true)

  local name = ""
  for _, item in ipairs(location) do
    for _, handler in ipairs(handlers) do
      local success, result = handler(item, name)
      if success then
        name = result
        break
      end
    end
  end
  return name
end

return M
