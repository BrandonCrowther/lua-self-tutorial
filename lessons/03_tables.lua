--[[
LESSON 03: TABLES  (~60 min)

The table is Lua's only data structure. Arrays, dictionaries, sets,
objects, modules, queues, and grids are all tables.
]]

-- Arrays (sequences)
-- Arrays start at index 1, and t[0] is nil.
local fruits = { "apple", "banana", "cherry" }
print(fruits[1], fruits[3], fruits[4]) -- apple cherry nil (an index past the end reads as nil)
print(#fruits) -- 3

fruits[#fruits + 1] = "date" -- append (the idiomatic way)
table.insert(fruits, "elder") -- append
table.insert(fruits, 1, "apricot") -- insert at position 1 (shifts the rest: O(n))
local last = table.remove(fruits) -- pop from the end
local first = table.remove(fruits, 1)
print(first, last, table.concat(fruits, ", "))

-- ipairs: iterates 1, 2, 3... and stops at the first nil
for i, v in ipairs(fruits) do
  io.write(i, "=", v, " ")
end
print()
-- Numeric for over indices also works: for i = 1, #fruits do ... end

-- Don't put nil "holes" in arrays. #t is unreliable if t has
-- them. To delete from an array, use table.remove, not t[i] = nil.

-- Sorting (in place). The default sort uses <. Pass a comparator for more.
local nums = { 5, 2, 9, 1 }
table.sort(nums)
table.sort(nums, function(a, b)
  return a > b
end) -- descending
print(table.concat(nums, " "))

-- Dictionaries (hash maps)
local person = { name = "Ada", age = 36 } -- string keys
person.email = "ada@example.com" -- t.key is sugar for t["key"]
person["age"] = 37
person.age = nil -- setting nil DELETES the key
print(person.name, person.age)

-- Any value except nil can be a key: numbers, booleans, tables, functions.
local weird = { [1] = "one", [true] = "yes", ["with space"] = 1 }

-- pairs: iterates every key, in no guaranteed order.
for k, v in pairs(person) do
  print(k, v)
end
-- #t doesn't count dictionary keys. To count them, loop with pairs.

-- Tables are references
local a = { 1, 2, 3 }
local b = a -- same table, not a copy
b[1] = 99
print(a[1]) -- 99
print({ 1 } == { 1 }) -- false: == compares identity, not contents

-- Sets: keys with value true
local seen = {}
seen["x"] = true
if seen["x"] then
  print("seen x")
end

-- Nested tables & 2D grids (most AoC puzzles have one)
-- Option A: array of arrays, accessed as rows[r][c]
local rows = {
  { 1, 2, 3 },
  { 4, 5, 6 },
}
print(rows[2][3]) -- 6
-- Out of bounds: rows[5] is nil, so rows[5][1] is an error
-- ("attempt to index a nil value"). Guard with: (rows[r] or {})[c]

-- Option B: a flat table keyed by a coordinate string. Great for sparse or
-- infinite grids, and for "visited" sets.
local visited = {}
local function key(x, y)
  return x .. "," .. y
end
visited[key(3, -1)] = true
print(visited[key(3, -1)], visited["3,-1"])
-- Why not visited[{3,-1}]? Every {3,-1} is a different table, and keys compare by identity.

-- Option C: an integer key, y * WIDTH + x. Faster than strings if you need it.

-- Useful idioms
local counts = {}
for _, w in ipairs({ "a", "b", "a" }) do
  counts[w] = (counts[w] or 0) + 1 -- read with a default of 0, then add 1
end
print(next({}) == nil) -- next(t) == nil means "the table is empty"

-- Exercises

-- 1. Reverse an array, returning a new array.
local function reverse(t)
  local out = {}
  for i = #t, 1, -1 do
    out[#out + 1] = t[i]
  end
  return out
end

-- 2. Count the keys in any table (dict or array).
local function size(t)
  local count = 0
  for _ in pairs(t) do
    count = count + 1
  end
  return count
end

-- 3. Return a frequency table: { "a","b","a" } -> { a = 2, b = 1 }
local function tally(t)
  local table = {}
  for _, v in pairs(t) do
    if not table[v] then
      table[v] = 1
    else
      table[v] = table[v] + 1
    end
  end
  return table
end

-- 4. Return a sorted array of a dict's keys.
local function sorted_keys(t) end

-- 5. Deduplicate an array, keeping the first occurrence of each value
--    and the original order. Use a set.
local function uniq(t)
  -- TODO
end

-- 6. Shallow copy any table (both arrays and dicts).
local function copy(t)
  -- TODO
end

-- 7. Sort people by age ascending, breaking ties by name. Sort in place
--    and return the table.
local function sort_people(people)
  -- TODO
end

-- 8. Count the neighbors of grid[r][c] (all 8 directions) that equal "#".
--    Watch the edges: grid[0] is nil.
local function count_neighbors(grid, r, c)
  -- TODO
end

-- 9. Transpose a rectangular 2D array.
local function transpose(m)
  -- TODO
end

-- Tests
local check = require("lib.check")
print("\nLesson 03 tests:")
check.eq("reverse", function()
  return reverse({ 1, 2, 3 })
end, { 3, 2, 1 })
check.eq("size dict", function()
  return size({ a = 1, b = 2, 3 })
end, 3)
check.eq("tally", function()
  return tally({ "a", "b", "a" })
end, { a = 2, b = 1 })
check.eq("sorted_keys", function()
  return sorted_keys({ z = 1, a = 2, m = 3 })
end, { "a", "m", "z" })
check.eq("uniq", function()
  return uniq({ 3, 1, 3, 2, 1 })
end, { 3, 1, 2 })
check.eq("copy is new table", function()
  local o = { 1, x = 2 }
  local c = copy(o)
  c.x = 99
  return { o.x, c[1] }
end, { 2, 1 })
check.eq("sort_people", function()
  local p = sort_people({ { name = "Cy", age = 30 }, { name = "Al", age = 40 }, { name = "Bo", age = 30 } })
  return { p[1].name, p[2].name, p[3].name }
end, { "Bo", "Cy", "Al" })
local g = { { "#", ".", "#" }, { ".", "#", "." }, { "#", "#", "#" } }
check.eq("count_neighbors center", function()
  return count_neighbors(g, 2, 2)
end, 5)
check.eq("count_neighbors corner", function()
  return count_neighbors(g, 1, 1)
end, 1)
check.eq("transpose", function()
  return transpose({ { 1, 2, 3 }, { 4, 5, 6 } })
end, { { 1, 4 }, { 2, 5 }, { 3, 6 } })
check.summary()
