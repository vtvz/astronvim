---@type LazySpec
return {
  { "windwp/nvim-autopairs", enabled = false },

  { "kevinhwang91/nvim-ufo", enabled = false },

  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  { "max397574/better-escape.nvim", enabled = false },

  -- v6: neoconf.nvim is incompatible with the new vim.lsp.config API
  { "folke/neoconf.nvim", enabled = false },

  -- deno-nvim uses old lspconfig API, broken on nvim 0.11+; pulled in by typescript-all-in-one
  { "sigmasd/deno-nvim", enabled = false },
}
