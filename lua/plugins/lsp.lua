
-- ~/.config/nvim/lua/plugins/lsp.lua

-- Stub out removed automatic_enable feature in mason-lspconfig
package.preload["mason-lspconfig.features.automatic_enable"] = function()
  return { enable = function() end, enable_all = function() end, init = function() end }
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local set = vim.api.nvim_buf_set_keymap
  set(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  set(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  set(bufnr, "n", "K",  "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  set(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  set(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  set(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  set(bufnr, "n", "<leader>li", "<cmd>LspInfo<CR>", opts)
  set(bufnr, "n", "<leader>lI", "<cmd>Mason<CR>", opts)
  set(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  set(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>", opts)
  set(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<CR>", opts)
  set(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  set(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  set(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  set(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<CR>", opts)
end

local on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {
  {
    "williamboman/mason.nvim",
    cmd    = "Mason",
    build  = ":MasonUpdate",
    opts   = {
      ui = {
        icons = {
          package_installed   = "",
          package_pending     = "",
          package_uninstalled = "",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event        = "BufReadPre",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed       = { "lua_ls", "pyright", "bashls", "jsonls", "clangd" },
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event        = "BufReadPre",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "williamboman/mason-lspconfig.nvim" },
    config = function()
      local lsp = require("lspconfig")
      lsp.lua_ls  .setup { on_attach = on_attach, capabilities = capabilities }
      lsp.pyright .setup { on_attach = on_attach, capabilities = capabilities }
      lsp.bashls  .setup { on_attach = on_attach, capabilities = capabilities }
      lsp.jsonls  .setup { on_attach = on_attach, capabilities = capabilities }
      lsp.clangd  .setup { on_attach = on_attach, capabilities = capabilities }
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event        = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("null-ls").setup {
        sources = {
          require("null-ls").builtins.formatting.stylua,
          require("null-ls").builtins.formatting.black,
        },
      }
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event        = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "jose-elias-alvarez/null-ls.nvim" },
    opts = {
      ensure_installed = { "stylua", "cpplint", "clang_format", "black" },
    },
    config = function(_, opts)
      require("mason-null-ls").setup(opts)
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy    = false,
  },
}
