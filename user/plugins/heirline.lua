return function(config)
  config[1] = {
    hl = { fg = "fg", bg = "bg" },

    astronvim.status.component.mode({
      hl = { bold = true },
      mode_text = { padding = { left = 1, right = 1 } },
    }),

    astronvim.status.component.git_branch(),
    -- TODO: REMOVE THIS WITH v3
    astronvim.status.component.file_info(
      (astronvim.is_available("bufferline.nvim") or vim.g.heirline_bufferline)
          and { filetype = {}, filename = false, file_modified = false }
        or nil
    ),
    astronvim.status.component.git_diff(),
    astronvim.status.component.fill(),
    astronvim.status.component.cmd_info(),
    astronvim.status.component.fill(),
    astronvim.status.component.file_info({ filename = { modify = ":." } }),
    astronvim.status.component.fill(),
    astronvim.status.component.diagnostics(),
    astronvim.status.component.lsp(),
    astronvim.status.component.treesitter(),
    astronvim.status.component.nav(),
    astronvim.status.component.mode({ surround = { separator = "right" } }),
  }

  return config
end
