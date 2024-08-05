vim.filetype.add({
  extension = {
    --   tf = "terraform",
    tfvars = "terraform",
  },
  pattern = {
    [".*/Dockerfile.*"] = "dockerfile",
    ["haproxy.cfg.j2"] = "haproxy.jinga",
    ["haproxy.cfg"] = "haproxy",
  },
})

vim.opt.matchpairs:append({ "<:>" })

vim.api.nvim_create_user_command("JenkinsValidate", function()
  require("jenkinsfile_linter").validate()
end, { desc = "Validate Jenkinsfile" })

vim.api.nvim_cmd({ cmd = "highlight", args = { "NeoTreeGitIgnored", "guifg=#67859e" } }, {})

vim.api.nvim_create_user_command("Messages", function()
  local messages_output = vim.api.nvim_exec(":messages", true)

  if MESSAGES_BUFNR ~= nil and vim.fn.buflisted(MESSAGES_BUFNR) == 0 then
    MESSAGES_BUFNR = nil
  end

  if not MESSAGES_BUFNR then
    MESSAGES_BUFNR = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_option(MESSAGES_BUFNR, "buftype", "nofile")
    vim.api.nvim_buf_set_name(MESSAGES_BUFNR, ":messages")
  end

  vim.api.nvim_buf_set_option(MESSAGES_BUFNR, "modifiable", true)
  vim.api.nvim_buf_set_lines(MESSAGES_BUFNR, 0, -1, true, vim.split(messages_output, "\n"))
  vim.api.nvim_buf_set_option(MESSAGES_BUFNR, "modifiable", false)

  vim.api.nvim_set_current_buf(MESSAGES_BUFNR)
  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 0 })
end, { desc = "Show messages in a buffer" })

local au = vim.api.nvim_create_augroup("vtvz_test", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Trailing spaces",
  group = au,
  callback = function()
    -- Remove trailing spaces
    vim.api.nvim_command(":%s/\\s\\+$//e")
    -- Remove ending lines
    pcall(vim.api.nvim_command, ":%s#\\($\\n\\s*\\)\\+\\%$##")
    pcall(vim.api.nvim_command, ":%s#\\%^\\($\\n\\s*\\)\\+##")
  end,
})

vim.api.nvim_create_autocmd("ExitPre", {
  pattern = "*",
  callback = function()
    local terminals = require("toggleterm.terminal").get_all()
    if #terminals > 0 then
      vim.cmd("tabe " .. vim.fn.expand("%:p"))
      vim.cmd("tabclose #")
      require("toggleterm").toggle(terminals[1].id)

      require("toggleterm.terminal").get(terminals[1].id):set_mode("i")
      vim.api.nvim_err_writeln("There are opened terminal sessions: " .. #terminals)
    end
  end,
})

vim.api.nvim_create_autocmd("BufAdd", {
  desc = "Add Russian Layout",
  group = au,
  callback = function()
    local buf = tonumber(vim.fn.expand("<abuf>"))

    vim.api.nvim_set_option_value("keymap", "russian-jcukenwin", { buf = buf })
    vim.api.nvim_set_option_value("iminsert", 0, { buf = buf })
    vim.api.nvim_set_option_value("imsearch", -1, { buf = buf })

    vim.api.nvim_set_option_value("spelloptions", "camel", { buf = buf })
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  desc = "Add title",
  group = au,
  callback = function()
    vim.opt.titlestring = ""
      .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      .. " ("
      .. vim.fn.fnamemodify(vim.fn.getcwd(), ":h:t")
      .. ")"
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "BufEnter" }, {
  group = au,
  callback = function()
    vim.o.statuscolumn = vim.o.statuscolumn
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  desc = "Enter to newline functionality",
  group = au,
  callback = function()
    local buffer = tonumber(vim.fn.expand("<abuf>"))
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer })

    if ft == "qf" then
      vim.keymap.set(
        "n",
        "<C-CR>",
        "<CR><CMD>cclose<CR>",
        { desc = "Close quicklist after selecting item", buffer = buffer }
      )

      vim.keymap.set("n", "q", "<CMD>cclose<CR>", { desc = "Close quicklist on q", buffer = buffer })
    else
      local is_keymap_set = function(mode, key)
        local map = vim.api.nvim_buf_get_keymap(buffer, mode)
        for _, mapping in ipairs(map) do
          if mapping.lhs == key then
            return true
          end
        end
        return false
      end

      if not is_keymap_set("n", "<CR>") then
        vim.keymap.set("n", "<CR>", "o<Space><BS><Esc>", { desc = "New line without entering insert", buffer = buffer })
      end
    end
  end,
})
