--- @class LspMsg
--- @field lsp_msg string LSP message(s)

--- @class GitModification
--- @field cnt integer Number of git modifications
--- @field hl string Highlight group name
--- @field icon string Symbol representing the type of modification

--- @class LspDiagnostic
--- @field level string Severity level
--- @field hl string Highlight group name
--- @field icon string Symbol representing the type of diagnostic

--- @class GitSignsStatus
--- @field added integer Number of added lines
--- @field changed integer Number of changed lines
--- @field removed integer Number of removed lines
--- @field head string Current branch name
--- @field root string Git repository root directory

--- @class StatusLineUtils
--- @field state LspMsg Manages state of LSP message(s)
--- @field modes table Vim mode mappings
--- @field stbufnr fun(): integer Gets current buffer ID
--- @field gitsigns_status fun(self: StatusLineUtils): boolean, GitSignsStatus Creates gitsigns status table

--- @class StatusLineModules
--- @field mode fun(): string Creates statusline module: mode indicator
--- @field git_branch fun(): string Creates statusline module: git branch
--- @field lsp fun(): string Creates statusline module: language server name
--- @field diagnostics fun(): string Creates statusline module: LSP diagnostics
--- @field file fun(): string Creates statusline module: current file
--- @field git_mod fun(): string Creates statusline module: git modification
--- @field lsp_msg fun(): string Creates statusline module: LSP message
--- @field cwd fun(): string Creates statusline module: current working directory
--- @field git_status fun(): string Creates statusline module: project git status
--- @field cursor fun(): string Creates statusline module: row and column counter

--- @class StatusLine
--- @field state LspMsg Table of LSP message(s)
--- @field setup fun(): string Aggregates all statusline modules
