return {
  -- alpha-nvim is replaced by snacks.nvim in v5
  -- Dashboard customizations can be done through snacks.nvim dashboard
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
╔═══════════════════════════════════════╗
║                                       ║
║  ██╗   ██╗████████╗██╗   ██╗███████╗  ║
║  ██║   ██║╚══██╔══╝██║   ██║╚══███╔╝  ║
║  ██║   ██║   ██║   ██║   ██║  ███╔╝   ║
║  ╚██╗ ██╔╝   ██║   ╚██╗ ██╔╝ ███╔╝    ║
║   ╚████╔╝    ██║    ╚████╔╝ ███████╗  ║
║    ╚═══╝     ╚═╝     ╚═══╝  ╚══════╝  ║
║                                       ║
╚═══════════════════════════════════════╝]],
        },
      },
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
  -- nvim-cmp is replaced by blink.cmp in v5
  -- blink.cmp has built-in support for LSP, path, snippets, and buffer
  -- LuaSnip integration requires additional setup via blink-cmp-luasnip
  {
    "saghen/blink.cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      { "saghen/blink-cmp-luasnip", optional = true },
    },
    opts = function(_, opts)
      -- Use default sources: lsp, path, snippets, buffer
      -- If you want luasnip specifically, install saghen/blink-cmp-luasnip
      return opts
    end,
  },
  -- nvim-notify is replaced by snacks.nvim in v5
  -- Notification filtering can be done through snacks.notify
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- Merge with existing snacks config if any
      opts = opts or {}
      opts.notifier = opts.notifier or {}

      -- Setup notification filtering
      local original_notify = vim.notify
      local banned_messages = {
        "Accessing client.resolved_capabilities is deprecated",
        "Client %d+ quit with exit code %d+ and signal %d+",
        "[LSP][%s+] timeout",
        'Error detected while processing LspAttach Autocommands for "*"',
        "rust.analyzer: .32802: server cancelled the request",
      }

      vim.notify = function(msg, ...)
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

      return opts
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
  -- none-ls configuration moved to lua/plugins/none-ls.lua to avoid duplication
  {
    "akinsho/toggleterm.nvim",
    opts = {
      direction = "float",
      -- open_mapping = [[<c-'>]],
    },
  },
  -- dressing.nvim is replaced by snacks.nvim in v5
  -- Input and select UI is now handled by snacks.input and snacks.picker
  --[[
  {
    "AstroNvim/astrocommunity",
    { import = "astrocommunity.motion.harpoon" },
  },
  ]]
}
