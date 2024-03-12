local M = {
  patterns = {
    ["bitbucket.org"] = {
      "https://%s/%s/%s/src/%s/%s",
      "#lines-%s",
      "#lines-%s:%s",
    },
    ["github.com"] = {
      "https://%s/%s/%s/blob/%s/%s",
      "#L%s",
      "#L%s-L%s",
    },
    ["gitlab.com"] = { "https://%s/%s/%s/-/blob/%s/%s", "#L%s", "#L%s-%s" },
  },
}

function M.git_command(args)
  local Job = require("plenary.job")

  return Job:new({
    command = "git",
    args = args,
  })
    :sync()[1]
end

function M.open_link(link)
  if link then
    require("astronvim.utils").system_open(link)
  else
    require("astronvim.utils").notify("No link generated")
  end
end

function M.yank_link(link)
  if link then
    require("astronvim.utils").notify("Coplied link to git repo")

    vim.fn.setreg("+", link)
  else
    require("astronvim.utils").notify("No link generated")
  end
end

function M.file_and_range()
  local file = vim.fn.expand("%:.")

  local mode = vim.api.nvim_get_mode().mode
  if mode == "n" then
    local current_line, _ = table.unpack(vim.api.nvim_win_get_cursor(0))
    if current_line == 1 then
      return file
    end

    return file, current_line
  elseif mode == "v" or mode == "V" then
    local _, row_one = table.unpack(vim.fn.getpos("v"))

    local _, row_two = table.unpack(vim.fn.getpos("."))
    local rows = { row_one, row_two }
    table.sort(rows)

    return file, rows[1], rows[2]
  end
end

function M.open()
  local file, start_line, end_line = M.file_and_range()
  local link = M.generate_link(file, start_line, end_line)

  M.open_link(link)
end

function M.yank()
  local file, start_line, end_line = M.file_and_range()
  local link = M.generate_link(file, start_line, end_line)

  M.yank_link(link)
end

function M.generate_link(file, start_line, end_line)
  local remote = M.git_command({ "remote" })

  if not remote or remote == "" then
    return
  end

  local url = M.git_command({ "remote", "get-url", remote })

  local commit_hash = M.git_command({ "log", "--pretty=tformat:%h", "-n1", file })

  -- SSH protocol
  local _, _, host, workspace, repo = unpack(vim.fn.matchlist(url, [[^\(.*\)@\(.*\):\(.*\)\/\(.*\)\.git$]]))
  -- HTTP protocol
  if not repo then
    _, host, workspace, repo = unpack(vim.fn.matchlist(url, [[^https\?://\(.*\)\/\(.*\)/\(.*\)$]]))
  end

  if not repo then
    return
  end

  local pattern = M.patterns[host]

  if pattern then
    local result = string.format(pattern[1], host, workspace, repo, commit_hash, file)
    if start_line and (not end_line or start_line == end_line) then
      result = result .. string.format(pattern[2], start_line)
    elseif start_line then
      result = result .. string.format(pattern[3], start_line, end_line)
    end
    return result
  end
end

return M
