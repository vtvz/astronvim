---@type LazySpec
return {
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require("lsp_signature").setup()
    end,
  },

  {
    "windwp/nvim-autopairs",
    enabled = false,
  },

  {
    "kevinhwang91/nvim-ufo",
    enabled = false,
  },
}
