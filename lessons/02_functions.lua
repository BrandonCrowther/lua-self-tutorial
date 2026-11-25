--[[
LESSON 02: FUNCTIONS  (~45 min)

Functions are values in Lua. You can store them in variables and tables,
pass them around, and return them. Neovim keymaps, commands, and
autocommands all take closures as callbacks.
]]

-- Defining
local function add(a, b)
  return a + b
end
-- This is sugar for:  local add = function(a, b) return a + b end
-- (with one difference: the `local function` form can call itself
-- recursively.)

-- Missing arguments are nil. Extra arguments are silently dropped.
local function greet(name, greeting)
  greeting = greeting or "Hello" -- the default-argument idiom
  return greeting .. ", " .. name
end
print(greet("Lua"), greet("Lua", "Hi"), greet("Lua", "Hi", "ignored"))

-- Multiple return values
local function min_max(a, b)
  if a < b then
    return a, b
  end
  return b, a
end
local lo, hi = min_max(9, 3)
print(lo, hi) -- 3 9
-- If a call isn't the last item in a list, only its first value is kept:
print(min_max(9, 3), "end") -- 3 end
print("start", min_max(9, 3)) -- start 3 9
-- Wrap a call in parentheses to keep only the first value: (min_max(9, 3))

-- Many built-ins return several values, e.g. string.find returns
-- start, stop. Swapping variables is also easy: a, b = b, a

-- Varargs
local function sum(...)
  local total = 0
  for _, v in ipairs({ ... }) do
    total = total + v
  end -- pack into a table
  return total
end
print(sum(1, 2, 3, 4))
print(select("#", 1, nil, 3)) -- 3: counts the args, including nils
-- table.pack(...) gives a table with an .n field. table.unpack(t)
-- spreads a table back out into separate values:
print(math.max(table.unpack({ 5, 2, 8 }))) -- 8

-- Higher-order functions
local function apply_twice(f, x)
  return f(f(x))
end
print(apply_twice(function(x)
  return x * 3
end, 2)) -- 18

-- Closures: functions remember the variables around them
local function make_counter()
  local count = 0 -- each counter gets its own `count`
  return function()
    count = count + 1
    return count
  end
end
local c1, c2 = make_counter(), make_counter()
print(c1(), c1(), c1(), c2()) -- 1 2 3 1

-- Recursion
local function fact(n)
  if n <= 1 then
    return 1
  end
  return n * fact(n - 1)
end
print(fact(20))
-- Lua does proper tail calls: `return f(x)` doesn't grow the stack.
-- Deep non-tail recursion (100k+ levels) can overflow. For a deep DFS in
-- AoC, use an explicit stack instead.

-- Exercises

-- 1. Return the quotient and remainder of a // b (two return values).
local function divmod(a, b)
  return a // b, a % b
end

-- 2. map(t, f): return a new array with f applied to each element.
--    (Arrays are tables indexed 1..n. Lesson 03 covers them. For
--    now: `local out = {}`, `out[i] = ...`, `for i, v in ipairs(t)`.)
local function map(t, f)
  local arr = {}
  for i, v in ipairs(t) do
    arr[i] = f(v)
  end
  return arr
end

-- 3. filter(t, pred): return a new array with only the elements where
--    pred(v) is truthy. Hint: out[#out + 1] = v appends.
local function filter(t, pred)
  local out = {}
  for _, v in ipairs(t) do
    if pred(v) then
      out[#out + 1] = v
    end
  end
  return out
end

-- 4. reduce(t, f, init): fold left. reduce({1,2,3}, add, 0) == 6
local function reduce(t, f, init)
  for _, v in ipairs(t) do
    init = f(init, v)
  end
  return init
end

-- 5. make_adder(n) returns a function that adds n to its argument.
local function make_adder(n)
  local function inner(x)
    return n + x
  end
  return inner
end

-- 6. memoize(f): return a version of a 1-argument function that caches
--    results in a table. Many AoC part 2s are too slow without it. fib below calls
--    `fib` (the memoized one) recursively, so caching kicks in for every
--    subproblem.

local function memoize(f)
  local saved = {}
  local function out(n)
    if not saved[n] then
      saved[n] = f(n)
    end
    return saved[n]
  end

  return out
end

local fib
fib = memoize(function(n)
  if n < 2 then
    return n
  end
  return fib(n - 1) + fib(n - 2)
end)

-- 7. Varargs: return how many of the arguments are nil.
--    Hint: select("#", ...) and select(i, ...) or table.pack.
--    Arrays start at 1 wtf is wrong with this language
local function count_nils(...)
  local t = table.pack(...)
  local count = 0
  for i = 1, t.n do
    print(t[i])
    if t[i] == nil then
      count = count + 1
    end
  end

  return count
end

-- Tests
local check = require("lib.check")
print("\nLesson 02 tests:")
check.eq("divmod(17, 5)", function()
  return { divmod(17, 5) }
end, { 3, 2 })
check.eq("map", function()
  return map({ 1, 2, 3 }, function(x)
    return x * x
  end)
end, { 1, 4, 9 })
check.eq("filter", function()
  return filter({ 1, 2, 3, 4, 5, 6 }, function(x)
    return x % 2 == 0
  end)
end, { 2, 4, 6 })
check.eq("reduce sum", function()
  return reduce({ 1, 2, 3, 4 }, add, 0)
end, 10)
check.eq("reduce max", function()
  return reduce({ 3, 9, 2 }, math.max, -math.huge)
end, 9)
check.eq("make_adder", function()
  return make_adder(10)(5)
end, 15)
check.eq("memoized fib(90)", function()
  return fib(90)
end, 2880067194370816120)
check.eq("count_nils", function()
  return count_nils(1, nil, "x", nil, nil)
end, 3)
check.summary()
