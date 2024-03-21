local M = {}

function M.get_host_workstace_repo(url)
  -- SSH protocol
  local _, _, host, workspace, repo = unpack(vim.fn.matchlist(url, [[^\(.*\)@\(.*\):\(.*\)\/\(.*\)\.git$]]))
  -- HTTP protocol
  if not repo then
    _, host, workspace, repo = unpack(vim.fn.matchlist(url, [[^https\?://\(.*\)\/\(.*\)/\(.*\)$]]))
  end

  if not repo then
    error("No repo")
  end

  return host, workspace, repo
end

function M.git_command(args)
  local Job = require("plenary.job")

  return Job:new({
    command = "git",
    args = args,
  })
    :sync()[1]
end

return M
