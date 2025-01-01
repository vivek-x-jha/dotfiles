--------------------------- Utils --------------------------

--- @class AutoGroup: table
--- @field [1] string Group name
--- @field [2] boolean Clear old group commands

--- @class AutoCmd: table
--- @field after? boolean Flag to schedule auto command
--- @field desc? string Description of auto command
--- @field group? integer ID assigned to auto command
--- @field event string|string[] Trigger(s) to execute `command` or `callback`
--- @field pattern? string|string[] Secondary trigger - defaults to '*'
--- @field callback? fun(args?: table): nil|string Custom function to execute
--- @field command? string Vim command to execute

--- @class UsrCmd: table
--- @field after? boolean Flag to schedule user comand
--- @field name string Name of user command
--- @field desc? string Description of user command
--- @field command fun() Command(s) to execute

--- @class KeyMap: table
--- @field desc string Description of the keybinding
--- @field mode string|string[] Keybinding mode(s)
--- @field keys string Key sequence
--- @field command string|fun() Command or function to execute
--- @field remap? boolean Whether the keybinding requires remapping

--------------------------- Statusline --------------------------

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
--- @field is_activewin fun(): boolean Checks if statusline is on current window
--- @field gitsigns_status fun(self: StatusLineUtils): boolean, GitSignsStatus Creates gitsigns status table
--- @field git_mod_display fun(opts: GitModification): string Creates a formatted string for git modifications
--- @field lsp_diag_disp fun(self: StatusLineUtils, opts: LspDiagnostic): string Creates a formatted string for LSP diagnostics

--- @class StatusLineModules
--- @field mode fun(): string Creates statusline module: mode indicator
--- @field git_branch fun(): string Creates statusline module: git branch
--- @field lsp fun(): string Creates statusline module: language server name
--- @field diagnostics fun(): string Creates statusline module: LSP diagnostics
--- @field file fun(): string Creates statusline module: current file
--- @field git_mod fun(): string Creates statusline module: git modification
--- @field ['%='] string Separator for left and right alignment
--- @field lsp_msg fun(): string Creates statusline module: LSP message
--- @field cwd fun(): string Creates statusline module: current working directory
--- @field cursor fun(): string Creates statusline module: row and column counter

--- @class StatusLine
--- @field setup fun(): string Aggregates all statusline modules
--- @field autocmds fun(): nil Creates auto comand to display LSP progress bar
