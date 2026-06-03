local M = {}

function M.git_root()
	local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 or not root then
		vim.notify("Not in a git repository", vim.log.levels.ERROR)
		error("Not in a git repository", 0)
	end
	return root
end

function M.dir_context(subdir)
	local root = M.git_root()
	local dir = root .. "/" .. subdir
	if vim.fn.isdirectory(dir) ~= 1 then
		vim.notify("No " .. subdir .. "/ directory found", vim.log.levels.ERROR)
		error("No " .. subdir .. "/ directory found", 0)
	end
	return { git_root = root, dir = dir }
end

function M.file_context(extension, subdir)
	local ctx = M.dir_context(subdir)
	local filepath = vim.fn.expand("%:p")
	local filename = vim.fn.expand("%:t")

	if not filename:match("%." .. extension .. "$") then
		vim.notify("Not a ." .. extension .. " file", vim.log.levels.ERROR)
		error("Not a ." .. extension .. " file", 0)
	end

	if not filepath:match("^" .. vim.pesc(ctx.dir .. "/")) then
		vim.notify("File not in " .. subdir .. "/ directory", vim.log.levels.ERROR)
		error("File not in " .. subdir .. "/ directory", 0)
	end

	return {
		git_root = ctx.git_root,
		dir = ctx.dir,
		filepath = filepath,
		filename = filename,
		basename = filename:gsub("%." .. extension .. "$", ""),
	}
end

function M.generate_hash()
	math.randomseed(os.time())
	local hash = ""
	for _ = 1, 6 do
		hash = hash .. string.format("%x", math.random(0, 15))
	end
	return hash
end

function M.fingerprint(str)
	local hash = 2166136261
	for i = 1, #str do
		hash = bit.bxor(hash, str:byte(i))
		hash = bit.band(hash * 16777619, 0xFFFFFFFF)
	end
	return string.format("%08x", hash)
end

return M
