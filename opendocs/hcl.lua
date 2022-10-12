local ts_utils = require "nvim-treesitter.ts_utils"
local q = require "vim.treesitter.query"

local M = {
  lang = "hcl",
  warn = require("user.opendocs").warn,
}

M.block_query = vim.treesitter.parse_query(
  M.lang,
  [[
    (block (
      (identifier) @type
      (string_lit (template_literal) @resource)
      (string_lit)
    )) @root
  ]]
)

M.attribute_query = vim.treesitter.parse_query(
  M.lang,
  [[
    [
      (block (
        (identifier) @attribute
        (block_start)
      )) @root
      (attribute (
        (identifier) @attribute
        (expression)
      )) @root
    ]
  ]]
)

function M.get_named_match(query, match, search_name)
  for id, node in pairs(match) do
    local name = query.captures[id]
    if name == search_name then return node end
  end
end

function M.is_matches(query, search_node, bufnr)
  for _, match, _ in query:iter_matches(search_node, bufnr) do
    local node = M.get_named_match(query, match, "root")
    if node and node:id() == search_node:id() then return true end
  end

  return false
end

function M.get_block_and_attribute(cursor_node, bufnr)
  local block_node = cursor_node
  local attribute_node
  while block_node and not M.is_matches(M.block_query, block_node, bufnr) do
    if not attribute_node and (M.is_matches(M.attribute_query, block_node, bufnr)) then attribute_node = block_node end

    block_node = block_node:parent()
  end

  if not block_node then return end

  local attribute = ""
  if attribute_node then
    for _, match, _ in M.attribute_query:iter_matches(attribute_node, bufnr) do
      attribute = q.get_node_text(M.get_named_match(M.attribute_query, match, "attribute"), bufnr)
      break
    end
  end

  return block_node, attribute
end

function M.run(bufnr)
  local cursor_node = ts_utils.get_node_at_cursor()

  local block_node, attribute = M.get_block_and_attribute(cursor_node, bufnr)

  if not block_node then
    M.warn "Cannot find appropriate block to open docs"

    return
  end

  for _, match, _ in M.block_query:iter_matches(block_node, bufnr) do
    local type = q.get_node_text(M.get_named_match(M.block_query, match, "type"), bufnr)
    local full_resource = q.get_node_text(M.get_named_match(M.block_query, match, "resource"), bufnr)

    local parts = vim.split(full_resource, "_")
    local provider = table.remove(parts, 1)
    local resource = vim.fn.join(parts, "_")
    local type_url = "resources"
    if type == "data" then type_url = "data-sources" end

    local url = "https://registry.terraform.io/providers/hashicorp/"
      .. provider
      .. "/latest/docs/"
      .. type_url
      .. "/"
      .. resource
      .. "#"
      .. attribute

    vim.fn.jobstart({ "xdg-open", url }, { detach = true })
  end
end

return M
