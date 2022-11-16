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

  ["heirline"] = function(config)
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
      "ansiblels",
      "dockerls",
      "eslint",
      "html",
      "jdtls",
      "jsonls",
      "sumneko_lua",
      "rust_analyzer",
      "sqls",
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
    local null_ls = require("null-ls")

    local formatting = {}

    local timer = vim.loop.new_timer()
    timer:start(
      0,
      500,
      vim.schedule_wrap(function()
        if #formatting == 0 then
          return
        end

        local items = vim.lsp.util.get_progress_messages()
        if #items > 0 then
          return
        end

        for bufnr, _ in ipairs(formatting) do
          vim.api.nvim_buf_set_option(bufnr, "modifiable", true)

          formatting[bufnr] = nil
        end
      end)
    )

    local groovy_formatting = {
      method = null_ls.methods.FORMATTING,
      filetypes = { "groovy", "java", "Jenkinsfile" },
      name = "groovy-format.sh",
      generator = require("null-ls.helpers").generator_factory({
        args = function(params)
          vim.api.nvim_buf_set_option(params.bufnr, "modifiable", false)
          return { "$FILENAME" }
        end,
        command = "groovy-format.sh",
        on_output = function(params, done)
          vim.api.nvim_buf_set_option(params.bufnr, "modifiable", true)
          vim.defer_fn(function()
            if vim.bo[params.bufnr].modified then
              -- local current_bufnr = vim.api.nvim_get_current_buf()
              -- if params.bufnr ~= current_bufnr then
              -- end
              vim.api.nvim_cmd({ cmd = "write", mods = { noautocmd = true } }, {})
            end
          end, 100)
          formatting[params.bufnr] = nil

          local output = params.output
          if not output then
            return done()
          end

          return done({ { text = output } })
        end,
        to_stdin = false,
        to_temp_file = true,
        ignore_stderr = true,
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
    local orig_on_attach = config.on_attach

    config.on_attach = function(client, attach_bufnr)
      orig_on_attach(client, attach_bufnr)

      if client.resolved_capabilities.document_formatting then
        vim.api.nvim_create_autocmd("BufWritePre", {
          desc = "Auto format before save",
          buffer = attach_bufnr,
          callback = function(args)
            local bufnr = args.buf
            if vim.bo[bufnr].filetype == "groovy" then
              formatting[bufnr] = true
              vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

              vim.lsp.buf.format({
                timeout_ms = 60 * 1000,
                async = true,
                bufnr = bufnr,
              })
            end
          end,
        })
      end
    end
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
