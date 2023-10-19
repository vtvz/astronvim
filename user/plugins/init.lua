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
  require("user.plugins.heirline"),
  {
    -- TODO: Consider to remove it
    "folke/neodev.nvim",
    lazy = false,
    cond = false,
    opts = {},
    config = function()
      local neodev = require("neodev")
      neodev.setup({
        override = function(_, library)
          library.enabled = true
          library.plugins = true
        end,
      })
    end,
  },
  {
    "fatih/vim-go",
    event = "VeryLazy",
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
  },
  {
    "IndianBoy42/tree-sitter-just",
    event = "VeryLazy",
    after = "nvim-treesitter",
    config = function()
      require("tree-sitter-just").setup({})
    end,
  },
  -- walkins amogus
  {
    "giusgad/pets.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "giusgad/hologram.nvim" },
    config = function(_, opts)
      require("user.pets").setup(opts)
    end,
  },
  {
    "Joorem/vim-haproxy",
    event = "VeryLazy",
  },
  {
    -- Jinja2 template
    "HiPhish/jinja.vim",
    url = "https://gitlab.com/HiPhish/jinja.vim.git",
    event = "VeryLazy",
  },
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
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("nvim-surround").setup(opts)
    end,
  },
  -- Smooth scrolling
  {
    "declancm/cinnamon.nvim",
    event = "VeryLazy",
    opts = {
      default_delay = 1,
    },
    config = function(_, opts)
      require("cinnamon").setup(opts)
    end,
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
  { "milisims/nvim-luaref", lazy = false },
  -- done
  {
    "simrat39/rust-tools.nvim",
    event = "VeryLazy",
    dependencies = "mason-lspconfig.nvim", -- make sure to load after mason-lspconfig
  },
  {
    "rcarriga/nvim-notify",
    event = "UIEnter",
    config = function(plugin, opts)
      require("plugins.configs.notify")(plugin, opts)

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
        "just",
        "lua",
        "python",
        "query",
        "rust",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "yaml",
        -- "markdown",
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
    "neovim/nvim-lspconfig",
    -- dependencies = { "folke/neodev.nvim" },
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
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    opts = {
      ensure_installed = {
        "hadolint",
        "nginx-language-server",
        "prettierd",
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
    config = function(plugin, opts)
      require("plugins.configs.mason-null-ls")(plugin, opts)
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
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
    "nicwest/vim-camelsnek",
    event = "VeryLazy",
  },
  {
    "dahu/vim-fanfingtastic",
    event = "VeryLazy",
  },
  {
    "nvim-pack/nvim-spectre",
    cmd = {
      "Spectre",
    },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    opts = {
      -- open_cmd = "enew",
      color_devicons = false,
      mapping = {
        ["replace_cmd"] = {
          map = "<leader>rC",
        },
      },
    },
    config = function(plugin, opts)
      require("spectre").setup(opts)
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      cache_picker = { num_pickers = 5 },

      pickers = {
        find_files = {
          mappings = {
            n = {
              ["<leader>fw"] = function(prompt_bufnr)
                local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                local opts = {
                  default_text = current_picker:_get_prompt(),
                }

                require("telescope.actions").close(prompt_bufnr)
                require("telescope.builtin").live_grep(opts)
              end,
            },
          },
        },
        live_grep = {
          mappings = {
            n = {
              ["<leader>ff"] = function(prompt_bufnr)
                local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                local opts = {
                  default_text = current_picker:_get_prompt(),
                }

                require("telescope.actions").close(prompt_bufnr)
                require("telescope.builtin").find_files(opts)
              end,
            },
          },
        },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_gitignored = false,
          always_show = {
            ".gitignore",
            ".env",
          },
          never_show = {
            ".directory",
          },
          never_show_by_pattern = {
            ".null-ls_*",
          },
        },
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
        },
        window = {
          mappings = {
            ["w"] = "live_grep_directory",
          },
        },
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      open_mapping = [[<c-'>]],
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function(_, opts)
      require("todo-comments").setup(opts)
    end,
  },
  {
    "Wansmer/treesj",
    keys = { "<space>m", "<space>M" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })
      -- For use default preset and it work with dot
      vim.keymap.set("n", "<leader>m", require("treesj").toggle)
      -- For extending default preset with `recursive = true`, but this doesn't work with dot
      vim.keymap.set("n", "<leader>M", function()
        require("treesj").toggle({ split = { recursive = true } })
      end)
    end,
  },
}
