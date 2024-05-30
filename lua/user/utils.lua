local M = {
  _neotree_open = false,
}

function M.neotree_open()
  M._neotree_open = true
end

function M.neotree_close()
  M._neotree_open = false
end

function M.neotree_is_open()
  return M._neotree_open
end

function M.status_column_padding()
  return {
    provider = function()
      if M.neotree_is_open() or not vim.bo.buflisted then
        return ""
      end

      return string.rep(" ", 31)
    end,
  }
end

function M.shorten(url)
  local curl = require("plenary.curl")
  local api_token = vim.fn.getenv("TINYURL_API_TOKEN")

  local result = curl.post("https://api.tinyurl.com/create", {
    body = {
      url = url,
      api_token = api_token,
    },
  })

  P(vim.fn.json_decode(result.body).data.tiny_url)
end

function M.interpolate(template, variables)
  return (template:gsub("($%b{})", function(w)
    return variables[w:sub(3, -2)] or w
  end))
end

function M.get_visual_range()
  local _, row_one = table.unpack(vim.fn.getpos("v"))

  local _, row_two = table.unpack(vim.fn.getpos("."))
  local rows = { row_one, row_two }
  table.sort(rows)

  return rows[1], rows[2]
end

function M.notify(msg, level)
  if not level then
    level = vim.log.levels.INFO
  end

  vim.notify(msg, level, { title = "NeoVim" })
end

function M.system_open(link)
  require("astrocore").system_open(link)
end

function M.buffer_close_all()
  require("astrocore.buffer").close_all(true, false)
end

function M.buffer_navigate_next()
  require("astrocore.buffer").nav(vim.v.count1)
end

function M.buffer_navigate_prev()
  require("astrocore.buffer").nav(-vim.v.count1)
end

function M.toggle_buffer_autoformat()
  require("astrolsp.toggles").buffer_autoformat()
end

function M.toggle_autoformat()
  require("astrolsp.toggles").autoformat()
end

function M.do_autoformat_buffer(bufnr)
  local autoformat = require("astrolsp").config.formatting.format_on_save

  if vim.b[bufnr].autoformat == false then
    autoformat = false
  end

  return autoformat
end

function M.copy_filename(filepath)
  local modify = vim.fn.fnamemodify

  local actions = {
    { key = "BASE", value = modify(filepath, ":t:r") },
    { key = "EXT ", value = modify(filepath, ":t:e") },
    { key = "NAME", value = modify(filepath, ":t") },
    { key = "CWD ", value = modify(filepath, ":.") },
    { key = "HOME", value = modify(filepath, ":~") },
    { key = "FULL", value = filepath },
    { key = "URI ", value = vim.uri_from_fname(filepath) },
    {
      key = "GIT ",
      value = function()
        local path = vim.fn.fnamemodify(filepath, ":.")
        return require("git_srcr").generate_link(path)
      end,
    },
  }

  local action_keys = {}
  local action_index = {}

  for k, v in ipairs(actions) do
    action_keys[k] = v.key
    action_index[v.key] = v
  end

  local function get_action_value(action_key)
    local value = action_index[action_key].value
    if type(value) == "function" then
      return value()
    end
    return value
  end

  vim.ui.select(action_keys, {
    prompt = "Choose to copy to clipboard:",
    format_item = function(action_key)
      local value = action_index[action_key].value
      if type(value) == "function" then
        value = "<will be calculated>"
      end
      local limit = 61

      if #value > 61 then
        value = value:sub(0, limit - 3 - math.floor(limit * 0.6)) .. "..." .. value:sub(-math.floor(limit * 0.6))
      end

      return ("%s: %s"):format(action_key, value)
    end,
  }, function(action_key)
    if not action_index[action_key] then
      return
    end

    local result = get_action_value(action_key)
    if result then
      require("user.utils").notify(("Copied: `%s`"):format(result))
      vim.fn.setreg("+", result)
    end
  end)
end

return M
