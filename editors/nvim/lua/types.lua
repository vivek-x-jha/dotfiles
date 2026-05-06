--- Arguments passed to `callback` functions in `nvim_create_autocmd`
---@class AutocmdCallbackArgs
---@field id integer     -- Autocmd ID (unique for this definition)
---@field event string   -- Name of the triggering event (e.g. "BufReadPost")
---@field group? integer -- Augroup ID if the autocmd belongs to one
---@field match string   -- Matched pattern or filename
---@field buf integer    -- Buffer number associated with the event
---@field file string    -- Filename associated with the event

---@class NotifyEntry
---@field message string|string[]
---@field level integer|string|nil
---@field title string[]|string|nil
---@field icon string|nil
---@field time number|nil

---@alias TermPos 'float'|'sp'|'vsp'|'bo sp'|'bo vsp'

---@class FloatOpts
---@field relative? 'editor'|'win'|'cursor'
---@field row? number    -- fraction (0..1) before scaling
---@field col? number    -- fraction (0..1) before scaling
---@field width? number  -- fraction (0..1) before scaling
---@field height? number -- fraction (0..1) before scaling

---@class TermRecord
---@field id any
---@field buf integer
---@field win integer
---@field pos TermPos
---@field size? number
---@field float_opts? FloatOpts
---@field winopts? table<string, any>
---@field cmd? string|fun():string
---@field termopen_opts? table

---@class TermOpenOpts
---@field id any
---@field pos TermPos
---@field buf? integer
---@field size? number
---@field float_opts? FloatOpts
---@field winopts? table<string, any>
---@field cmd? string|fun():string
---@field termopen_opts? table

---@class TermToggleOpts
---@field id any
---@field pos TermPos
---@field buf? integer
---@field size? number
---@field float_opts? FloatOpts
---@field winopts? table<string, any>
---@field cmd? string|fun():string
---@field termopen_opts? table

---@class TermRunnerOpts
---@field id any
---@field pos TermPos
---@field buf? integer
---@field size? number
---@field float_opts? FloatOpts
---@field winopts? table<string, any>
---@field cmd string|fun():string
---@field clear_cmd? string
---@field termopen_opts? table
