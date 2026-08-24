local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

map("", "<Space>", "<Nop>")

-- Window navigation and resizing
map("n", "<C-h>", "<C-w>h", "Move to left window")
map("n", "<C-j>", "<C-w>j", "Move to lower window")
map("n", "<C-k>", "<C-w>k", "Move to upper window")
map("n", "<C-l>", "<C-w>l", "Move to right window")
map("n", "<C-Up>", "<cmd>resize -2<CR>", "Decrease window height")
map("n", "<C-Down>", "<cmd>resize +2<CR>", "Increase window height")
map("n", "<C-Right>", "<cmd>vertical resize -2<CR>", "Decrease window width")
map("n", "<C-Left>", "<cmd>vertical resize +2<CR>", "Increase window width")

-- Buffers and search
map("n", "<S-l>", "<cmd>bnext<CR>", "Next buffer")
map("n", "<S-h>", "<cmd>bprevious<CR>", "Previous buffer")
map("n", "<leader>h", "<cmd>nohlsearch<CR>", "Clear search highlight")

-- Keep the replaced text out of the default register.
map("v", "p", '"_dP', "Paste without replacing register")
map("v", "<", "<gv", "Indent left and reselect")
map("v", ">", ">gv", "Indent right and reselect")

map("n", "-", "<cmd>Oil<CR>", "Open parent directory")

local function compile_and_open_pdf()
	local source = vim.fn.expand("%:p")
	local directory = vim.fn.expand("%:p:h")
	local output = directory .. "/" .. vim.fn.expand("%:t:r") .. ".pdf"
	local extension = vim.fn.expand("%:e")
	local command

	if extension == "tex" then
		command = {
			"pdflatex",
			"-interaction=nonstopmode",
			"-output-directory=" .. directory,
			source,
		}
	elseif extension == "md" then
		command = { "pandoc", source, "-o", output }
	else
		vim.notify("Unsupported file type: " .. extension, vim.log.levels.ERROR)
		return
	end

	if vim.fn.executable(command[1]) == 0 then
		vim.notify(command[1] .. " is not installed", vim.log.levels.ERROR)
		return
	end
	if vim.fn.executable("zathura") == 0 then
		vim.notify("zathura is not installed", vim.log.levels.ERROR)
		return
	end

	vim.notify("Compiling " .. extension .. " to PDF…")
	vim.system(command, { text = true }, function(result)
		vim.schedule(function()
			if result.code ~= 0 then
				local message = vim.trim(result.stderr or "")
				vim.notify(message ~= "" and message or "PDF compilation failed", vim.log.levels.ERROR)
				return
			end

			if vim.fn.filereadable(output) == 0 then
				vim.notify("Compilation finished without producing a PDF", vim.log.levels.ERROR)
				return
			end

			vim.fn.jobstart({ "zathura", output }, { detach = true })
		end)
	end)
end

map("n", "<leader>z", compile_and_open_pdf, "Compile and open PDF")

local function delete_buffer()
	local current = vim.api.nvim_get_current_buf()
	local alternate = vim.fn.bufnr("#")

	if vim.api.nvim_buf_is_valid(alternate) and vim.api.nvim_buf_is_loaded(alternate) then
		vim.api.nvim_set_current_buf(alternate)
	else
		vim.cmd.bnext()
	end

	vim.api.nvim_buf_delete(current, {})
end

map("n", "<S-q>", delete_buffer, "Delete buffer")
