-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require("lsp_signature").setup()
    end,
  },

  -- == Examples of Overriding Plugins ==

  -- alpha-nvim is replaced by snacks.nvim in v5
  -- Dashboard customization is now in plugins/builtin.lua using snacks.nvim

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(...)
      require("astronvim.plugins.configs.luasnip")(...)

      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require("luasnip")
      luasnip.filetype_extend("javascript", { "javascriptreact" })

      -- Setup Tab/Shift-Tab for snippet navigation
      vim.keymap.set({ "i", "s" }, "<Tab>", function()
        require("luasnip").jump(1)
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        require("luasnip").jump(-1)
      end, { silent = true })
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
