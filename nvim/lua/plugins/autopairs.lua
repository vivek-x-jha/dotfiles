-- https://github.com/windwp/nvim-autopairs
return {
	'windwp/nvim-autopairs',
	opts = function()
		-- setup cmp for autopairs
		-- local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
		-- require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())

		return {
			disable_filetype = { 'TelescopePrompt', 'vim' },
		}
	end,
}
