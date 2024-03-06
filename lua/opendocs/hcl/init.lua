local M = {
  lang = "hcl",
  warn = require("opendocs").warn,
}

function M.get_ref()
  return require("opendocs.hcl.treesitter").get_ref()
end

function M.copy_ref(_)
  local ref = M.get_ref()

  if ref == "" then
    M.warn("Cannot find appropriate block to open docs")

    return
  end

  vim.fn.setreg("+", ref)

  print("Copied: " .. ref)
end

function M.open_doc(_)
  local ref = M.get_ref()
  if ref == "" then
    M.warn("Cannot find appropriate block to open docs")

    return
  end

  local pattern = [[^\(data\.\)\?\([a-z0-9]*\)_\([a-z0-9_]*\)\.\([a-z0-9_]*\)\(\.\([a-z0-9_-]*\)\)\?]]

  if vim.fn.match(ref, pattern) == -1 then
    M.warn("Cannot find appropriate block to open docs")

    return
  end

  local _, data, provider, resource, _, _, attribute = table.unpack(vim.fn.matchlist(ref, pattern))

  local type_url = "resources"
  if data ~= "" then
    type_url = "data-sources"
  end

  local url = string.format(
    "https://registry.terraform.io/providers/hashicorp/%s/latest/docs/%s/%s#%s",
    provider,
    type_url,
    resource,
    attribute
  )

  vim.fn.jobstart({ "xdg-open", url }, { detach = true })
end

return M
