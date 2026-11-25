--[[
LESSON 05: METATABLES & CLASSES  (~60 min)

Lua has no `class` keyword. You build classes out of tables plus
METATABLES, which let one table control how another behaves (what
happens on a missing key, on +, on ==, on tostring...).
]]

-- The colon: methods and `self`
local acct = { balance = 100 }
function acct.deposit(self, amt) self.balance = self.balance + amt end
acct.deposit(acct, 50) -- explicit self
-- Colon sugar does the same thing, both when defining and when calling:
function acct:withdraw(amt) self.balance = self.balance - amt end
acct:withdraw(30) -- same as acct.withdraw(acct, 30)
print(acct.balance) -- 120
-- A common bug: calling acct.withdraw(30) with a dot, which makes self = 30.

-- Metatables & __index
-- When t[k] is nil, Lua checks getmetatable(t).__index. If that's a table,
-- Lua looks the key up there instead. This is how inheritance works.
local defaults = { color = "red", size = 1 }
local obj = setmetatable({ size = 5 }, { __index = defaults })
print(obj.size, obj.color) -- 5 red  (color came from defaults)

-- __index can also be a function (k is the missing key):
local auto_zero = setmetatable({}, { __index = function(t, k) return 0 end })
auto_zero.x = auto_zero.x + 1 -- no `or 0` needed, like Python's defaultdict
print(auto_zero.x, auto_zero.anything)

-- The class pattern (every class in this course uses it)
local Point = {}
Point.__index = Point -- instances look up missing keys (methods) in Point

function Point.new(x, y)
  local self = setmetatable({}, Point)
  self.x, self.y = x, y
  return self
end

function Point:dist(other) -- a method
  return math.abs(self.x - other.x) + math.abs(self.y - other.y)
end

-- Operator overloading with metamethods
function Point.__add(a, b) return Point.new(a.x + b.x, a.y + b.y) end
function Point.__eq(a, b) return a.x == b.x and a.y == b.y end
function Point:__tostring() return "(" .. self.x .. ", " .. self.y .. ")" end

local p = Point.new(1, 2) + Point.new(3, 4)
print(tostring(p), p:dist(Point.new(0, 0)), p == Point.new(4, 6))
-- Other metamethods: __sub __mul __div __mod __unm __lt __le __len
--   __concat __call (makes a table callable) __newindex (intercepts
--   writes) __close
-- __eq doesn't change how tables work as keys. visited[p] still uses identity,
-- so keep using string keys for coordinate sets.

-- Inheritance
local Animal = {}
Animal.__index = Animal
function Animal.new(name, sound)
  return setmetatable({ name = name, sound = sound }, Animal)
end
function Animal:speak() return self.name .. " says " .. self.sound end

local Dog = setmetatable({}, { __index = Animal }) -- Dog falls back to Animal
Dog.__index = Dog
function Dog.new(name)
  local self = Animal.new(name, "woof")
  return setmetatable(self, Dog) -- re-tag the instance as a Dog
end
function Dog:fetch() return self.name .. " fetches!" end

local d = Dog.new("Rex")
print(d:speak(), d:fetch()) -- speak lookup: d -> Dog -> Animal
-- Lua code rarely goes deeper than this. Prefer composition.

-- Error handling: error / pcall / assert
local function risky(n)
  if n < 0 then error("negative input: " .. n) end
  return math.sqrt(n)
end
local ok, result = pcall(risky, -1) -- like try/catch
print(ok, result)
local f = assert(io.open("lib/check.lua")) -- assert(v, msg) raises if v is falsy
f:close()
-- Idiom: functions that can fail return nil, errmsg (io.open does this).

-- Exercises

-- 1. A Stack class: Stack.new(), :push(v), :pop(), :peek(), :empty(),
--    and __len so #stack works.
local Stack = {}
-- TODO

-- 2. A Queue class with O(1) push and pop. (table.remove(t, 1) is O(n),
--    which is too slow for a big BFS.) Hint: keep `first` and `last`
--    indices and nil out slots as you pop.
--    Queue.new(), :push(v), :pop(), :empty()
local Queue = {}
-- TODO

-- 3. A Vec class: Vec.new(x, y) with __add, __sub, __eq, __tostring
--    ("<x,y>"), __mul (Vec * number scales it), and :key() returning
--    "x,y" for use as a set key.
local Vec = {}
-- TODO

-- 4. A Counter class: Counter.new(), :add(item), :get(item) (0 if
--    unseen), :most_common() returning item, count. Store the counts in
--    an inner table so they can't collide with method names.
local Counter = {}
-- TODO

-- 5. Make a `defaultdict(fn)` function: it returns a table where reading a
--    missing key calls fn(), stores the result, and returns it.
--    defaultdict(function() return {} end)["a"][1] = "x" should work.
local function defaultdict(fn)
  -- TODO
end

-- Tests
local check = require("lib.check")
print("\nLesson 05 tests:")
check.eq("Stack", function()
  local s = Stack.new()
  s:push(1); s:push(2); s:push(3)
  local top = s:pop()
  return { top, s:peek(), #s, s:empty() }
end, { 3, 2, 2, false })
check.eq("Queue FIFO", function()
  local q = Queue.new()
  for i = 1, 5 do q:push(i) end
  local out = {}
  while not q:empty() do out[#out + 1] = q:pop() end
  return out
end, { 1, 2, 3, 4, 5 })
check.eq("Queue speed (100k)", function()
  local q = Queue.new()
  for i = 1, 100000 do q:push(i) end
  local sum = 0
  while not q:empty() do sum = sum + q:pop() end
  return sum
end, 5000050000)
check.eq("Vec math", function()
  local v = (Vec.new(1, 2) + Vec.new(3, 4)) * 2 - Vec.new(1, 1)
  return { v.x, v.y, tostring(v), v:key(), v == Vec.new(7, 11) }
end, { 7, 11, "<7,11>", "7,11", true })
check.eq("Counter", function()
  local c = Counter.new()
  for ch in ("mississippi"):gmatch(".") do c:add(ch) end
  local item, n = c:most_common()
  return { c:get("s"), c:get("z"), n, item == "i" or item == "s" }
end, { 4, 0, 4, true })
check.eq("defaultdict", function()
  local dd = defaultdict(function() return {} end)
  table.insert(dd.a, "x")
  table.insert(dd.a, "y")
  return { #dd.a, rawget(dd, "b") }
end, { 2, nil })
check.summary()
