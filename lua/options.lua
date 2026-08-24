vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard
vim.opt.completeopt = { "menuone", "noselect" } -- native completion menu behavior
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.mouse = ""                              -- Disable mouse
vim.opt.pumheight = 10                          -- pop up menu height
vim.opt.smartcase = true                        -- smart case
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                        -- disable swap files
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 300                        -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.updatetime = 300                        -- delay for CursorHold and swap writes
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.shiftwidth = 4                          -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4                             -- insert 4 spaces for a tab
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.number = true                           -- set numbered lines
vim.opt.relativenumber = true
vim.opt.laststatus = 3                          -- only the last window will always have a status line
vim.opt.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                            -- display lines as one long line
vim.opt.scrolloff = 12                           -- minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 12                       -- minimal number of screen columns to keep to the left and right of the cursor if wrap is `false`
vim.opt.guifont = "monospace:h17"               -- the font used in graphical neovim applications
vim.opt.fillchars.eob = " "                     -- show empty lines at the end of a buffer as ` ` {default `~`}
vim.opt.shortmess:append "c"                    -- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"
vim.opt.whichwrap:append "<,>,[,],h,l"          -- keys allowed to move to the previous/next line when the beginning/end of line is reached
vim.opt.iskeyword:append "-"                    -- treats words with `-` as single words

-- Filetype plugins can reset formatoptions, so apply this after they load.
local options_augroup = vim.api.nvim_create_augroup("config-options", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = options_augroup,
  desc = "Do not continue comments on a new line",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Disable optional providers to avoid warnings
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
