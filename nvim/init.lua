vim.loader.enable()

require("chrollo.config.settings")
require("chrollo.config.lazy")
require("chrollo.config.lsp")

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*" },
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.api.nvim_exec("normal! g'\"", false)
		end
	end
})
