--[[
LESSON 06: MODULES & BUILDING YOUR AoC TOOLKIT  (~45 min)

A module is a file that returns a table. `require("lib.aoc")` finds
lib/aoc.lua (dots become slashes, searched via package.path, relative to
your current directory), runs it once, and caches the result.

Pattern (in lib/aoc.lua):

    local M = {}
    function M.ints(s) ... end
    local function helper() ... end -- private: not in M
    return M

Usage:

    local aoc = require("lib.aoc")
    aoc.ints("1 2 3")

The task: build lib/aoc.lua yourself by moving your best solutions from
lessons 02-05 into it, plus the new functions below. This becomes the
library you use all of December. The tests here import it, so start by
creating the file with `local M = {} ... return M`.

Functions to include (the tests check every one):
  M.lines(path)        -> array of lines from a file
  M.read(path)         -> whole file, trailing whitespace stripped
  M.split(s, sep)      -> from lesson 04
  M.ints(s)            -> from lesson 04
  M.grid(text)         -> from lesson 04 (to_grid)
  M.memoize(f)         -> from lesson 02 (bonus: support multiple args by
                          building a key with table.concat({...}, ","))
  M.Queue              -> from lesson 05
  M.key(x, y)          -> "x,y"
  M.unkey(k)           -> x, y as numbers (two return values)
  M.DIRS4              -> { {-1,0}, {0,1}, {1,0}, {0,-1} }  (up right down left as {dr, dc})
  M.DIRS8              -> all 8 directions
  M.sum(t)  M.max(t)  M.min(t)
  M.gcd(a, b)  M.lcm(a, b)     (lcm shows up every year)
  M.dump(v)            -> pretty-print any value, including nested tables.
                          print() on a table only shows its address. Returns a string.
  M.bfs(start, neighbors, is_goal) -> distance or nil
      start:      any state (use string keys for states)
      neighbors:  function(state) returning an array of next states
      is_goal:    function(state) -> boolean
]]

local check = require("lib.check")
local ok, aoc = pcall(require, "lib.aoc")
if not ok then
  print("Create lib/aoc.lua first. It should start with `local M = {}` and end with `return M`.")
  print(tostring(aoc):match("^[^\n]*"))
  return
end

-- Write a little fixture file to test file reading
local fixture = "inputs/_lesson06.txt"
local f = assert(io.open(fixture, "w"))
f:write("10 20\n30 -40\n\n")
f:close()

print("\nLesson 06 tests:")
check.eq("lines", function() return aoc.lines(fixture) end, { "10 20", "30 -40", "" })
check.eq("read strips", function() return aoc.read(fixture) end, "10 20\n30 -40")
check.eq("split", function() return aoc.split("a, b", ", ") end, { "a", "b" })
check.eq("ints", function() return aoc.ints(aoc.read(fixture)) end, { 10, 20, 30, -40 })
check.eq("grid", function() return aoc.grid("#.\n.#")[2][2] end, "#")
check.eq("key/unkey", function() return { aoc.unkey(aoc.key(-3, 12)) } end, { -3, 12 })
check.eq("DIRS", function() return { #aoc.DIRS4, #aoc.DIRS8 } end, { 4, 8 })
check.eq("sum/max/min", function() return { aoc.sum({ 1, 2, 3 }), aoc.max({ 4, 9, 2 }), aoc.min({ 4, 9, 2 }) } end, { 6, 9, 2 })
check.eq("gcd/lcm", function() return { aoc.gcd(12, 18), aoc.lcm(4, 6) } end, { 6, 12 })
check.eq("memoize", function()
  local calls = 0
  local sq = aoc.memoize(function(x) calls = calls + 1; return x * x end)
  sq(4); sq(4); sq(5)
  return calls
end, 2)
check.eq("Queue", function()
  local q = aoc.Queue.new(); q:push("a"); q:push("b")
  return q:pop()
end, "a")
check.eq("dump nested", function() return type(aoc.dump({ a = { 1, 2 } })) end, "string")
check.eq("bfs grid path", function()
  local maze = aoc.grid("S..#\n.#..\n...E")
  local start, goal = aoc.key(1, 1), aoc.key(3, 4)
  return aoc.bfs(start, function(state)
    local r, c = aoc.unkey(state)
    local out = {}
    for _, d in ipairs(aoc.DIRS4) do
      local nr, nc = r + d[1], c + d[2]
      local cell = (maze[nr] or {})[nc]
      if cell and cell ~= "#" then out[#out + 1] = aoc.key(nr, nc) end
    end
    return out
  end, function(state) return state == goal end)
end, 5)
os.remove(fixture)
check.summary()
