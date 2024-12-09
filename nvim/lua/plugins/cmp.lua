-- https://github.com/hrsh7th/nvim-cmp
return {
	'hrsh7th/nvim-cmp',
	event = 'InsertEnter',
	opts = function()
		local b16 = require 'ui.base16'
		require('ui.utils').highlight {

			CmpBorder = { fg = b16.grey },
			CmpItemAbbr = { fg = b16.white },
			CmpItemAbbrMatch = { fg = b16.blue, bold = true },
			CmpDoc = { bg = b16.black },
			CmpDocBorder = { fg = b16.grey },
			CmpPmenu = { bg = b16.black },
			CmpSel = { link = 'PmenuSel', bold = true },

			-- cmp item kinds
			CmpItemKindConstant = { fg = b16.base09 },
			CmpItemKindFunction = { fg = b16.base0D },
			CmpItemKindIdentifier = { fg = b16.base08 },
			CmpItemKindField = { fg = b16.base08 },
			CmpItemKindVariable = { fg = b16.base0E },
			CmpItemKindSnippet = { fg = b16.red },
			CmpItemKindText = { fg = b16.base0B },
			CmpItemKindStructure = { fg = b16.base0E },
			CmpItemKindType = { fg = b16.base0A },
			CmpItemKindKeyword = { fg = b16.base07 },
			CmpItemKindMethod = { fg = b16.base0D },
			CmpItemKindConstructor = { fg = b16.blue },
			CmpItemKindFolder = { fg = b16.base07 },
			CmpItemKindModule = { fg = b16.base0A },
			CmpItemKindProperty = { fg = b16.base08 },
			CmpItemKindEnum = { fg = b16.blue },
			CmpItemKindUnit = { fg = b16.base0E },
			CmpItemKindClass = { fg = b16.teal },
			CmpItemKindFile = { fg = b16.base07 },
			CmpItemKindInterface = { fg = b16.green },
			CmpItemKindColor = { fg = b16.white },
			CmpItemKindReference = { fg = b16.base05 },
			CmpItemKindEnumMember = { fg = b16.purple },
			CmpItemKindStruct = { fg = b16.base0E },
			CmpItemKindValue = { fg = b16.cyan },
			CmpItemKindEvent = { fg = b16.yellow },
			CmpItemKindOperator = { fg = b16.base05 },
			CmpItemKindTypeParameter = { fg = b16.base08 },
			CmpItemKindCopilot = { fg = b16.green },
			CmpItemKindCodeium = { fg = b16.vibrant_green },
			CmpItemKindTabNine = { fg = b16.baby_pink },
			CmpItemKindSuperMaven = { fg = b16.yellow },
		}

		local cmp = require 'cmp'
		local cmp_ui = {
			icons_left = false,
			lspkind_text = true,
			style = 'default',
			format_colors = {
				icon = '󱓻',
			},
		}

		return {
			completion = { completeopt = 'menu,menuone' },

			snippet = {
				expand = function(args) require('luasnip').lsp_expand(args.body) end,
			},

			mapping = {
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-d>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.close(),

				['<CR>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Insert,
					select = true,
				},

				['<Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif require('luasnip').expand_or_jumpable() then
						require('luasnip').expand_or_jump()
					else
						fallback()
					end
				end, { 'i', 's' }),

				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif require('luasnip').jumpable(-1) then
						require('luasnip').jump(-1)
					else
						fallback()
					end
				end, { 'i', 's' }),
			},

			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'buffer' },
				{ name = 'nvim_lua' },
				{ name = 'path' },
			},

			formatting = {
				format = function(_, item)
					local icons = require 'ui.icons.lspkind'

					item.abbr = item.abbr .. ' '
					item.menu = cmp_ui.lspkind_text and item.kind or ''
					item.menu_hl_group = 'CmpItemKind' .. (item.kind or '')
					item.kind = (icons[item.kind] or '') .. ' '

					if not cmp_ui.icons_left then item.kind = ' ' .. item.kind end

					return item
				end,

				fields = { 'abbr', 'kind', 'menu' },
			},

			window = {
				completion = {
					scrollbar = false,
					side_padding = 1,
					winhighlight = 'Normal:CmpPmenu,CursorLine:CmpSel,Search:None,FloatBorder:CmpBorder',
					border = 'single',
				},

				documentation = {
					border = 'single',
					winhighlight = 'Normal:CmpDoc,FloatBorder:CmpDocBorder',
				},
			},
		}
	end,
}
