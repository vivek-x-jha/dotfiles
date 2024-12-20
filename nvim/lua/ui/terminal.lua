local M = {}
local utl = {}
local api = vim.api
local bo = vim.bo
local fn = vim.fn
local g = vim.g
local o = vim.o

g.terminals = {}

-- used for initially resizing terms
g.nvhterm = false
g.nvvterm = false

utl.opts_to_id = function(id)
	for _, opts in pairs(g.terminals) do
		if opts.id == id then return opts end
	end
end

utl.format_cmd = function(cmd) return type(cmd) == 'string' and cmd or cmd() end

M.save = function(index, val)
	local terms_list = g.terminals
	terms_list[tostring(index)] = val
	g.terminals = terms_list
end

M.setup = function(opts)
	-- Controls floating terminal opts
	if opts.pos == 'float' then
		local default_float_opts = {
			relative = 'editor',
			row = 0.3,
			col = 0.25,
			width = 0.5,
			height = 0.4,
			border = 'single',
		}

		local newopts = vim.tbl_deep_extend('force', default_float_opts, opts.float_opts or {})

		newopts.width = math.ceil(newopts.width * o.columns)
		newopts.height = math.ceil(newopts.height * o.lines)
		newopts.row = math.ceil(newopts.row * o.lines)
		newopts.col = math.ceil(newopts.col * o.columns)

		api.nvim_open_win(opts.buf, true, newopts)
	else
		vim.cmd(opts.pos)
	end

	local win = api.nvim_get_current_win()
	opts.win = win

	bo[opts.buf].buflisted = false
	bo[opts.buf].ft = 'NvTerm_' .. opts.pos:gsub(' ', '')
	vim.cmd 'startinsert'

	-- Resize non-floating wins initially + or only when they're toggleable
	if (opts.pos == 'sp' and not g.nvhterm) or (opts.pos == 'vsp' and not g.nvvterm) or (opts.pos ~= 'float') then
		local pos_data = {
			sp = { resize = 'height', area = 'lines' },
			vsp = { resize = 'width', area = 'columns' },
			['bo sp'] = { resize = 'height', area = 'lines' },
			['bo vsp'] = { resize = 'width', area = 'columns' },
		}

		local pos_type = pos_data[opts.pos]
		local default_split_opts = { sp = 0.3, vsp = 0.2, ['bo sp'] = 0.3, ['bo vsp'] = 0.2 }
		local size = opts.size and opts.size or default_split_opts[opts.pos]
		local new_size = o[pos_type.area] * size
		api['nvim_win_set_' .. pos_type.resize](0, math.floor(new_size))
	end

	api.nvim_win_set_buf(win, opts.buf)

	local default_winopts = { number = false, relativenumber = false }
	local winopts = vim.tbl_deep_extend('force', default_winopts, opts.winopts or {})

	for k, v in pairs(winopts) do
		vim.wo[win][k] = v
	end

	M.save(opts.buf, opts)
end

--------------------------- User API -------------------------------
M.open = function(opts)
	local buf_exists = opts.buf
	opts.buf = opts.buf or api.nvim_create_buf(false, true)

	-- handle cmd opt
	local cmd = { o.shell }
	if opts.cmd and opts.buf then cmd = { o.shell, '-c', utl.format_cmd(opts.cmd) .. '; ' .. o.shell } end

	M.setup(opts)
	M.save(opts.buf, opts)

	if not buf_exists then fn.termopen(cmd, opts.termopen_opts or { detach = false }) end

	g.nvhterm = opts.pos == 'sp'
	g.nvvterm = opts.pos == 'vsp'
end

M.toggle = function(opts)
	local x = utl.opts_to_id(opts.id)
	opts.buf = x and x.buf or nil

	if (x == nil or not api.nvim_buf_is_valid(x.buf)) or fn.bufwinid(x.buf) == -1 then
		M.open(opts)
	else
		api.nvim_win_close(x.win, true)
	end
end

-- spawns term with *cmd & runs the *cmd if the keybind is run again
M.runner = function(opts)
	local x = utl.opts_to_id(opts.id)
	local clear_cmd = opts.clear_cmd or 'clear; '
	opts.buf = x and x.buf or nil

	-- if buf doesnt exist
	if x == nil then
		M.open(opts)
	else
		-- window isnt visible
		if fn.bufwinid(x.buf) == -1 then M.setup(opts) end

		local cmd = utl.format_cmd(opts.cmd)

		if x.buf == api.nvim_get_current_buf() then
			api.nvim_set_current_buf(g.buf_history[#g.buf_history - 1])
			cmd = utl.format_cmd(opts.cmd)
			api.nvim_set_current_buf(x.buf)
		end

		local job_id = vim.b[x.buf].terminal_job_id
		api.nvim_chan_send(job_id, clear_cmd .. cmd .. ' \n')
	end
end

return M
