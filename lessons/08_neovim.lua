--[[
LESSON 08: LUA IN NEOVIM  (~45 min, side quest)

Run this file inside Neovim:  open it, then `:source %`
(Running it with plain `lua` will fail, because `vim` only exists inside
Neovim.)

Neovim's Lua is LuaJIT = Lua 5.1
What you learned today mostly carries over. The differences:
  - no `//` operator           -> math.floor(a / b)
  - no integers, only doubles  -> precision is lost past 2^53
  - `unpack`, not `table.unpack`
  - no `math.type`, no utf8 library, no 5.5 read-only loop variables
So: use `lua` (5.5) for AoC and LuaJIT only for editor config. lua_ls
picks the right version per project. This folder has a .luarc.json set to
5.5, and lazydev sets your nvim config to LuaJIT.

Poking around interactively
  :lua print("hi")
  :lua =vim.api.nvim_buf_line_count(0)     -- `=` prints the value, pretty
  :lua =vim.fn.expand("%:p")               -- call any Vimscript function
  :lua =vim.bo.filetype   vim.o / vim.wo / vim.bo / vim.g   (options & globals)
  :help lua-guide                          -- the official guide, worth reading
  vim.inspect(t)                           -- turns a table into a string, like your aoc.dump()

The building blocks of a config
  vim.keymap.set(mode, lhs, rhs_string_or_function, { desc = ... })
  vim.api.nvim_create_user_command(name, function(opts) ... end, { nargs = ... })
  vim.api.nvim_create_autocmd(event, { pattern = ..., callback = function(ev) ... end })
  vim.system({ cmd, args }, { text = true }, on_exit)   -- run shell commands asynchronously
  vim.notify(msg, vim.log.levels.INFO)

Each of these takes a closure (lesson 02) and a table of options
(lesson 03). Plugin specs in your lazy.nvim config are tables that a
module returns (lesson 06).

EXERCISES: write the TODOs, `:source %`, and try each one out. When you
like them, move this into ~/.config/nvim/lua/custom/aoc.lua and
require("custom.aoc") from init.lua. (<leader>r is already your replace
mapping, so these use the free <leader>a prefix, "a" for AoC.)
]]

local root = vim.fn.expand("~/dev/lua")

-- 1. <leader>ar: save, then run the current file with `lua` in a terminal
--    split at the bottom. Run it from `root` so require("lib.aoc") works.
--    Hints: vim.cmd("write"), vim.cmd("botright split | resize 15"),
--           vim.fn.jobstart({ "lua", file }, { term = true, cwd = root })
--           (in Neovim 0.11+, term = true runs the job in a terminal buffer)
vim.keymap.set("n", "<leader>ar", function()
  -- TODO
end, { desc = "[A]oC [R]un file" })

-- 2. <leader>as: like 1, but pass the sample input as an argument:
--    days/day07.lua -> inputs/day07_sample.txt
--    Hint: vim.fn.expand("%:t:r") gives "day07".
vim.keymap.set("n", "<leader>as", function()
  -- TODO
end, { desc = "[A]oC run on [S]ample" })

-- 3. :AoC 7 -> creates days/day07.lua from the lesson 07 template if it
--    doesn't exist yet, plus empty inputs/day07.txt and
--    inputs/day07_sample.txt, then opens the solution file.
--    Hints: opts.args is the argument string, string.format("%02d", n),
--    vim.fn.filereadable(path) == 1, vim.fn.writefile(lines_table, path),
--    vim.fn.mkdir(dir, "p"), vim.cmd.edit(path)
vim.api.nvim_create_user_command("AoC", function(opts)
  -- TODO
end, { nargs = 1, desc = "Scaffold an AoC day" })

-- 4. Autocommand: whenever you save a file in root/lessons/*.lua, run it
--    in the background and pop a notification saying "N passed, M failed"
--    (match it out of the output with a pattern from lesson 04).
--    Skip this file itself (it can't run outside Neovim).
--    Hints: event "BufWritePost", pattern = root .. "/lessons/*.lua",
--           ev.file is the path,
--           vim.system({ "lua", ev.file }, { cwd = root, text = true }, function(res) ... end)
--           res.stdout is the output. Wrap vim.notify in vim.schedule(function() ... end)
--           because the callback runs outside the main loop.
local group = vim.api.nvim_create_augroup("AoCLessons", { clear = true }) -- clear = true lets you :source again safely
vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  pattern = root .. "/lessons/*.lua",
  callback = function(ev)
    -- TODO
  end,
})

-- 5. Bonus: :AoCPaste copies the system clipboard into the current day's
--    sample file. Hint: vim.fn.getreg("+") and vim.split(s, "\n").

print("Lesson 08 loaded. Try <leader>ar, <leader>as, :AoC 1, and saving a lesson.")
