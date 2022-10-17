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
  if type(v) ~= "table" then
    return P(v)
  end

  local table = {}
  for key, value in pairs(v) do
    table[key] = type(value) .. " => " .. tostring(value)
  end

  return P(table)
end

RELOAD = function(...)
  local modules = vim.tbl_flatten({ ... })

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
    skip_setup = { "rust_analyzer" },
    on_attach = function(client, bufnr)
      if client.name == "rust_analyzer" then
        local rt = require("rust-tools")

        vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
      end
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

  -- ["mason-null-ls"] = {
  --   ["setup_handlers"] = {
  --     stylua = function() require("null-ls").register(require("null-ls").builtins.formatting.stylua) end,
  --   },
  -- },

  plugins = require("user.plugins"),
}

return config
