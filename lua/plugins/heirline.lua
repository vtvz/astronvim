return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require("astroui.status")

    opts.statusline = {
      hl = { fg = "fg", bg = "bg" },
      status.component.mode({
        hl = { bold = true },
        mode_text = { padding = { left = 1, right = 1 } },
      }),
      status.component.git_branch(),
      -- TODO: REMOVE THIS WITH v3
      status.component.file_info({ filetype = {}, filename = false, file_modified = false }),
      status.component.git_diff(),
      status.component.diagnostics(),
      status.component.fill(),
      status.component.cmd_info(),
      status.component.fill(),
      status.component.file_info({ filename = { modify = ":." } }),
      status.component.fill(),
      status.component.lsp(),
      status.component.treesitter(),
      status.component.nav(),
      status.component.mode({ surround = { separator = "right" } }),
    }

    opts.statuscolumn = {
      init = function(self)
        self.bufnr = vim.api.nvim_get_current_buf()
      end,
      {
        provider = function()
          if require("user.utils").neotree_is_open() or vim.bo.ft == "alpha" then
            return ""
          end

          return "                               "
        end,
      },
      status.component.foldcolumn(),
      status.component.numbercolumn(),
      status.component.signcolumn(),
    }

    return opts
  end,
}