require("user.globals")

local function current_picker_text()
  local prompts = require("telescope.state").get_existing_prompt_bufnrs()
  if #prompts == 1 then
    local current_picker = require("telescope.actions.state").get_current_picker(prompts[1])
    return current_picker:_get_prompt()
  end
end

return {
  mappings = {
    v = {
      [">"] = { ">gv" },
      ["<"] = { "<gv" },
      ["p"] = { "P", desc = "Paste without trashing main registry" },
      ["<leader>fw"] = {
        function()
          -- https://github.com/nvim-telescope/telescope.nvim/pull/2333/files#diff-28bcf3ba7abec8e505297db6ed632962cbbec357328d4e0f6c6eca4fac1c0c48R170

          local saved_reg = vim.fn.getreg("v")
          vim.cmd([[noautocmd sil norm "vy]])
          local text = vim.fn.getreg("v")
          vim.fn.setreg("v", saved_reg)

          require("telescope.builtin").live_grep({ default_text = text })
        end,
        desc = "Find for word under cursor",
      },
      ["<leader>pp"] = { "p", desc = "Paste" },
      ["A"] = {
        function()
          local mode = vim.api.nvim_get_mode()
          if mode["mode"] == "v" then
            vim.api.nvim_feedkeys("V", "normal", false)
          end
          vim.schedule(function()
            vim.api.nvim_feedkeys("ggoG", "normal", false)
          end)
        end,
        desc = "Select All",
      },
    },
    n = {
      ["<leader>ff"] = {
        function()
          require("telescope.builtin").find_files({ default_text = current_picker_text() })
        end,
      },
      ["<leader>fF"] = {
        function()
          require("telescope.builtin").find_files({
            default_text = current_picker_text(),
            hidden = true,
            no_ignore = true,
          })
        end,
        desc = "Find all files",
      },
      ["<leader>fw"] = {
        function()
          require("telescope.builtin").live_grep({ default_text = current_picker_text() })
        end,
        desc = "Find words",
      },
      ["<leader>fW"] = {
        function()
          require("telescope.builtin").live_grep({
            default_text = current_picker_text(),
            additional_args = function(args)
              return vim.list_extend(args, { "--hidden", "--no-ignore" })
            end,
          })
        end,
      },
      ["x"] = { '"_x', desc = "Delete without pollution registry" },
      ["]c"] = { "<cmd>:cnext<cr>", desc = "Next in quickfix" },
      ["[c"] = { "<cmd>:cprevious<cr>", desc = "Previous in quickfix" },
      [ [[<c-'>]] ] = false,
      ["yA"] = {
        function()
          local win = vim.api.nvim_get_current_win()
          local position = vim.api.nvim_win_get_cursor(win)
          P(position)
          vim.api.nvim_feedkeys("ggVGy", "normal", false)
          vim.schedule(function()
            vim.api.nvim_win_set_cursor(win, position)
          end)
        end,
        desc = "Yank whole page",
      },
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
      ["<leader>Yp"] = {
        function()
          local path = vim.fn.expand("%")
          path = vim.fn.fnamemodify(path, ":.")

          vim.fn.setreg("+", path)
          print("Copied path to current file: " .. path)
        end,
        desc = "Copy current file relative path",
      },
      ["<leader>YP"] = {
        function()
          local path = vim.fn.expand("%")

          vim.fn.setreg("+", path)
          print("Copied path to current file: " .. path)
        end,
        desc = "Copy current file absolute path",
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
