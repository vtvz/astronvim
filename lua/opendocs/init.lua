local M = {
  supported = {
    hcl = function()
      return require("opendocs.hcl")
    end,
    terraform = function()
      return require("opendocs.hcl")
    end,
    json = function()
      return require("opendocs.json")
    end,
  },
  warn = function(msg)
    vim.notify(msg, vim.log.levels.WARN, { title = "OpenDocs" })
  end,
}

function M.open(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)

  local supported = M.supported[lang]

  if supported then
    supported().open_doc(bufnr)
  else
    M.warn("Language '" .. (lang or "unknown") .. "' is not supported")
  end
end

function M.copy_ref(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)

  local supported = M.supported[lang]

  if supported then
    supported().copy_ref(bufnr)
  else
    M.warn("Language '" .. (lang or "unknown") .. "' is not supported")
  end
end

return M
