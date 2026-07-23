local diagnostic_signs = {
	Error = "\u{f057} ",
	Warn = "\u{f071} ",
	Hint = "\u{ea61}",
	Info = "\u{f05a}",
}

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
      [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
      [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
      [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {border = "rounded", source = "always", header = "", prefix = "", focusable = false, style = "minimal",},
})

do
	local orig = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig(contents, syntax, opts, ...)
	end
end

local function lsp_on_attach(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
  end

  local bufnr = ev.buf
	local opts = { noremap = true, silent = true, buffer = bufnr }

end

local augroup = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

vim.keymap.set("n", "<leader>q", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- Get blink.cmp capabilities
local function get_capabilities()
	local has_blink, blink = pcall(require, "blink.cmp")
	if has_blink then
		return blink.get_lsp_capabilities()
	end
	return vim.lsp.protocol.make_client_capabilities()
end

-- Configure LSP servers using new vim.lsp.config API
local capabilities = get_capabilities()

vim.lsp.config.lua_ls = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}

-- vim.lsp.config["*"] = {
-- 	capabilities = require("blink.cmp").get_lsp_capabilities()
-- }

vim.lsp.config('clangd', {
  cmd = {'clangd'},
  filetypes = {'c', 'cpp', 'h'},
})

vim.lsp.enable({'clangd', 'lua_ls'})

vim.o.autocomplete = true
