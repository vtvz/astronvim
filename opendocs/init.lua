local parsers = require "nvim-treesitter.parsers"

local M = {
  supported = {
    hcl = function() return require "user.opendocs.hcl" end,
  },
  warn = function(msg) vim.notify(msg, vim.log.levels.WARN, { title = "OpenDocs" }) end,
}

function M.open(bufnr)
  bufnr = bufnr or 0

  local lang = parsers.get_buf_lang(bufnr)

  local supported = M.supported[lang]

  if supported then
    supported().run(bufnr)
  else
    M.warn("Language '" .. lang .. "' is not supported")
  end
end

return M
