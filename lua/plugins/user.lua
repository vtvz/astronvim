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
    "L3MON4D3/LuaSnip",
    config = function(...)
      require("astronvim.plugins.configs.luasnip")(...)

      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require("luasnip")
      luasnip.filetype_extend("javascript", { "javascriptreact" })

      -- require("luasnip.loaders.from_vscode").lazy_load({
      --   paths = { vim.fn.stdpath("config") .. "/snippets" },
      -- })

      require("luasnip.loaders.from_snipmate").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snipmate" },
      })

      -- Setup Tab/Shift-Tab for snippet navigation
      vim.keymap.set({ "i", "s" }, "<Tab>", function()
        if luasnip.jumpable(1) then
          luasnip.jump(1)
        else
          return "<Tab>"
        end
      end, { silent = true, expr = true })

      vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          return "<S-Tab>"
        end
      end, { silent = true, expr = true })
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
