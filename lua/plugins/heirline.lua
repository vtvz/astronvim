return {
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    enabled = false,
    opts = {
      width = 150,
      buffers = {
        right = { enabled = false },
      },
      mappings = {
        -- When `true`, creates all the mappings that are not set to `false`.
        --- @type boolean
        enabled = true,
        -- Sets a global mapping to Neovim, which allows you to toggle the plugin.
        -- When `false`, the mapping is not created.
        --- @type string
        toggle = "<Leader>NN",
        -- Sets a global mapping to Neovim, which allows you to toggle the left side buffer.
        -- When `false`, the mapping is not created.
        --- @type string
        toggleLeftSide = "<Leader>Nql",
        -- Sets a global mapping to Neovim, which allows you to toggle the right side buffer.
        -- When `false`, the mapping is not created.
        --- @type string
        toggleRightSide = "<Leader>Nqr",
        -- Sets a global mapping to Neovim, which allows you to increase the width (+5) of the main window.
        -- When `false`, the mapping is not created.
        --- @type string | { mapping: string, value: number }
        widthUp = "<Leader>N=",
        -- Sets a global mapping to Neovim, which allows you to decrease the width (-5) of the main window.
        -- When `false`, the mapping is not created.
        --- @type string | { mapping: string, value: number }
        widthDown = "<Leader>N-",
        -- Sets a global mapping to Neovim, which allows you to toggle the scratchPad feature.
        -- When `false`, the mapping is not created.
        --- @type string
        scratchPad = "<Leader>Ns",
      },
    },
  },
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
