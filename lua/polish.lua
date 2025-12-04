vim.filetype.add({
  extension = {
    --   tf = "terraform",
    -- tfvars = "terraform",
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

local messages_bufnr

vim.api.nvim_create_user_command("Messages", function()
  local messages_output = vim.api.nvim_exec2(":messages", { output = true }).output

  if messages_bufnr ~= nil and vim.fn.buflisted(messages_bufnr) == 0 then
    messages_bufnr = nil
  end

  if not messages_bufnr then
    messages_bufnr = vim.api.nvim_create_buf(true, true)
    vim.bo[messages_bufnr].buftype = "nofile"
    vim.api.nvim_buf_set_name(messages_bufnr, ":messages")
  end

  vim.bo[messages_bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(messages_bufnr, 0, -1, true, vim.split(messages_output, "\n"))
  vim.bo[messages_bufnr].modifiable = false

  vim.api.nvim_set_current_buf(messages_bufnr)
  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 0 })
end, { desc = "Show messages in a buffer" })

local au = vim.api.nvim_create_augroup("vtvz", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Remove trailing spaces",
  group = au,
  callback = function()
    local Path = require("plenary.path")
    local file = Path:new(vim.fn.bufname())

    if file:exists() then
      -- Remove trailing spaces
      vim.api.nvim_command(":%s/\\s\\+$//e")
      -- Remove ending lines
      pcall(vim.api.nvim_command, ":%s#\\($\\n\\s*\\)\\+\\%$##")
      pcall(vim.api.nvim_command, ":%s#\\%^\\($\\n\\s*\\)\\+##")
    end
  end,
})

vim.api.nvim_create_autocmd("ExitPre", {
  desc = "Prevent closing if there are opened terminals",
  pattern = "*",
  callback = function()
    local terminals = require("toggleterm.terminal").get_all()
    if #terminals > 0 then
      vim.cmd("tabe " .. vim.fn.expand("%:p"))
      vim.cmd("tabclose #")
      require("toggleterm").toggle(terminals[1].id)

      require("toggleterm.terminal").get(terminals[1].id):set_mode("i")
      vim.notify("There are opened terminal sessions: " .. #terminals, vim.log.levels.ERROR)
    end
  end,
})

--[[ vim.api.nvim_create_autocmd("BufAdd", {
  desc = "Add Russian Layout",
  group = au,
  callback = function()
    local buf = tonumber(vim.fn.expand("<abuf>"))

    vim.bo[buf].keymap = "russian-jcukenwin"
    vim.bo[buf].iminsert = 0
    vim.bo[buf].imsearch = -1
    vim.bo[buf].spelloptions = "camel"
  end,
})
]]

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

-- Force statuscolumn to refresh when switching buffers
-- The reassignment triggers a redraw, ensuring the statuscolumn updates properly
vim.api.nvim_create_autocmd({ "BufLeave", "BufEnter" }, {
  desc = "Refresh statuscolumn on buffer switch",
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
    local ft = vim.bo[buffer].filetype

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
