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

return M
