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
--- @field callback? fun(table?)|string Custom function to execute
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

--- @class GitMod
--- @field cnt integer Number of git modifications
--- @field hl string Highlight group name
--- @field icon string Symbol representing the type of modification

--- @class LspDiag
--- @field level string Severity level
--- @field hl string Highlight group name
--- @field icon string Symbol representing the type of diagnostic

--- @class GitSignsStatus
--- @field added integer Number of added lines
--- @field changed integer Number of changed lines
--- @field removed integer Number of removed lines
--- @field head string Current branch name
--- @field root string Git repository root directory
