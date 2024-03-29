require("user.globals")

return {
  mappings = require("user.mappings"),
  lsp = {
    mappings = {
      n = {
        -- replace with dynamic because plain sucks
        ["<leader>lg"] = {
          function()
            require("telescope.builtin").lsp_dynamic_workspace_symbols()
          end,
          desc = "Search workspace symbols",
        },
      },
    },
    setup_handlers = {
      -- add custom handler
      rust_analyzer = function(_, opts)
        local rt = require("rust-tools")

        local rt_config = {
          server = opts, -- get the server settings and built in capabilities/on_attach
        }

        if not rt_config.server.settings then
          rt_config.server.settings = {}
        end

        rt_config.server.settings["rust-analyzer"] = {
          checkOnSave = {
            command = "check",
          },
        }

        rt.setup(rt_config)

        rt.inlay_hints.enable()
      end,
    },
    formatting = {
      filter = function(client)
        -- disable formatting for sumneko_lua
        if client.name == "lua_ls" then
          return false
        end
        return true
      end,
      format_on_save = {
        ignore_filetypes = {
          "groovy",
        },
      },
    },
    config = {
      lua_ls = function(config)
        local utils = require("astronvim.utils")

        -- ["/home/vtvz/.local/share/Steam/steamapps/common/Don't Starve Together/data/databundles/"] = true,

        for _, lib in pairs(vim.api.nvim_get_runtime_file("", true)) do
          config.settings.Lua.workspace.library = utils.extend_tbl(config.settings.Lua.workspace.library, {
            [lib] = true,
          })
        end
        return config
      end,
    },
    on_attach = function(client, bufnr)
      if client.name == "rust_analyzer" then
        local rt = require("rust-tools")

        vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
        vim.keymap.set("n", "J", rt.join_lines.join_lines, { buffer = bufnr })
      end

      require("lsp_signature").on_attach({
        floating_window = false,
      }, bufnr)

      -- -- Hover actions
      -- vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- -- Code action groups
      -- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
  options = function(options)
    options.opt.cmdheight = 1
    options.opt.title = true
    options.opt.exrc = true

    return options
  end,
}
