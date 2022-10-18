return {
  -- walkins amogus
  ["tamton-aquib/duck.nvim"] = {
    config = function()
      local d = require("duck")

      d.setup({ character = "ඞ", speed = -400, width = 1 })

      vim.keymap.set("n", "<leader>ds", function()
        d.hatch()
      end, { desc = "Spawn Amogus" })

      vim.keymap.set("n", "<leader>dd", function()
        if #d.ducks_list > 0 then
          d.cook()
        end
      end, { desc = "Stub Amogus" })

      vim.keymap.set("n", "<leader>dD", function()
        while #d.ducks_list > 0 do
          d.cook()
        end
      end, { desc = "Stub all Amoguses" })
    end,
  },

  -- Save with sudo
  ["lambdalisue/suda.vim"] = {
    cmd = {
      "SudaWrite",
    },
  },

  ["nvim-treesitter/playground"] = {
    cmd = {
      "TSPlaygroundToggle",
      "TSCaptureUnderCursor",
      "TSHighlightCapturesUnderCursor",
    },
  },

  -- Surround with things
  ["tpope/vim-surround"] = {},

  -- Smooth scrolling
  ["declancm/cinnamon.nvim"] = {
    config = function()
      require("cinnamon").setup()
    end,
  },

  ["hrsh7th/cmp-nvim-lua"] = {
    after = "nvim-cmp",
    config = function()
      astronvim.add_user_cmp_source({ name = "nvim_lua", priority = 1000 })
    end,
  },

  ["hrsh7th/cmp-nvim-lsp-signature-help"] = {
    after = "nvim-cmp",
    config = function()
      astronvim.add_user_cmp_source({ name = "nvim_lsp_signature_help", priority = 1000 })
    end,
  },

  ["milisims/nvim-luaref"] = {},

  ["simrat39/rust-tools.nvim"] = {
    after = "mason-lspconfig.nvim", -- make sure to load after mason-lspconfig
    config = function()
      local rt = require("rust-tools")

      rt.setup({
        server = astronvim.lsp.server_settings("rust_analyzer"), -- get the server settings and built in capabilities/on_attach
      })

      rt.inlay_hints.enable()
    end,
  },
}
