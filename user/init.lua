require("user.globals")

local ok, neodev = pcall(require, "neodev")
if ok then
  neodev.setup({
    override = function(_, library)
      library.enabled = true
      library.plugins = true
    end,
  })
end

local config = {
  header = {
    "╔═══════════════════════════════════════╗",
    "║                                       ║",
    "║  ██╗   ██╗████████╗██╗   ██╗███████╗  ║",
    "║  ██║   ██║╚══██╔══╝██║   ██║╚══███╔╝  ║",
    "║  ██║   ██║   ██║   ██║   ██║  ███╔╝   ║",
    "║  ╚██╗ ██╔╝   ██║   ╚██╗ ██╔╝ ███╔╝    ║",
    "║   ╚████╔╝    ██║    ╚████╔╝ ███████╗  ║",
    "║    ╚═══╝     ╚═╝     ╚═══╝  ╚══════╝  ║",
    "║                                       ║",
    "╚═══════════════════════════════════════╝",
  },

  updater = {
    channel = "stable", -- "stable" or "nightly"
  },

  lsp = {
    mappings = {
      n = {
        ["gr"] = false, -- replace with telescope
      },
    },
    formatting = {
      filter = function(client)
        -- disable formatting for sumneko_lua
        if client.name == "sumneko_lua" then
          return false
        end
        return true
      end,
      format_on_save = {
        ignore_filetypes = {
          "groovy",
        },
      },
    },
    skip_setup = { "rust_analyzer" },

    on_attach = function(client, bufnr)
      if client.name == "rust_analyzer" then
        local rt = require("rust-tools")

        vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
      end

      require("lsp_signature").on_attach({
        floating_window = false,
      }, bufnr)

      -- -- Hover actions
      -- vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- -- Code action groups
      -- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },

  options = function(options)
    options.opt.cmdheight = 1
    options.opt.title = true

    return options
  end,

  mappings = {
    n = {
      -- ["<leader>gg"] = {
      --   function()
      --     astronvim.toggle_term_cmd({ cmd = "lazygit", hidden = true, count = 150 })
      --   end,
      --   desc = "ToggleTerm lazygit",
      -- },
      ["<leader>w"] = { "<cmd>wa<cr>", desc = "Save" },
      ["gr"] = {
        function()
          require("telescope.builtin").lsp_references()
        end,
        desc = "Search references",
      },
      -- replace with dynamic because plain sucks
      ["<leader>lG"] = {
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols()
        end,
        desc = "Search workspace symbols",
      },
      ["<leader>ss"] = { "<CMD>Telescope resume<CR>", desc = "Resume last Telescope search" },

      -- Copy current file relative path
      ["<leader><C-o>"] = {
        function()
          local path = vim.fn.expand("%")
          vim.fn.setreg("+", path)
          print("Copied path to current file: " .. path)
        end,
        desc = "Copy current file relative path",
      },

      ["gK"] = {
        function()
          require("opendocs").open()
        end,
        desc = "Open online documentation",
      },
      ["yK"] = {
        function()
          require("opendocs").copy_ref()
        end,
        desc = "Copy reference",
      },
    },
  },

  ["mason-null-ls"] = {
    ["setup_handlers"] = {
      -- stylua = function() require("null-ls").register(require("null-ls").builtins.formatting.stylua) end,
      shfmt = function()
        require("null-ls").register(require("null-ls").builtins.formatting.shfmt.with({
          extra_args = { "--indent", "2", "--space-redirects" },
        }))
      end,
    },
  },

  plugins = require("user.plugins"),
}

return config
