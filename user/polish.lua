return function()
  vim.opt.matchpairs:append({ "<:>" })

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
    end,
  })

  local function open_neotree(cur_win)
    cur_win = cur_win or vim.api.nvim_get_current_win()

    local _, err = pcall(vim.api.nvim_command, "Neotree action=show")
    if err then
      vim.defer_fn(function()
        open_neotree(cur_win)
      end, 100)

      return
    else
      -- 961x1280
      vim.api.nvim_set_current_win(cur_win)
    end
  end

  vim.api.nvim_create_autocmd("VimEnter", {
    desc = "On launch",
    group = au,
    callback = function()
      vim.defer_fn(function()
        open_neotree()
      end, 100)
    end,
  })

  vim.api.nvim_create_autocmd("UIEnter", {
    desc = "Suppress some notifications",
    group = au,
    callback = function()
      local banned_messages = {
        "Accessing client.resolved_capabilities is deprecated",
      }

      local original_notify = vim.notify

      local filtered_notify = function(msg, ...)
        if type(msg) == "string" then
          for _, banned in ipairs(banned_messages) do
            if string.find(msg, banned, 1, true) then
              print(msg)
              return
            end
          end
        end

        original_notify(msg, ...)
      end

      vim.notify = filtered_notify
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    desc = "On launch",
    pattern = "SessionLoadPost",
    group = au,
    callback = function()
      vim.defer_fn(function()
        open_neotree()
      end, 100)
    end,
  })

  vim.api.nvim_create_autocmd("BufAdd", {
    desc = "Add Russian Layout",
    group = au,
    callback = function()
      local buf = tonumber(vim.fn.expand("<abuf>"))

      vim.api.nvim_buf_set_option(buf, "keymap", "russian-jcukenwin")
      vim.api.nvim_buf_set_option(buf, "iminsert", 0)
      vim.api.nvim_buf_set_option(buf, "imsearch", -1)
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

  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    desc = "Set dockerfile filetype",
    group = au,
    pattern = "Dockerfile*",
    callback = function()
      vim.bo.filetype = "dockerfile"
    end,
  })

  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    desc = "Enter to newline functionality",
    group = au,
    callback = function()
      local buffer = tonumber(vim.fn.expand("<abuf>"))
      local ft = vim.api.nvim_buf_get_option(buffer, "filetype")

      if ft == "qf" then
        vim.keymap.set(
          "n",
          "<CR>",
          "<CR><CMD>cclose<CR>",
          { desc = "Close quicklist after selecting item", buffer = buffer }
        )

        vim.keymap.set("n", "q", "<CMD>cclose<CR>", { desc = "Close quicklist on q", buffer = buffer })
      else
        vim.keymap.set("n", "<CR>", "o<Space><Esc>", { desc = "New line without entering insert", buffer = buffer })
      end
    end,
  })
end
