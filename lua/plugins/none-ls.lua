---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, config)
    local null_ls = require("null-ls")
    config.sources = {
      require("user.groovy_formatter").setup(),

      null_ls.builtins.formatting.shfmt.with({
        extra_args = { "-i", "2" },
      }),
    }
    -- set up null-ls's on_attach function
    -- NOTE: You can remove this on attach function to disable format on save

    config.on_attach = require("user.groovy_formatter").on_attach(config.on_attach)

    return config
  end,
}
