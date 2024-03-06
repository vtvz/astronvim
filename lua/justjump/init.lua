local M = {}

function M.popup()
  vim.ui.select(vim.t.bufs, {
    prompt = "Select tab",
    format_item = function(bufnr)
      local file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":.")
      local path_parts = vim.fn.reverse(vim.fn.split(file, "/"))
      local first_part = vim.fn.reverse(vim.list_slice(path_parts, 1, 2))
      local second_part = vim.list_slice(path_parts, 3)

      local label_parts = vim.list_extend({ vim.fn.join(first_part, "/") }, second_part)
      local label = vim.fn.join(label_parts, " ← ")
      if label == "" then
        label = "Untitled"
      end

      if bufnr == vim.api.nvim_get_current_buf() then
        label = "→ " .. label
      end

      return label
    end,
  }, function(selected)
    vim.cmd.b(selected)
  end)
end

return M
