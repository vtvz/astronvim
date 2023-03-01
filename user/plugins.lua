return {
  init = require("user.plugins.init"),

  ["toggleterm"] = {
    open_mapping = [[<c-'>]],
  },

  ["indent-o-matic"] = {
    filetype_lua = {
      standard_widths = { 2 },
    },
  },

  ["heirline"] = require("user.plugins.heirline"),

  ["mason-null-ls"] = {
    ensure_installed = {
      "stylua",
      "shfmt",
      "prettierd",
      "hadolint",
    },
  },

  ["mason-lspconfig"] = {
    ensure_installed = {
      "sumneko_lua",
      "ansiblels",
      "dockerls",
      "eslint",
      "html",
      "jdtls",
      "jsonls",
      "sumneko_lua",
      "rust_analyzer",
      -- "sqls",
      "terraformls",
      "tflint",
      "tsserver",
      "rust_analyzer",
    },
  },

  ["treesitter"] = {
    ensure_installed = {
      "go",
      "html",
      "javascript",
      "json",
      -- "markdown",
      "hcl",
      "python",
      "query",
      "rust",
      "toml",
      "tsx",
      "typescript",
      "yaml",
      "lua",
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

  ["null-ls"] = function(config) -- overrides `require("null-ls").setup(config)`
    -- config variable is the default configuration table for the setup functino call

    -- Check supported formatters and linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      require("user.groovy_formatter").setup(),
    }
    -- set up null-ls's on_attach function
    -- NOTE: You can remove this on attach function to disable format on save

    config.on_attach = require("user.groovy_formatter").on_attach(config.on_attach)

    return config -- return final config table to use in require("null-ls").setup(config)
  end,

  ["bufferline"] = {
    options = {
      show_buffer_close_icons = false,
      show_close_icon = true,
    },
  },

  ["neo-tree"] = {
    filesystem = {
      commands = {
        live_grep_directory = function(state)
          local node = state.tree:get_node()
          if node.type ~= "directory" then
            return
          end

          require("telescope.builtin").live_grep({
            search_dirs = { node.path },
          })
        end,

        copy_file_path = function(state)
          local node = state.tree:get_node()
          local path = vim.fn.fnamemodify(node.path, ":.")
          vim.fn.setreg("+", path)
          print("Copied path to current file: " .. path)
        end,
      },
      window = {
        mappings = {
          ["w"] = "live_grep_directory",
          ["<C-o>"] = "copy_file_path",
        },
      },
    },
  },
}
