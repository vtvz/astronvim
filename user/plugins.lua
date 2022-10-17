return {
  toggleterm = {
    open_mapping = [[<c-'>]],
  },

  ["indent-o-matic"] = {
    filetype_lua = {
      standard_widths = { 2 },
    },
  },

  heirline = function(config)
    config[1][1] = astronvim.status.component.mode({
      hl = { bold = true },
      mode_text = { padding = { left = 1, right = 1 } },
    })
    table.insert(config[1], 6, astronvim.status.component.fill())
    table.insert(config[1], 7, astronvim.status.component.file_info({ filename = { modify = ":." } }))

    return config
  end,
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
      "ansible-language-server",
      "dockerfile-language-server",
      "eslint-lsp",
      "hadolint",
      "html-lsp",
      "jdtls",
      "json-lsp",
      "lua-language-server",
      "rust-analyzer",
      "sqls",
      "terraform-ls",
      "tflint",
      "typescript-language-server",
      "rust_analyzer",
    },
  },
  ["null-ls"] = function(config) -- overrides `require("null-ls").setup(config)`
    -- config variable is the default configuration table for the setup functino call
    local null_ls = require("null-ls")

    local groovy_formatting = {
      method = null_ls.methods.FORMATTING,
      filetypes = { "groovy", "java", "Jenkinsfile" },
      name = "groovy-format.sh",
      generator = require("null-ls.helpers").formatter_factory({
        args = { "$FILENAME" },
        command = "groovy-format.sh",
        to_stdin = false,
        to_temp_file = true,
        from_temp_file = true,
        timeout = 60 * 1000,
      }),
    }

    -- Check supported formatters and linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      groovy_formatting,
    }
    -- set up null-ls's on_attach function
    -- NOTE: You can remove this on attach function to disable format on save
    config.on_attach = function(client)
      if client.resolved_capabilities.document_formatting then
        vim.api.nvim_create_autocmd("BufWritePre", {
          desc = "Auto format before save",
          pattern = "<buffer>",
          callback = function()
            if vim.bo.filetype == "groovy" then
              vim.lsp.buf.format({
                timeout_ms = 60 * 1000,
                async = true,
              })
            end
          end,
        })
      end
    end
    return config -- return final config table to use in require("null-ls").setup(config)
  end,

  bufferline = {
    options = {
      show_buffer_close_icons = false,
      show_close_icon = true,
    },
  },

  treesitter = {
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
    ensure_installed = {
      "go",
      "html",
      "javascript",
      "json",
      "markdown",
      "python",
      "query",
      "rust",
      "toml",
      "tsx",
      "typescript",
      "yaml",
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
