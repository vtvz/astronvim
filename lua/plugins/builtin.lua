local headers = {
  table.concat({
    "░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░",
    "░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░   ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░",
    " ░▒▓█▓▒▒▓█▓▒░   ░▒▓█▓▒░    ░▒▓█▓▒▒▓█▓▒░     ░▒▓██▓▒░ ",
    " ░▒▓█▓▒▒▓█▓▒░   ░▒▓█▓▒░    ░▒▓█▓▒▒▓█▓▒░   ░▒▓██▓▒░   ",
    "  ░▒▓█▓▓█▓▒░    ░▒▓█▓▒░     ░▒▓█▓▓█▓▒░  ░▒▓██▓▒░     ",
    "  ░▒▓█▓▓█▓▒░    ░▒▓█▓▒░     ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░       ",
    "   ░▒▓██▓▒░     ░▒▓█▓▒░      ░▒▓██▓▒░  ░▒▓████████▓▒░",
  }, "\n"),

  table.concat({
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
  }, "\n"),
}

return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = headers[2],
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      { "saghen/blink-cmp-luasnip", optional = true },
    },
    opts = function(_, opts)
      -- Remove Tab from completion to avoid collision with snippet navigation
      -- Only use Ctrl+n/Ctrl+p for completion navigation
      opts.keymap = opts.keymap or {}
      opts.keymap.preset = "default"
      opts.keymap["<Tab>"] = {}
      opts.keymap["<S-Tab>"] = {}

      return opts
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function(...)
      require("astronvim.plugins.configs.luasnip")(...)

      local luasnip = require("luasnip")
      luasnip.filetype_extend("javascript", { "javascriptreact" })

      -- require("luasnip.loaders.from_vscode").lazy_load({
      --   paths = { vim.fn.stdpath("config") .. "/snippets" },
      -- })

      require("luasnip.loaders.from_snipmate").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snipmate" },
      })

      -- Setup Tab/Shift-Tab for snippet navigation
      vim.keymap.set({ "i", "s" }, "<Tab>", function()
        if luasnip.jumpable(1) then
          luasnip.jump(1)
        else
          return "<Tab>"
        end
      end, { silent = true, expr = true })

      vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          return "<S-Tab>"
        end
      end, { silent = true, expr = true })
    end,
  },
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
  {
    "akinsho/toggleterm.nvim",
    opts = {
      direction = "float",
      -- open_mapping = [[<c-'>]],
    },
  },
}
