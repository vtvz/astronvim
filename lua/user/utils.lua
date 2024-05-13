local M = {}

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

return M
