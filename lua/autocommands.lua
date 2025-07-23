vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]]
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    -- image.nvim should be fixed now
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Automatically close tab/vim when nvim-tree is the last window in the tab
vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"

vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
  end,
})

local function convert_to_pdf()
  local full_path = vim.fn.expand "%:p"
  local file_dir = vim.fn.fnamemodify(full_path, ":h")
  local file_name = vim.fn.fnamemodify(full_path, ":t")
  local file_basename = vim.fn.fnamemodify(full_path, ":t:r")
  
  -- Create PDF in the same directory as the markdown file
  local output_pdf = file_dir .. "/" .. file_basename .. ".pdf"
  
  local cmd = string.format(
    'cd "%s" && pandoc -f markdown-implicit_figures -s "%s" -o "%s" >/dev/null 2>&1',
    file_dir,
    file_name,
    output_pdf
  )

  local dir = vim.fn.fnamemodify(full_path, ":h")
  -- vim.fn.system(cmd)

  vim.fn.jobstart(cmd, {
    cwd = dir,
    on_exit = function(_, exit_code, _)
      vim.schedule(function()
        if exit_code == 0 then
          vim.notify("Pandoc conversion succeeded!", vim.log.levels.INFO)
        else
          vim.notify("Pandoc conversion failed!", vim.log.levels.ERROR)
        end
      end)
    end,
  })
end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.md",
  callback = function()
    convert_to_pdf()
  end,
})

vim.api.nvim_create_augroup("LatexAutocompile", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = "LatexAutocompile",
  pattern = "*.tex",
  callback = function()
    local file = vim.fn.expand "%:p"
    local dir = vim.fn.fnamemodify(file, ":h")
    local filename = vim.fn.fnamemodify(file, ":t")
    local cmd = { "pdflatex", "-interaction=nonstopmode", filename }
    vim.fn.jobstart(cmd, {
      cwd = dir,
      on_exit = function(_, exit_code, _)
        vim.schedule(function()
          if exit_code == 0 then
            vim.notify("LaTeX: Compilation succeeded!", vim.log.levels.INFO)
          else
            vim.notify("LaTeX: Compilation failed!", vim.log.levels.ERROR)
          end
        end)
      end,
    })
  end,
})
