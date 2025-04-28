vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		-- Save the current cursor position
		local cursor_position = vim.api.nvim_win_get_cursor(0)

		-- Use LSP formatting if available
		vim.lsp.buf.format({ async = false })

		-- Apply manual indentation as a fallback
		vim.cmd("keepjumps normal gg=G")

		-- Ensure the cursor position is within valid bounds
		local last_line = vim.api.nvim_buf_line_count(0)
		cursor_position[1] = math.min(cursor_position[1], last_line) -- Adjust row if it exceeds last line
		local line_length = #vim.api.nvim_buf_get_lines(0, cursor_position[1] - 1, cursor_position[1], true)[1] or 0
		cursor_position[2] = math.min(cursor_position[2], line_length) -- Adjust column if it exceeds line length

		-- Restore the cursor position
		vim.api.nvim_win_set_cursor(0, cursor_position)
	end,
})
