-- Notification history items
---@class NotifyEntry
---@field message string|string[]
---@field level integer|string|nil
---@field title string[]|string|nil
---@field icon string|nil
---@field time number|nil

-- Dashboard module metadata
---@class Dashboard
---@field setup fun(buf?: integer, win?: integer, action?: string) -- Displays header + buttons

-- Dashboard button definition
---@class DashboardButton
---@field txt string|fun():string
---@field hl string
---@field no_gap? boolean
---@field rep? boolean
---@field keys? string
---@field cmd? string|fun():any

-- Terminal positions accepted by the terminal UI
---@alias TermPos 'float'|'sp'|'vsp'|'bo sp'|'bo vsp'

-- Floating window sizing options
---@class FloatOpts
---@field relative? 'editor'|'win'|'cursor'
---@field row? number    -- fraction (0..1) before scaling
---@field col? number    -- fraction (0..1) before scaling
---@field width? number  -- fraction (0..1) before scaling
---@field height? number -- fraction (0..1) before scaling

-- Base terminal open options
---@class TermOpenOpts
---@field id any
---@field pos TermPos
---@field buf? integer
---@field size? number
---@field float_opts? FloatOpts
---@field winopts? table<string, any>
---@field cmd? string|fun():string
---@field termopen_opts? table

-- Terminal setup options after buffer creation
---@class TermSetupOpts : TermOpenOpts
---@field buf integer
---@field win? integer

-- Recorded terminal state
---@class TermRecord : TermSetupOpts
---@field win integer

-- Terminal toggle options
---@class TermToggleOpts : TermOpenOpts

-- Terminal runner options
---@class TermRunnerOpts : TermOpenOpts
---@field cmd string|fun():string
---@field clear_cmd? string

-- Public terminal module API
---@class Terminal
---@field save fun(index: integer|string, val: TermRecord)
---@field setup fun(opts: TermSetupOpts)
---@field open fun(opts: TermOpenOpts)
---@field toggle fun(opts: TermToggleOpts)
---@field runner fun(opts: TermRunnerOpts)

-- Internal helpers for the terminal module
---@class TermUtils
---@field opts_to_id fun(id: any): (TermRecord|nil)
---@field format_cmd fun(cmd: string|fun():string): string
