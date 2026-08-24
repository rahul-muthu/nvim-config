local treesitter_languages = {
	"bash",
	"c",
	"cpp",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
}

local pack_augroup = vim.api.nvim_create_augroup("config-pack", { clear = true })
local treesitter_augroup = vim.api.nvim_create_augroup("config-treesitter", { clear = true })
local lsp_augroup = vim.api.nvim_create_augroup("config-lsp", { clear = true })

-- vim.pack does not have a `build` field, so native/build steps belong in a
-- PackChanged hook. This runs after both a fresh install and an update.
vim.api.nvim_create_autocmd("PackChanged", {
	group = pack_augroup,
	desc = "Run plugin build and update hooks",
	callback = function(args)
		local data = args.data
		if not data or (data.kind ~= "install" and data.kind ~= "update") then
			return
		end

		if data.spec.name == "telescope-fzf-native.nvim" then
			vim.system({ "make" }, { cwd = data.path }, function(result)
				if result.code ~= 0 then
					vim.schedule(function()
						vim.notify("Failed to build telescope-fzf-native.nvim", vim.log.levels.ERROR)
					end)
				end
			end)
		elseif data.spec.name == "nvim-treesitter" and data.kind == "update" then
			vim.schedule(function()
				require("nvim-treesitter").update(treesitter_languages)
			end)
		end
	end,
})

-- Essential plugins
vim.pack.add({
	-- Colorscheme
	{ src = "https://github.com/rose-pine/neovim", name = "rose-pine" },

	-- File manager
	{ src = "https://github.com/stevearc/oil.nvim" },

	-- Treesitter for syntax highlighting
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },

	-- Telescope for fuzzy finding
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },

	-- LSP
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-lspconfig.nvim" },

	-- Autopairs
	{ src = "https://github.com/windwp/nvim-autopairs" },
})

-- Rosé Pine main with a transparent background and solid block cursor.
require("rose-pine").setup({
	variant = "main",
	dark_variant = "main",
	styles = {
		bold = true,
		italic = false,
		transparency = true,
	},
	highlight_groups = {
		Normal = { bg = "none" },
		NormalNC = { bg = "none" },
		SignColumn = { bg = "none" },
		LineNr = {
			fg = "muted",
			bg = "none",
		},
		CursorLineNr = {
			fg = "text",
			bg = "none",
			bold = true,
		},
		Cursor = {
			fg = "#0e0b00",
			bg = "#dffff3",
		},
		CursorLine = { bg = "none" },
		Visual = { bg = "highlight_med" },
		StatusLine = {
			fg = "text",
			bg = "#292929",
		},
		StatusLineNC = {
			fg = "muted",
			bg = "#292929",
		},
	},
})
vim.cmd.colorscheme("rose-pine")
vim.opt.guicursor = {
	"n-v-c:block-Cursor",
	"i-ci-ve:block-Cursor",
	"r-cr:block-Cursor",
	"o:block-Cursor",
}

-- Treesitter's current main branch uses Neovim's built-in highlighting API.
local treesitter = require("nvim-treesitter")
treesitter.setup({})
treesitter.install(treesitter_languages)

vim.api.nvim_create_autocmd("FileType", {
	group = treesitter_augroup,
	desc = "Enable Treesitter highlighting when a parser is available",
	callback = function(args)
		if pcall(vim.treesitter.start, args.buf) then
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

-- LSP: attach handler
vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_augroup,
	desc = "Enable completion and LSP keymaps",
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end

		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
		end

		map("gD", vim.lsp.buf.declaration, "LSP declaration")
		map("gd", vim.lsp.buf.definition, "LSP definition")
		map("K", vim.lsp.buf.hover, "LSP hover")
		map("gI", vim.lsp.buf.implementation, "LSP implementation")
		map("gr", vim.lsp.buf.references, "LSP references")
		map("gl", vim.diagnostic.open_float, "Line diagnostics")
		map("<leader>la", vim.lsp.buf.code_action, "LSP code action")
		map("<leader>lj", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Next diagnostic")
		map("<leader>lk", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, "Previous diagnostic")
		map("<leader>lr", vim.lsp.buf.rename, "LSP rename")
		map("<leader>ls", vim.lsp.buf.signature_help, "LSP signature help")
		map("<leader>lf", vim.lsp.buf.format, "LSP format")
	end,
})

-- Mason installs the servers; nvim-lspconfig supplies their default configs.
local lsp_servers = { "lua_ls", "pyright", "bashls", "jsonls", "clangd" }
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = lsp_servers,
})
vim.lsp.enable(lsp_servers)

-- Telescope
local telescope = require("telescope")
telescope.setup({
	defaults = {
		path_display = { "truncate" },
		file_ignore_patterns = { ".git/", "node_modules/", "__pycache__/" },
		preview = {
			treesitter = { enable = false },
		},
	},
	pickers = {
		find_files = { hidden = true },
	},
})
pcall(telescope.load_extension, "fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>H", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>d", builtin.diagnostics, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>r", builtin.lsp_references, { desc = "LSP references" })

-- Oil
require("oil").setup({
	view_options = { show_hidden = true },
})

-- Autopairs
require("nvim-autopairs").setup({
	check_ts = true,
	disable_filetype = { "TelescopePrompt" },
	ts_config = {
		lua = { "string", "source" },
	},
})
