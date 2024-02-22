local M = {
  patterns = {
    ["bitbucket.org"] = "https://%s/%s/%s/src/%s/%s#lines-%s:%s",
    ["github.com"] = "https://%s/%s/%s/blob/%s/%s#L%s-L%s",
    ["gitlab.com"] = "https://%s/%s/%s/-/blob/%s/%s#L%s-%s",
  },
}

function M.open_link(link)
  if link then
    require("astronvim.utils").system_open(link)
  else
    require("astronvim.utils").notify("No link generated")
  end
end

function M.copy_link(link)
  if link then
    require("astronvim.utils").notify("Coplied link to git repo")

    vim.fn.setreg("+", link)
  else
    require("astronvim.utils").notify("No link generated")
  end
end

function M.open_normal()
  local current_line, _ = table.unpack(vim.api.nvim_win_get_cursor(0))

  local link = M.generate_link(current_line, current_line)

  M.open_link(link)
end

function M.open_visual()
  local _, col_one = table.unpack(vim.fn.getpos("v"))

  local _, col_two = table.unpack(vim.fn.getpos("."))
  local cols = { col_one, col_two }
  table.sort(cols)

  local link = M.generate_link(cols[1], cols[2])

  M.open_link(link)
end

function M.yank_normal()
  local current_line, _ = table.unpack(vim.api.nvim_win_get_cursor(0))

  local link = M.generate_link(current_line)

  M.copy_link(link)
end

function M.generate_link(start_line, end_line)
  local Job = require("plenary.job")

  local remote = Job:new({
    command = "git",
    args = { "remote" },
  })
    :sync()[1]

  if not remote or remote == "" then
    return
  end

  local url = Job:new({
    command = "git",
    args = { "remote", "get-url", remote },
  })
    :sync()[1]

  local commit_hash = Job:new({
    command = "git",
    args = { "rev-parse", "HEAD" },
  })
    :sync()[1]

  local current_file = vim.fn.expand("%:.")
  local commit_hash = Job:new({
    command = "git",
    args = { "log", "--pretty=tformat:%H", "-n1", current_file },
  })
    :sync()[1]

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
    return string.format(pattern, host, workspace, repo, commit_hash, current_file, start_line, end_line)
  end
end

return M
