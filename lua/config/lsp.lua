vim.lsp.config('clangd', {
  cmd = {'clangd'},
  filetypes = {'c', 'h'},
})

vim.lsp.enable({'clangd'})

vim.o.autocomplete = true

local diagnostic_signs = {
  Error = "E",
  Warn = "W",
  Hint = "H",
  Info = "I",
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
