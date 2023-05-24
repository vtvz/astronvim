require("user.globals")

return {
  mappings = {
    v = {
      [">"] = { ">gv" },
      ["<"] = { "<gv" },
      ["p"] = { "p :let @+=@0<cr>", desc = "Paste without trashing main registry" },
      ["<leader>fc"] = {
        function()
          require("telescope.builtin").grep_string()
        end,
        desc = "Find for word under cursor",
      },
      ["<leader>pp"] = { "p", desc = "Paste" },
      ["A"] = { "ggoG", desc = "Select All" },
    },
    n = {
      [ [[<c-'>]] ] = false,
      ["yA"] = { "ggVGy<C-O>", desc = "Yank whole page" },
      -- ["<leader>gg"] = {
      --   function()
      --     astronvim.toggle_term_cmd({ cmd = "lazygit", hidden = true, count = 150 })
      --   end,
      --   desc = "ToggleTerm lazygit",
      -- },
      ["<leader>w"] = { "<cmd>wa<cr>", desc = "Save" },
      ["gr"] = {
        function()
          require("telescope.builtin").lsp_references()
        end,
        desc = "Search references",
      },
      ["<leader>fl"] = {
        function()
          require("telescope.builtin").pickers()
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
      ["<leader>C"] = { "<CMD>WipeAll<CR>", desc = "Wipe all buffers except current" },
      -- Copy current file relative path
      ["<leader><C-o>"] = {
        function()
          local path = vim.fn.expand("%")
          path = vim.fn.fnamemodify(path, ":.")

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
      ["L"] = {
        function()
          require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
        end,
        desc = "Next buffer",
      },
      ["H"] = {
        function()
          require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
        end,
        desc = "Previous buffer",
      },
      -- A personal trick for my workspace setup
      ["<leader>t<C-'>"] = {
        function()
          local Job = require("plenary.job")
          local Terminal = require("toggleterm.terminal").Terminal

          Job:new({
            command = "just",
            args = { "ws", "profiles" },
            on_exit = vim.schedule_wrap(function(j, _)
              local result = vim.fn.join(j:result())
              local profiles = vim.fn.json_decode(result)

              for i, profile in ipairs(profiles) do
                local zsh = Terminal:new({ cmd = "just ws profile '" .. profile .. "' just ws zsh", count = i })
                zsh:spawn()
              end
            end),
          }):sync(5000)
        end,
        desc = "Spawn terminals with profiles",
      },
    },
  },
  lsp = {
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

        config.settings.Lua.workspace.library = utils.extend_tbl(config.settings.Lua.workspace.library, {
          ["/home/vtvz/.local/share/Steam/steamapps/common/Don't Starve Together/data/databundles/"] = true,
        })
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
