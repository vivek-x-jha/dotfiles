local b16 = require 'ui.base16'
require('ui.utils').highlight {
	-- Diff Highlights
	diffOldFile = { fg = b16.brightred },
	diffNewFile = { fg = b16.brightgreen },
	DiffAdd = { fg = b16.green },
	DiffAdded = { fg = b16.green },
	DiffChange = { fg = b16.yellow },
	DiffChangeDelete = { fg = b16.red },
	DiffModified = { fg = b16.yellow },
	DiffDelete = { fg = b16.red },
	DiffRemoved = { fg = b16.red },
	DiffText = { fg = b16.white, bg = b16.grey },

	-- Git Commit Highlights
	gitcommitOverflow = { fg = b16.red },
	gitcommitSummary = { fg = b16.green },
	gitcommitComment = { fg = b16.grey },
	gitcommitUntracked = { fg = b16.grey },
	gitcommitDiscarded = { fg = b16.grey },
	gitcommitSelected = { fg = b16.grey },
	gitcommitHeader = { fg = b16.brightmagenta },
	gitcommitSelectedType = { fg = b16.blue },
	gitcommitUnmergedType = { fg = b16.blue },
	gitcommitDiscardedType = { fg = b16.blue },
	gitcommitBranch = { fg = b16.yellow, bold = true },
	gitcommitUntrackedFile = { fg = b16.yellow },
	gitcommitUnmergedFile = { fg = b16.red, bold = true },
	gitcommitDiscardedFile = { fg = b16.red, bold = true },
	gitcommitSelectedFile = { fg = b16.green, bold = true },
}
