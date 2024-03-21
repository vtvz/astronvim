local utils = require("user.utils")

local common = require("git_srcr.common")

local astro_utils = function()
  return require("astronvim.utils")
end

local M = {
  providers = {
    ["bitbucket.org"] = function(workspace, repo, branch)
      local token = vim.fn.getenv("BITBUCKET_API_TOKEN")

      if not token then
        error("provide token with BITBUCKET_API_TOKEN env variable")
      end

      local result = require("plenary.curl").get({
        url = utils.interpolate(
          "https://api.bitbucket.org/2.0/repositories/${workspace}/${repo}/pullrequests",
          { workspace = workspace, repo = repo }
        ),
        query = {
          q = string.format('(source.branch.name="%s")', branch),
        },
        headers = {
          Authorization = "Bearer " .. token,
        },
      })

      local pr_data = vim.fn.json_decode(result.body).values[1]

      if not pr_data then
        astro_utils().system_open(
          utils.interpolate(
            "https://bitbucket.org/${workspace}/${repo}/pull-requests/new?source=${branch}&t=1",
            { workspace = workspace, repo = repo, branch = branch }
          )
        )
        return
      end

      astro_utils().system_open(pr_data.links.html.href)
    end,
  },
}

function M.open_url(url, branch)
  local host, workspace, repo = common.get_host_workstace_repo(url)

  local provider = M.providers[host]

  if not provider then
    vim.notify("No providers for " .. host)
  end

  provider(workspace, repo, branch)
end
return M
