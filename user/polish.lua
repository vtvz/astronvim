local function set_langmap()
  local function escape(str)
    -- Эти символы должны быть экранированы, если встречаются в langmap
    local escape_chars = [[;,."|\]]
    return vim.fn.escape(str, escape_chars)
  end

  -- Наборы символов, введенных с зажатым шифтом
  local en_shift = [[~QWFPBJLUY:{}ARSTGMNEIO"ZXCDVKH<>]]
  local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]
  -- Наборы символов, введенных как есть
  -- Здесь я не добавляю ',.' и 'бю', чтобы впоследствии не было рекурсивного вызова комманды
  local en = [[`qwfpbjluy;[]arstgmneio'zxcdvkh]]
  local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]

  vim.opt.langmap = vim.fn.join({
    --  ; - разделитель, который не нужно экранировать
    --  |
    escape(ru_shift)
      .. ";"
      .. escape(en_shift),
    escape(ru) .. ";" .. escape(en),
  }, ",")
end

return function()
  set_langmap()

  vim.filetype.add({
    extension = {
      tf = "terraform",
      tfvars = "hcl",
    },
    pattern = {
      [".*/Dockerfile.*"] = "dockerfile",
      ["haproxy.cfg.j2"] = "haproxy.jinga",
      ["haproxy.cfg"] = "haproxy",
    },
  })

  vim.opt.matchpairs:append({ "<:>" })
  vim.opt.iskeyword:remove("_")
  vim.opt.spell = true

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

  vim.api.nvim_create_user_command("WipeAll", function()
    local Path = require("plenary.path")

    local bufs = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(bufs) do
      if bufnr ~= vim.api.nvim_get_current_buf() then
        local filename = vim.api.nvim_buf_get_name(bufnr)
        if filename ~= "" then
          local path = Path:new(filename)
          if path:exists() then
            vim.api.nvim_buf_delete(bufnr, {})
          end
        end
      end
    end
  end, { desc = "Close all buffers" })

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

  vim.api.nvim_create_autocmd("BufAdd", {
    desc = "Add Russian Layout",
    group = au,
    callback = function()
      local buf = tonumber(vim.fn.expand("<abuf>"))

      vim.api.nvim_buf_set_option(buf, "keymap", "russian-jcukenwin")
      vim.api.nvim_buf_set_option(buf, "iminsert", 0)
      vim.api.nvim_buf_set_option(buf, "imsearch", -1)

      vim.api.nvim_buf_set_option(buf, "spelloptions", "camel")
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
    desc = "Enter to newline functionality",
    group = au,
    callback = function()
      local buffer = tonumber(vim.fn.expand("<abuf>"))
      local ft = vim.api.nvim_buf_get_option(buffer, "filetype")

      if ft == "qf" then
        vim.keymap.set(
          "n",
          "<C-CR>",
          "<CR><CMD>cclose<CR>",
          { desc = "Close quicklist after selecting item", buffer = buffer }
        )

        vim.keymap.set("n", "q", "<CMD>cclose<CR>", { desc = "Close quicklist on q", buffer = buffer })
      else
        vim.keymap.set("n", "<CR>", "o<Space><BS><Esc>", { desc = "New line without entering insert", buffer = buffer })
      end
    end,
  })
end
