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
    "folke/neodev.nvim",
    lazy = false,
    init = function()
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
      require("pets").setup(opts)
    end,
  },
  {
    "tamton-aquib/duck.nvim",
    event = "VeryLazy",
    config = function()
      local d = require("duck")
      local susus = {
        { character = "ඞ", width = 1 },
        { character = "🦊", width = 2 },
        -- { character = "🦀", width = 2 },
      }

      vim.keymap.set("n", "<leader>ds", function()
        local sus = susus[(vim.fn.rand() % #susus) + 1]

        -- local settings = vim.tbl_extend("keep", sus, { speed = -(vim.fn.rand() % 900) })

        -- d.setup(settings)

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
    dependencies = { "folke/neodev.nvim" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "folke/neodev.nvim" },
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
          local null_ls = require("null-ls")
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
      }
      -- set up null-ls's on_attach function
      -- NOTE: You can remove this on attach function to disable format on save

      opts.on_attach = require("user.groovy_formatter").on_attach(opts.on_attach)

      return opts
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = { cache_picker = { num_pickers = 5 } },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
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
}
