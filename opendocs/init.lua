local parsers = require("nvim-treesitter.parsers")

local M = {
	supported = {
		hcl = function()
			return require("opendocs.hcl")
		end,
	},
	warn = function(msg)
		vim.notify(msg, vim.log.levels.WARN, { title = "OpenDocs" })
	end,
}

function M.open(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	local lang = parsers.get_buf_lang(bufnr)

	local supported = M.supported[lang]

	if supported then
		supported().open_doc(bufnr)
	else
		M.warn("Language '" .. lang .. "' is not supported")
	end
end

function M.copy_ref(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	local lang = parsers.get_buf_lang(bufnr)

	local supported = M.supported[lang]

	if supported then
		supported().copy_ref(bufnr)
	else
		M.warn("Language '" .. lang .. "' is not supported")
	end
end

return M
