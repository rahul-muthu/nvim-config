return {

  {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    event = { "VimEnter", "InsertEnter", "BufReadPre", "BufAdd", "BufNew", "BufReadPost" },
    opts = function()
      local hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end

      local diff = {
        "diff",
        colored = false,
        symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
        cond = hide_in_width,
      }

      return {
        options = {

          theme = auto,
          globalstatus = true,
          disabled_filetypes = { "alpha", "dashboard" },
        },

        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diagnostics" },
          lualine_c = { "buffers" },
          lualine_d = { "filename" },
          lualine_x = { diff },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {},
      }
    end,
  },
}
