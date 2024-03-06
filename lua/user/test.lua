local test = require("astrocommunity.motion.harpoon")

-- local ms = require("vim.lsp.protocol").Methods

local res, err = vim.lsp.buf_request_sync(0, "textDocument/semanticTokens", vim.lsp.util.make_position_params())
P(res)

local test = {
  "codeActionProvider",
  "codeLensProvider",
  "colorProvider",
  "completionProvider",
  "definitionProvider",
  "documentFormattingProvider",
  "documentHighlightProvider",
  "documentOnTypeFormattingProvider",
  "documentRangeFormattingProvider",
  "documentSymbolProvider",
  "executeCommandProvider",
  "foldingRangeProvider",
  "hoverProvider",
  "inlayHintProvider",
  "offsetEncoding",
  "referencesProvider",
  "renameProvider",
  "semanticTokensProvider",
  "signatureHelpProvider",
  "textDocumentSync",
  "typeDefinitionProvider",
  "workspace",
  "workspaceSymbolProvider",
}

local tab = vim.lsp.get_active_clients()[2].server_capabilities
local keyset = {}
local n = 0

for k, v in pairs(tab) do
  n = n + 1
  keyset[n] = k
end
P(keyset)

--

-- local Job = require("plenary.job")
--
-- local remote = Job:new({
--   command = "git",
--   args = { "remote" },
-- }):sync()
--
-- P(remote[1])
--
-- local url = Job:new({
--   command = "git",
--   args = { "remote", "get-url", remote[1] },
-- }):sync()
--
-- P(url)
--
-- local url_parts = P(vim.fn.matchlist(url[1], [[^\(.*\)@\(.*\):\(.*\)\/\(.*\)\.git$]]))
--
-- local host = url_parts[3]
-- local workspace = url_parts[4]
-- local repo = url_parts[5]
-- P(host)
-- P(workspace)
-- P(repo)
--
-- local commit_hash = Job:new({
--   command = "git",
--   args = { "rev-parse", "HEAD" },
-- }):sync()
--
-- P(commit_hash)
--
-- local current_file = P(vim.fn.expand("%:."))
--
--
-- https://bitbucket.org/novakidschool/novakid-devops/src/6e94d2c66776281c132aa6368340ea87bbb3427e/.gitignore
--
-- --
-- -- luafile %
