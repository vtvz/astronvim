local function current_picker_text()
  local prompts = require("telescope.state").get_existing_prompt_bufnrs()
  if #prompts == 1 then
    local current_picker = require("telescope.actions.state").get_current_picker(prompts[1])
    return current_picker:_get_prompt()
  end
end
return {
  t = {
    ["<Esc><Esc>"] = { "<C-\\><C-n>" },
  },
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
    ["gX"] = {
      require("git_srcr").open,
    },
    ["X"] = {
      require("git_srcr").yank,
    },
    ["<M-j>"] = {
      [[:m '>+1<CR>gv=gv]],
      noremap = true,
    },
    ["<M-k>"] = {
      [[:m '<-2<CR>gv=gv]],
      noremap = true,
    },
  },
  n = {
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
    ["<leader>ss"] = {
      "<cmd>SessionManager! load_current_dir_session<cr>",
      desc = "Load current directory session",
    },
    ["<leader>f<CR>"] = {
      function()
        require("telescope.builtin").pickers()
      end,
      desc = "Open recent pickers",
    },
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
    ["<C-a>"] = {
      function()
        local word = vim.fn.expand("<cword>")
        if word == "true" then
          vim.cmd('normal! "_ciw' .. "false")
        elseif word == "false" then
          vim.cmd('normal! "_ciw' .. "true")
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-a>", true, false, true), "n", false)
        end
      end,
      desc = "Switch true and false or all ctrl+a stuff",
      noremap = true,
    },
    ["]c"] = { "<cmd>:cnext<cr>", desc = "Next in quickfix" },
    ["[c"] = { "<cmd>:cprevious<cr>", desc = "Previous in quickfix" },
    [ [[<c-'>]] ] = false,
    ["gX"] = {
      require("git_srcr").open,
    },
    ["yX"] = {
      require("git_srcr").yank,
    },
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
    ["<leader>v"] = {
      require("justjump").popup,
      desc = "N'th buffer",
    },
    ["<leader>uf"] = {
      function()
        require("astronvim.utils.ui").toggle_buffer_autoformat()
      end,
      desc = "Toggle autoformatting (buffer)",
    },
    ["<leader>uF"] = {
      function()
        require("astronvim.utils.ui").toggle_autoformat()
      end,
      desc = "Toggle autoformatting (global)",
    },
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
    ["<leader>C"] = {
      function()
        require("astronvim.utils.buffer").close_all(true, false)
      end,
      desc = "Wipe all buffers except current",
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
  },
}
