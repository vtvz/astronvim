local M = {
  formatting = {},
  timer = nil,
  filetypes = { "groovy", "java", "Jenkinsfile" },
}

function M._setup_timer()
  if M.timer then
    return
  end

  local timer = vim.loop.new_timer()

  timer:start(
    0,
    500,
    vim.schedule_wrap(function()
      if #M.formatting == 0 then
        return
      end

      local items = vim.lsp.util.get_progress_messages()
      if #items > 0 then
        return
      end

      for bufnr, _ in ipairs(M.formatting) do
        vim.api.nvim_buf_set_option(bufnr, "modifiable", true)

        vim.notify("File can be modified", vim.log.levels.INFO, { timeout = 500, title = "Groovy Formatter" })

        M.formatting[bufnr] = nil
      end
    end)
  )
end

function M.setup()
  local null_ls = require("null-ls")

  return {
    method = null_ls.methods.FORMATTING,
    filetypes = M.filetypes,
    name = "groovy-format.sh",
    generator = require("null-ls.helpers").generator_factory({
      args = function(params)
        vim.api.nvim_buf_set_option(params.bufnr, "modifiable", false)
        return { "$FILENAME" }
      end,
      command = "groovy-format.sh",
      on_output = function(params, done)
        vim.api.nvim_buf_set_option(params.bufnr, "modifiable", true)
        vim.notify("File can be modified", vim.log.levels.INFO, { timeout = 500, title = "Groovy Formatter" })
        vim.defer_fn(function()
          if vim.bo[params.bufnr].modified then
            -- local current_bufnr = vim.api.nvim_get_current_buf()
            -- if params.bufnr ~= current_bufnr then
            vim.api.nvim_buf_call(params.bufnr, function()
              vim.api.nvim_cmd({ cmd = "write", mods = { noautocmd = true } }, {})
            end)
            -- end
          end
        end, 100)
        M.formatting[params.bufnr] = nil

        local output = params.output
        if not output then
          return done()
        end

        return done({ { text = output } })
      end,
      to_stdin = false,
      to_temp_file = true,
      ignore_stderr = true,
      from_temp_file = true,
      timeout = 60 * 1000,
    }),
  }
end

function M.on_attach(on_attach)
  return function(client, attach_bufnr)
    if not vim.tbl_contains(M.filetypes, vim.bo[attach_bufnr].filetype) then
      on_attach(client, attach_bufnr)
      return
    end

    if client.server_capabilities.documentFormattingProvider then
      M._setup_timer()
      local autocmd_group = "vtvz_auto_format_" .. attach_bufnr
      vim.api.nvim_create_augroup(autocmd_group, { clear = true })

      vim.api.nvim_create_autocmd("BufWritePre", {
        desc = "Auto format before save",
        group = autocmd_group,
        buffer = attach_bufnr,
        callback = function(args)
          local bufnr = args.buf
          if vim.b[bufnr].autoformat_enabled == nil then
            vim.b[bufnr].autoformat_enabled = true
          end

          if not require("user.utils").do_autoformat_buffer(bufnr) then
            return
          end

          M.formatting[bufnr] = true
          vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

          vim.lsp.buf.format({
            timeout_ms = 60 * 1000,
            async = true,
            bufnr = bufnr,
          })
        end,
      })
    end
  end
end

return M
