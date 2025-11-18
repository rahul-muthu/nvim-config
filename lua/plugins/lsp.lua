
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
      -- Use new vim.lsp.config API (Neovim 0.11+)
      vim.lsp.config("lua_ls", {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable("lua_ls")
      
      vim.lsp.config("pyright", {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable("pyright")
      
      vim.lsp.config("bashls", {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable("bashls")
      
      vim.lsp.config("jsonls", {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable("jsonls")
      
      vim.lsp.config("clangd", {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable("clangd")
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event        = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup {
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.black,
        },
      }
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event        = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
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
