local common = require("git_srcr.common")
local utils = require("user.utils")

local astro_utils = function()
  return require("astronvim.utils")
end

local M = {
  patterns = {
    ["bitbucket.org"] = {
      "https://${host}/${workspace}/${repo}/src/${commit_hash}/${file_path}",
      "#lines-${start}",
      "#lines-${start}:${end}",
    },
    ["github.com"] = {
      "https://${host}/${workspace}/${repo}/blob/${commit_hash}/${file_path}",
      "#L${start}",
      "#L${start}-L${end}",
    },
    ["gitlab.com"] = {
      "https://${host}/${workspace}/${repo}/-/blob/${commit_hash}/${file_path}",
      "#L${start}",
      "#L${start}-${end}",
    },
  },
}

function M.open_link(link)
  if link then
    astro_utils().system_open(link)
  else
    astro_utils().notify("No link generated")
  end
end

function M.yank_link(link)
  if link then
    astro_utils().notify("Coplied link to git repo")

    vim.fn.setreg("+", link)
  else
    astro_utils().notify("No link generated")
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
    local start, finish = utils.get_visual_range()

    return file, start, finish
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

function M.generate_link(file_path, start_line, end_line)
  local remote = common.git_command({ "remote" })

  if not remote or remote == "" then
    return
  end

  local url = common.git_command({ "remote", "get-url", remote })

  local commit_hash = common.git_command({ "log", "--pretty=tformat:%h", "-n1", file_path })

  local host, workspace, repo = common.get_host_workstace_repo(url)

  local pattern = M.patterns[host]

  if pattern then
    local result = require("user.utils").interpolate(
      pattern[1],
      { host = host, workspace = workspace, repo = repo, commit_hash = commit_hash, file_path = file_path }
    )
    if start_line and (not end_line or start_line == end_line) then
      result = result .. require("user.utils").interpolate(pattern[2], { start = start_line })
    elseif start_line then
      result = result .. require("user.utils").interpolate(pattern[3], { start = start_line, ["end"] = end_line })
    end
    return result
  end
end

return M
