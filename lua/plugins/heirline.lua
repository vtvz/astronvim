return {
  {
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
        status.component.file_info({ filetype = false, filename = { modify = ":." } }),
        status.component.fill(),
        status.component.lsp(),
        status.component.treesitter(),
        status.component.nav(),
        status.component.mode({ surround = { separator = "right" } }),
      }

      table.insert(opts.statuscolumn, 1, require("user.utils").status_column_padding())
      table.insert(opts.tabline, 1, require("user.utils").status_column_padding())
      table.insert(opts.winbar[1], 1, require("user.utils").status_column_padding())

      return opts
    end,
  },
}
