--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below

-- You can think of a Lua "table" as a dictionary like data structure the
-- normal format is "key = value". These also handle array like data structures
-- where a value with no key simply has an implicit numeric key

P = function(v)
  print(vim.inspect(v))
  return v
end

K = function(v)
  local table = {}
  for key, value in pairs(v) do
    table[key] = type(value) .. " => " .. tostring(value)
  end

  return P(table)
end

RELOAD = function(...)
  local modules = vim.tbl_flatten { ... }

  for _, module in ipairs(modules) do
    package.loaded[module] = nil
  end

  return require(modules[1])
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
  },

  options = function(options)
    options.opt.cmdheight = 1
    options.opt.title = true

    return options
  end,

  mappings = {
    n = {
      ["<leader>w"] = { "<cmd>wa<cr>", desc = "Save" },
      ["gr"] = {
        function() require("telescope.builtin").lsp_references() end,
        desc = "Search references",
      },
      -- replace with dynamic because plain sucks
      ["<leader>lG"] = {
        function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end,
        desc = "Search workspace symbols",
      },
      ["<leader>ss"] = { "<CMD>Telescope resume<CR>", desc = "Resume last Telescope search" },

      -- Copy current file relative path
      ["<leader><C-o>"] = {
        function()
          local path = vim.fn.expand "%"
          vim.fn.setreg("+", path)
          print("Copied path to current file: " .. path)
        end,
        desc = "Copy current file relative path",
      },
      ["<CR>"] = { "o<Esc>", desc = "New line without entering insert" },

      ["gK"] = { function() require("user.opendocs").open() end, desc = "Open online documentation" },
      ["yK"] = { function() require("user.opendocs").copy_ref() end, desc = "Copy reference" },
    },
  },

  -- ["mason-null-ls"] = {
  --   ["setup_handlers"] = {
  --     stylua = function() require("null-ls").register(require("null-ls").builtins.formatting.stylua) end,
  --   },
  -- },

  plugins = {
    init = {
      {
        -- Save with sudo
        "lambdalisue/suda.vim",
        cmd = {
          "SudaWrite",
        },
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
        -- Surround with things
        "tpope/vim-surround",
      },
      {
        -- Smooth scrolling
        "declancm/cinnamon.nvim",
        config = function() require("cinnamon").setup() end,
      },
      {
        "hrsh7th/cmp-nvim-lua",
        after = "nvim-cmp",
        config = function() astronvim.add_user_cmp_source("nvim_lua", 700) end,
      },
      {
        "hrsh7th/cmp-nvim-lsp-signature-help",
        after = "nvim-cmp",
        config = function() astronvim.add_user_cmp_source("nvim_lsp_signature_help", 700) end,
      },
      { "milisims/nvim-luaref" },
    },

    toggleterm = {
      open_mapping = [[<c-'>]],
    },

    ["indent-o-matic"] = {
      filetype_lua = {
        standard_widths = { 2 },
      },
    },

    heirline = function(config)
      config[1][1] =
        astronvim.status.component.mode { hl = { bold = true }, mode_text = { padding = { left = 1, right = 1 } } }
      table.insert(config[1], 6, astronvim.status.component.fill())
      table.insert(config[1], 7, astronvim.status.component.file_info { filename = { modify = ":." } })

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
      },
    },
    ["null-ls"] = function(config) -- overrides `require("null-ls").setup(config)`
      -- config variable is the default configuration table for the setup functino call
      local null_ls = require "null-ls"

      local groovy_formatting = {
        method = null_ls.methods.FORMATTING,
        filetypes = { "groovy", "java", "Jenkinsfile" },
        name = "groovy-format.sh",
        generator = require("null-ls.helpers").formatter_factory {
          args = { "$FILENAME" },
          command = "groovy-format.sh",
          to_stdin = false,
          to_temp_file = true,
          from_temp_file = true,
          timeout = 60 * 1000,
        },
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
                vim.lsp.buf.format {
                  timeout_ms = 60 * 1000,
                  async = true,
                }
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
            if node.type ~= "directory" then return end

            require("telescope.builtin").live_grep {
              search_dirs = { node.path },
            }
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
  },

  polish = function()
    vim.opt.matchpairs:append { "<:>" }

    vim.api.nvim_create_user_command("Messages", function()
      local messages_output = vim.api.nvim_exec(":messages", true)

      if MESSAGES_BUFNR ~= nil and vim.fn.buflisted(MESSAGES_BUFNR) == 0 then MESSAGES_BUFNR = nil end

      if not MESSAGES_BUFNR then
        MESSAGES_BUFNR = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_set_option(MESSAGES_BUFNR, "buftype", "nofile")
        vim.api.nvim_buf_set_name(MESSAGES_BUFNR, ":messages")
      end

      vim.api.nvim_buf_set_option(MESSAGES_BUFNR, "modifiable", true)
      vim.api.nvim_buf_set_lines(MESSAGES_BUFNR, 0, -1, true, vim.split(messages_output, "\n"))
      vim.api.nvim_buf_set_option(MESSAGES_BUFNR, "modifiable", false)

      vim.api.nvim_set_current_buf(MESSAGES_BUFNR)
      vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 0 })
    end, { desc = "Show messages in a buffer" })

    local au = vim.api.nvim_create_augroup("vtvz_test", { clear = true })

    vim.api.nvim_create_autocmd("BufWritePre", {
      desc = "Trailing spaces",
      group = au,
      callback = function()
        -- Remove trailing spaces
        vim.api.nvim_command ":%s/\\s\\+$//e"
        -- Remove ending lines
        pcall(vim.api.nvim_command, ":%s#\\($\\n\\s*\\)\\+\\%$##")
      end,
    })

    local function open_neotree(cur_win)
      cur_win = cur_win or vim.api.nvim_get_current_win()

      local _, err = pcall(vim.api.nvim_command, "Neotree action=show")
      if err then
        vim.defer_fn(function() open_neotree(cur_win) end, 100)

        return
      else
        -- 961x1280
        vim.api.nvim_set_current_win(cur_win)
      end
    end

    vim.api.nvim_create_autocmd("VimEnter", {
      desc = "On launch",
      group = au,
      callback = function()
        vim.defer_fn(function() open_neotree() end, 100)
      end,
    })

    vim.api.nvim_create_autocmd("UIEnter", {
      desc = "Suppress some notifications",
      group = au,
      callback = function()
        local banned_messages = {
          "Accessing client.resolved_capabilities is deprecated",
        }

        local original_notify = vim.notify

        local filtered_notify = function(msg, ...)
          if type(msg) == "string" then
            for _, banned in ipairs(banned_messages) do
              if string.find(msg, banned, 1, true) then
                print(msg)
                return
              end
            end
          end

          original_notify(msg, ...)
        end

        vim.notify = filtered_notify
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      desc = "On launch",
      pattern = "SessionLoadPost",
      group = au,
      callback = function()
        vim.defer_fn(function() open_neotree() end, 100)
      end,
    })

    vim.api.nvim_create_autocmd("BufAdd", {
      desc = "Add Russian Layout",
      group = au,
      callback = function()
        local buf = tonumber(vim.fn.expand "<abuf>")

        vim.api.nvim_buf_set_option(buf, "keymap", "russian-jcukenwin")
        vim.api.nvim_buf_set_option(buf, "iminsert", 0)
        vim.api.nvim_buf_set_option(buf, "imsearch", -1)
      end,
    })

    vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
      desc = "Add title",
      group = au,
      callback = function()
        vim.opt.titlestring = ""
          .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          .. " ("
          .. vim.fn.fnamemodify(vim.fn.getcwd(), ":h:t")
          .. ")"
      end,
    })

    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
      desc = "Set dockerfile filetype",
      group = au,
      pattern = "Dockerfile*",
      callback = function() vim.bo.filetype = "dockerfile" end,
    })
  end,
}

return config
