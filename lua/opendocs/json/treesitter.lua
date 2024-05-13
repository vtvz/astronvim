local M = {
  handlers = {
    object = function(item, name)
      local text = item.captures.key.text
      if name ~= "" then
        text = "." .. text
      end

      return name .. text
    end,

    array = function(_, name)
      return name .. "[]"
    end,
  },
}

function M.ts_match(query, node, root_name)
  if not root_name then
    root_name = "root"
  end

  for pattern, item, metadata in query:iter_matches(node, 0, 0, -1, { all = true }) do
    local captures = {}
    for id, capture in pairs(item) do
      local name = query.captures[id]
      captures[name] = {
        node = capture,
        text = vim.treesitter.get_node_text(capture, 0),
        metadata = metadata[id] or {},
      }
    end

    if captures[root_name] and captures[root_name].node:id() == node:id() then
      return { pattern = pattern, metadata = metadata, captures = captures }
    end
  end
end

function M.get_parts()
  local path = {}

  local node = vim.treesitter.get_node()

  local query = assert(vim.treesitter.query.get("json", "blocks"), "No query")
  while node do
    local result = M.ts_match(query, node)

    if result then
      table.insert(path, 1, result)
    end

    node = node:parent()
  end
  return path
end

function M.get_ref(_)
  local parts = M.get_parts()

  local ref = ""
  for _, path_part in ipairs(parts) do
    local handler = M.handlers[path_part.metadata.type]

    local abort = false

    ref, abort = handler(path_part, ref)
    if abort then
      break
    end
  end

  return ref
end

return M
