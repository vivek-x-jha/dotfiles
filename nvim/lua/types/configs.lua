--- @class AutoGroup: table
--- @field [1] string Group name
--- @field [2] boolean Clear old group commands

--- @class AutoCmd: table
--- @field enabled? boolean Flag to supress command
--- @field after? boolean Flag to schedule auto command
--- @field desc? string Description of auto command
--- @field group? integer ID assigned to auto command
--- @field event string|string[] Trigger(s) to execute `command` or `callback`
--- @field pattern? string|string[] Secondary trigger - defaults to '*'
--- @field callback? fun(args?: table): nil|string Custom function to execute
--- @field command? string Vim command to execute

--- @class UserCmd: table
--- @field enabled? boolean Flag to supress command
--- @field after? boolean Flag to schedule user comand
--- @field name string Name of user command
--- @field desc? string Description of user command
--- @field command fun() Command(s) to execute

--- @class KeyMap: table
--- @field enabled? boolean Flag to supress command
--- @field desc string Description of the keybinding
--- @field mode string|string[] Keybinding mode(s)
--- @field keys string Key sequence
--- @field command string|fun() Command or function to execute
--- @field remap? boolean Whether the keybinding requires remapping

--- @class Utils
--- @field create_auto_group fun(opts: string|AutoGroup): integer Converts autocommand group name to ID and clears old group commands
--- @field create_auto_command fun(opts: AutoCmd): nil Creates and configures autocommand
--- @field create_user_command fun(opts: UserCmd): nil Creates and configures user command
--- @field filenames fun(folder: string): string[] Creates array of all lua files in given folder
--- @field load fun(self: Utils, type: string): nil Remaps key sequence
--- @field set_keymap fun(opts: KeyMap): nil Remaps key sequence
--- @field set_rtp fun(lazypath: string): nil Sets runtime path (rtp) and clones lazy.nvim repo if not present
--- @field set_hlgroups fun(hlgroups: table): nil Sets highlight groups
--- @field set_terminal_colors fun(theme: Colorscheme): nil Sets terminal colors based on theme
