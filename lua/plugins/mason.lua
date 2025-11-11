-- Customize Mason plugins
-- In v5, mason-tool-installer replaces separate ensure_installed tables

---@type LazySpec
return {
  -- mason-tool-installer.nvim replaces mason-lspconfig, mason-null-ls, and mason-nvim-dap ensure_installed
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers (note: package names changed, e.g., lua_ls → lua-language-server)
        "ansible-language-server", -- was ansiblels
        "dockerfile-language-server", -- was dockerls
        "eslint-lsp", -- was eslint
        "html-lsp", -- was html
        "jdtls", -- unchanged
        "json-lsp", -- was jsonls
        "lua-language-server", -- was lua_ls
        "rust-analyzer", -- was rust_analyzer
        "terraform-ls", -- was terraformls

        -- Formatters/Linters (from mason-null-ls)
        "hadolint",
        "nginx-language-server",
        "prettier",
        "shellcheck",
        "shfmt",
        "stylua",

        -- DAP (from mason-nvim-dap)
        -- "python",
        -- add more debuggers as needed
      },
    },
  },
}
