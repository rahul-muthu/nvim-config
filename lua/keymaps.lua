-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Close buffer without deleting window arrangement
local function delete_buffer()
  local current_buf = vim.api.nvim_get_current_buf()
  local alt_buf = vim.fn.bufnr "#"
  if vim.api.nvim_buf_is_valid(alt_buf) and vim.api.nvim_buf_is_loaded(alt_buf) then
    vim.cmd("buffer " .. alt_buf)
  else
    vim.cmd "bnext"
  end
  vim.cmd("bdelete " .. current_buf)
end

keymap("n", "<S-q>", delete_buffer, opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Plugins --

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", opts)

-- Oil
keymap("n", "-", "<cmd>Oil<CR>", opts)

-- Notes
local function open_zathura_for_current_file()
  -- Get the current file's full path
  local full_path = vim.fn.expand("%:p")
  
  -- Get the directory of the current file
  local file_dir = vim.fn.expand("%:p:h")
  
  -- Get the filename without extension
  local file_basename = vim.fn.expand("%:t:r")
  
  -- Construct the PDF path (same directory, same name, .pdf extension)
  local output_pdf = file_dir .. "/" .. file_basename .. ".pdf"
  
  -- Check if PDF exists
  if vim.fn.filereadable(output_pdf) == 0 then
    vim.notify("PDF not found: " .. output_pdf, vim.log.levels.ERROR)
    
    -- Attempt to compile the LaTeX file if it's not found
    if vim.fn.expand("%:e") == "tex" then
      vim.notify("Attempting to compile LaTeX file...", vim.log.levels.INFO)
      local compile_cmd = "pdflatex -interaction=nonstopmode -output-directory='" .. file_dir .. "' '" .. full_path .. "'"
      vim.fn.system(compile_cmd)
      
      -- Check again if PDF exists after compilation
      if vim.fn.filereadable(output_pdf) == 0 then
        vim.notify("Compilation failed or PDF still not found.", vim.log.levels.ERROR)
        return
      else
        vim.notify("Compilation successful!", vim.log.levels.INFO)
      end
    else
      return
    end
  end

  -- Open the PDF with Zathura
  vim.fn.jobstart({ "zathura", output_pdf }, { detach = true })
end

keymap("n", "<leader>z", open_zathura_for_current_file, opts)


local function paste_image()
  local filename = os.date("image_%Y%m%d_%H%M%S") .. ".png"
  local buffer_dir = vim.fn.expand("%:p:h")

  local filepath = buffer_dir .. "/" .. filename
  vim.fn.system("xclip -selection clipboard -t image/png -o > " .. vim.fn.shellescape(filepath))

  local markdown_str = "![](" .. filename .. ")"
  vim.api.nvim_put({ markdown_str }, "", true, true)
end

keymap("n", "<leader>p", paste_image, opts);

-- Buffer Navigation
keymap("n", "<S-l>", ":bnext<CR>", opts)     -- Shift+L for next buffer
keymap("n", "<S-h>", ":bprev<CR>", opts)     -- Shift+H for previous buffer
keymap("n", "<leader>bd", ":bdelete<CR>", opts)  -- Space+bd to delete current buffer
keymap("n", "<leader>ba", ":bufdo bd<CR>", opts) -- Space+ba to close all buffers
