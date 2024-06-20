local null_ls = require("null-ls")

return {
  {
    "goolord/alpha-nvim",
    opts = function(_, opts) -- override the options using lazy.nvim
      opts.section.header.val = { -- change the header section value
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
      }
    end,
  },
  {
    "nvim-treesitter/playground",
    cmd = {
      "TSPlaygroundToggle",
      "TSCaptureUnderCursor",
      "TSHighlightCapturesUnderCursor",
    },
  },
  {
    -- override nvim-autopairs plugin
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- add cmp source as dependency of cmp
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      -- add cmp source as dependency of cmp
    },
    -- override the options table that is used in the `require("cmp").setup()` call
    opts = function(_, opts)
      -- opts parameter is the default options table
      -- the function is lazy loaded so cmp is able to be required
      local cmp = require("cmp")
      -- modify the sources part of the options table
      opts.sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500 },
        { name = "path", priority = 250 },
        { name = "nvim_lua", priority = 700 }, -- add new source
        { name = "nvim_lsp_signature_help", priority = 700 }, -- add new source
      })

      -- return the new table to be used
      return opts
    end,
  },
  {
    "rcarriga/nvim-notify",
    event = "UIEnter",
    config = function(plugin, opts)
      require("astronvim.plugins.configs.notify")(plugin, opts)

      local banned_messages = {
        "Accessing client.resolved_capabilities is deprecated",
        "Client %d+ quit with exit code %d+ and signal %d+",
        "[LSP][%s+] timeout",
        'Error detected while processing LspAttach Autocommands for "*"',
      }

      local original_notify = vim.notify

      local filtered_notify = function(msg, ...)
        if type(msg) == "string" then
          for _, banned in ipairs(banned_messages) do
            if string.match(msg, banned) then
              print(msg)
              return
            end
          end
        end

        original_notify(msg, ...)
      end

      vim.notify = filtered_notify
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "go",
        "hcl",
        "html",
        "javascript",
        "json",
        -- "just",
        "lua",
        "python",
        "query",
        "rust",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "yaml",
      },
      context_commentstring = {
        enable = true,
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<M-w>", -- maps in normal mode to init the node/scope selection
          node_incremental = "<M-w>", -- increment to the upper named parent
          node_decremental = "<M-C-w>", -- decrement to the previous node
          scope_incremental = "<M-e>", -- increment to the upper scope (as defined in locals.scm)
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    -- dependencies = { "folke/neodev.nvim" },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "ansiblels",
        "dockerls",
        "eslint",
        "html",
        "jdtls",
        "jsonls",
        "jsonnet_ls",
        "lua_ls",
        "rust_analyzer",
        "terraformls",
        "tflint",
        "tsserver",
      },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = {
        "hadolint",
        "nginx-language-server",
        "prettier",
        "shellcheck",
        "shfmt",
        "stylua",
      },
      handlers = {
        stylua = function(_, _)
          null_ls.register(null_ls.builtins.formatting.stylua)
        end,
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(plugin, opts) -- overrides `require("null-ls").setup(config)`
      -- config variable is the default configuration table for the setup functino call

      -- Check supported formatters and linters
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

      opts.sources = {
        require("user.groovy_formatter").setup(),
        -- require("null-ls").builtins.diagnostics.tfsec,
        null_ls.builtins.formatting.shfmt.with({
          extra_args = { "-i", "2" },
        }),
      }
      -- set up null-ls's on_attach function
      -- NOTE: You can remove this on attach function to disable format on save

      opts.on_attach = require("user.groovy_formatter").on_attach(opts.on_attach)

      return opts
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      -- open_mapping = [[<c-'>]],
    },
  },
  {
    "stevearc/dressing.nvim",
    opts = {
      select = { backend = { "builtin" } },
    },
  },
  --[[
  {
    "AstroNvim/astrocommunity",
    { import = "astrocommunity.motion.harpoon" },
  },
  ]]
}
