local function current_picker_text()
  local prompts = require("telescope.state").get_existing_prompt_bufnrs()
  if #prompts == 1 then
    local current_picker = require("telescope.actions.state").get_current_picker(prompts[1])
    return current_picker:_get_prompt()
  end
end

-- https://github.com/nvim-telescope/telescope.nvim/pull/2333/files#diff-28bcf3ba7abec8e505297db6ed632962cbbec357328d4e0f6c6eca4fac1c0c48R170
local function visual_selected_text()
  local saved_reg = vim.fn.getreg("v")
  vim.cmd([[noautocmd sil norm "vy]])
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", saved_reg)

  return text
end

local function switch_terminal(direction)
  return function()
    -- Only work in toggleterm buffers
    if vim.bo.filetype ~= "toggleterm" then
      return
    end

    local focused_id = require("toggleterm.terminal").get_focused_id()
    local terminals = require("toggleterm.terminal").get_all()

    if #terminals > 0 and focused_id then
      local focused_index = nil
      for index, terminal in ipairs(terminals) do
        if focused_id == terminal.id then
          focused_index = index
          break
        end
      end

      local to_focus
      if direction == "prev" then
        to_focus = terminals[#terminals].id
        if terminals[focused_index - 1] then
          to_focus = terminals[focused_index - 1].id
        end
      else -- next
        to_focus = terminals[1].id
        if terminals[focused_index + 1] then
          to_focus = terminals[focused_index + 1].id
        end
      end

      if to_focus ~= focused_id then
        require("toggleterm").toggle(to_focus)
        vim.schedule(function()
          require("toggleterm.terminal").get(to_focus)
        end)
      end
    end
  end
end

return {
  t = {
    ["<C-\\><C-{>"] = {
      switch_terminal("prev"),
      desc = "Switch to previous terminal",
    },
    ["<C-\\><C-}>"] = {
      switch_terminal("next"),
      desc = "Switch to next terminal",
    },
    ["<C-|><C-{>"] = {
      switch_terminal("prev"),
      desc = "Switch to previous terminal",
    },
    ["<C-|><C-}>"] = {
      switch_terminal("next"),
      desc = "Switch to next terminal",
    },
  },
  v = {
    [">"] = { ">gv" },
    ["<"] = { "<gv" },
    ["p"] = { "P", desc = "Paste without trashing main registry" },
    ["<Leader>fw"] = {
      function()
        require("telescope.builtin").live_grep({ default_text = visual_selected_text() })
      end,
      desc = "Find for word under cursor",
    },
    ["<Leader>ff"] = {
      function()
        require("telescope.builtin").find_files({ default_text = visual_selected_text() })
      end,
      desc = "Find for word under cursor",
    },
    -- ["<Leader>pp"] = { "p", desc = "Paste" },
    ["A"] = {
      function()
        local mode = vim.api.nvim_get_mode()
        if mode["mode"] == "\22" then
          vim.api.nvim_feedkeys("A", "n", false)
          return
        end
        if mode["mode"] == "v" then
          vim.api.nvim_feedkeys("V", "normal", false)
        end
        vim.schedule(function()
          vim.api.nvim_feedkeys("ggoG", "normal", false)
        end)
      end,
      desc = "Select All",
      noremap = true,
    },
    ["<Leader>vgx"] = {
      require("git_srcr").open,
    },
    ["<Leader>vyx"] = {
      require("git_srcr").yank,
    },
    ["<Leader>vys"] = {
      function()
        local start, finish = require("user.utils").get_visual_range()
        vim.cmd(string.format(":%d,%dSilicon", start, finish))
      end,
      noremap = true,
      silent = true,
      expr = false,
    },
    ["<M-j>"] = {
      [[:m '>+1<CR>gvgv]],
      noremap = true,
    },
    ["<M-k>"] = {
      [[:m '<-2<CR>gvgv]],
      noremap = true,
    },
  },
  n = {
    ["<C-\\><C-{>"] = {
      switch_terminal("prev"),
      desc = "Switch to previous terminal",
    },
    ["<C-\\><C-}>"] = {
      switch_terminal("next"),
      desc = "Switch to next terminal",
    },
    ["<C-|><C-{>"] = {
      switch_terminal("prev"),
      desc = "Switch to previous terminal",
    },
    ["<C-|><C-}>"] = {
      switch_terminal("next"),
      desc = "Switch to next terminal",
    },
    ["<Leader>-"] = { "<CMD>Oil<CR>", desc = "Open parent directory" },
    ["<Leader>fd"] = {
      function()
        local action_state = require("telescope.actions.state")
        local actions = require("telescope.actions")

        require("telescope.builtin").find_files({
          find_command = { "find", ".", "-type", "d" },

          attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()

              require("telescope.builtin").live_grep({
                search_dirs = { selection[1] },
              })
            end)

            return true
          end,
        })
      end,
    },
    ["<M-j>"] = {
      [[:m .+1<CR>==]],
      noremap = true,
    },
    ["<M-k>"] = {
      [[:m .-2<CR>==]],
      noremap = true,
    },
    ["k"] = {
      [[(v:count > 1 ? "m'" . v:count : '') . 'k']],
      noremap = true,
    },
    ["j"] = {
      [[(v:count > 1 ? "m'" . v:count : '') . 'j']],
      noremap = true,
    },
    ["q:"] = {
      "<cmd>quit<cr>",
      desc = "Alternative to :q",
    },
    ["<Leader>ss"] = {
      function()
        require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
      end,
      desc = "Load current directory session",
    },
    ["<Leader>f<CR>"] = {
      function()
        require("telescope.builtin").pickers()
      end,
      desc = "Open recent pickers",
    },
    ["<Leader>ff"] = {
      function()
        require("telescope.builtin").find_files({ default_text = current_picker_text() })
      end,
    },
    ["<Leader>fF"] = {
      function()
        require("telescope.builtin").find_files({
          default_text = current_picker_text(),
          hidden = true,
          no_ignore = true,
        })
      end,
      desc = "Find all files",
    },
    ["<Leader>fw"] = {
      function()
        require("telescope.builtin").live_grep({ default_text = current_picker_text() })
      end,
      desc = "Find words",
    },
    ["<Leader>fW"] = {
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
    ["<C-a>"] = {
      function()
        local words = {
          ["true"] = "false",
          ["false"] = "true",
          ["qa"] = "prod",
          ["prod"] = "pre-prod-v2",
          ["get"] = "set",
          ["set"] = "get",
          ["=="] = "!=",
          ["!="] = "==",
          ["elseif"] = "if",
          ["if"] = "else",
          ["pre-prod-v2"] = "qa",
          ["ADD"] = "COPY",
          ["const"] = "let",
          ["let"] = "const",
          ["async"] = "await",
          ["await"] = "async",
        }

        for _, mod in ipairs({ "w", "W", '"', "'" }) do
          -- mark current location and yank in "something"
          -- then restore prev mark and reg
          local prev_reg = vim.fn.getreg("v")
          local prev_row, prev_col = table.unpack(vim.api.nvim_buf_get_mark(0, "v"))
          vim.cmd("normal! mv")
          vim.cmd('normal! "vyi' .. mod)
          vim.cmd("normal! `v")
          if prev_row == 0 then
            vim.api.nvim_buf_del_mark(0, "v")
          else
            vim.api.nvim_buf_set_mark(0, "v", prev_row, prev_col, {})
          end
          local cword = vim.fn.getreg("v")
          vim.fn.setreg("v", prev_reg)

          local word = words[cword]

          if word then
            vim.cmd('normal! "_ci' .. mod .. word)
            return
          end
        end

        local complex = {
          ["pre-prod-v2"] = "qa",
        }

        local cur_line = vim.api.nvim_get_current_line()
        for from, to in pairs(complex) do
          local replaced = vim.fn.substitute(cur_line, from, to, "g")

          if cur_line ~= replaced then
            vim.api.nvim_set_current_line(replaced)
            vim.notify("Complex")
            return
          end
        end

        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-a>", true, false, true), "n", false)
      end,
      desc = "Switch true and false or all ctrl+a stuff",
      noremap = true,
    },
    ["]c"] = { "<cmd>:cnext<cr>", desc = "Next in quickfix" },
    ["[c"] = { "<cmd>:cprevious<cr>", desc = "Previous in quickfix" },
    -- [ [[<c-'>]] ] = false,
    ["<Leader>vgx"] = {
      require("git_srcr").open,
    },
    ["<Leader>vyx"] = {
      require("git_srcr").yank,
    },
    ["<Leader>vys"] = {
      "<Cmd>Silicon<CR>",
    },
    ["<Leader>vyf"] = {
      function()
        require("user.utils").copy_filename(vim.fn.expand("%:p"))
      end,
    },
    ["yA"] = {
      function()
        local win = vim.api.nvim_get_current_win()
        local position = vim.api.nvim_win_get_cursor(win)
        vim.api.nvim_feedkeys("ggVGy", "normal", false)
        vim.schedule(function()
          vim.api.nvim_win_set_cursor(win, position)
        end)
      end,
      desc = "Yank whole page",
    },
    -- ["<Leader>gg"] = {
    --   function()
    --     astronvim.toggle_term_cmd({ cmd = "lazygit", hidden = true, count = 150 })
    --   end,
    --   desc = "ToggleTerm lazygit",
    -- },
    ["<Leader>w"] = { "<cmd>wa<cr>", desc = "Save" },
    -- ["<Leader>v"] = {
    --   require("justjump").popup,
    --   desc = "N'th buffer",
    -- },
    ["<Leader>uf"] = {
      function()
        require("user.utils").toggle_buffer_autoformat()
      end,
      desc = "Toggle autoformatting (buffer)",
    },
    ["<Leader>uF"] = {
      function()
        require("user.utils").toggle_autoformat()
      end,
      desc = "Toggle autoformatting (global)",
    },
    ["gr"] = {
      function()
        require("telescope.builtin").lsp_references()
      end,
      desc = "Search references",
    },
    ["<Leader>fl"] = {
      function()
        require("telescope.builtin").pickers()
      end,
      desc = "Search references",
    },
    ["<Leader>C"] = {
      function()
        require("user.utils").buffer_close_all()
      end,
      desc = "Wipe all buffers except current",
    },
    ["<Leader>vgK"] = {
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
        require("user.utils").buffer_navigate_next()
      end,
      desc = "Next buffer",
    },
    ["H"] = {
      function()
        require("user.utils").buffer_navigate_prev()
      end,
      desc = "Previous buffer",
    },
  },
}
