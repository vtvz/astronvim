local M = {}

local function get_handlers()
  return require("astrolsp").config.handlers
end

local function is_disabled(server)
  return get_handlers()[server] == false
end

local function all_servers()
  local seen = {}

  for _, client in ipairs(vim.lsp.get_clients()) do
    seen[client.name] = true
  end

  local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if ok then
    for _, name in ipairs(mason_lspconfig.get_installed_servers()) do
      seen[name] = true
    end
  end

  for server, _ in pairs(require("astrolsp").config.handlers) do
    if server ~= "*" then
      seen[server] = true
    end
  end

  for _, server in ipairs(require("astrolsp").config.servers or {}) do
    seen[server] = true
  end

  local servers = vim.tbl_keys(seen)
  table.sort(servers)
  return servers
end

function M.toggle_picker()
  local servers = all_servers()

  if #servers == 0 then
    vim.notify("No LSP servers found", vim.log.levels.WARN)
    return
  end

  vim.ui.select(servers, {
    prompt = "Toggle LSP server (● enabled  ○ disabled):",
    format_item = function(server)
      local icon = is_disabled(server) and "○" or "●"
      return icon .. " " .. server
    end,
  }, function(server)
    if not server then
      return
    end

    if is_disabled(server) then
      get_handlers()[server] = nil
      vim.lsp.enable(server)
      vim.notify("LSP enabled: " .. server)
    else
      for _, client in ipairs(vim.lsp.get_clients({ name = server })) do
        client:stop()
      end
      get_handlers()[server] = false
      vim.lsp.enable(server, false)
      vim.notify("LSP disabled: " .. server)
    end
  end)
end

return M
