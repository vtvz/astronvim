local M = {
  lang = "json",
  warn = require("opendocs").warn,
}

function M.get_ref()
  return require("opendocs.json.treesitter").get_ref()
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
  M.warn("You crazy if you think you can open docs for random json object")
end

return M
