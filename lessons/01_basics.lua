--[[
LESSON 01: BASICS  (~45 min)

Run:     lua lessons/01_basics.lua       (from ~/dev/lua)
Neovim:  :!lua %     or the <leader>ar keymap you build in lesson 08

Read the notes, then fill in each function marked TODO. The tests at the
bottom tell you when you've got it right. Try things in the REPL too: just
run `lua` with no arguments.
]]

-- Comments
-- A line comment.
--[[ A block
     comment. ]]

-- Variables: use `local`
-- A variable without `local` is global, visible to every file, so a typo
-- creates a new global and no error. lua_ls warns about stray globals.
local name = "Advent"
local year = 2026
local nothing = nil -- nil means "no value". Unset variables are nil.

-- Types
-- nil, boolean, number, string, table, function (plus userdata and thread,
-- which you can skip for now). type(x) returns the type as a string.
print(type(name), type(year), type(nothing), type(print))

-- Numbers: integers and floats
-- Lua 5.3+ has real 64-bit integers. That matters for AoC: answers often
-- go past 2^53, and LuaJIT (which Neovim uses) stores numbers as doubles
-- and loses precision there. Solve puzzles with `lua`, not `luajit`.
print(7 / 2) -- 3.5  `/` always returns a float
print(7 // 2) -- 3    floor division
print(-7 // 2) -- -4   floors toward -infinity, not toward zero
print(-7 % 3) -- 2    the result takes the sign of the divisor (handy for wrapping)
print(2 ^ 10) -- 1024.0  `^` always returns a float
print(math.maxinteger, math.huge, math.floor(3.7), math.abs(-4))
print(tonumber("42"), tonumber("abc"), tostring(42))

-- Strings
local s = "hello"
print(s .. " world") -- `..` concatenates (not +)
print(#s) -- `#` gives the length: 5
print(s:upper()) -- method-call syntax, covered in lesson 04
print([[raw
multi-line string]])
-- Strings are immutable. "abc" .. 1 works ("abc1"), but "10" + 1 is
-- discouraged. Convert explicitly with tonumber/tostring.

-- Truthiness: only nil and false are falsy
-- 0 and "" are both truthy, unlike in Python and JavaScript.
if 0 then
  print("0 is truthy")
end

-- Operators: == and ~= (not !=), and/or/not (not && || !)
print(1 ~= 2, not true, true and "yes" or "no")
-- `a and b or c` is Lua's ternary. Careful: if b is false or nil, you get c.

-- `or` for defaults: x = x or 10

-- Control flow
local num = 15
if num % 15 == 0 then
  print("fizzbuzz")
elseif num % 3 == 0 then -- `elseif` is one word
  print("fizz")
else
  print(num)
end

-- Numeric for: start, stop (inclusive), optional step
for i = 1, 3 do
  io.write(i, " ")
end -- 1 2 3
for i = 10, 1, -3 do
  io.write(i, " ")
end -- 10 7 4 1
print()
-- Lua 5.5: loop variables are read-only, in `for i = ...` and in
-- `for k, v in pairs(t)`. `i = i + 1` or `v = tonumber(v)` inside the loop
-- is an error. Copy it instead: `local n = tonumber(v)`. (Neovim's LuaJIT
-- allows the assignment, so this gotcha only bites you in plain `lua`.)

local count = 0
while count < 3 do
  count = count + 1
end -- Lua has no `+=` or `++`

repeat
  count = count - 1
until count == 0 -- like do-while

-- There's no `continue`. Use goto or invert the condition:
for i = 1, 5 do
  if i % 2 == 0 then
    goto continue
  end
  io.write(i, " ")
  ::continue::
end
print()
-- `break` works as you'd expect.

-- Exercises

-- 1. Return the sum of all integers from 1 to n that are multiples of 3 or 5.
local function sum_multiples(n)
  local sum = 0
  for i = 1, n do
    if i % 3 == 0 or i % 5 == 0 then
      sum = sum + i
    end
  end
  return sum
end

-- 2. Return "even" or "odd". Use the and/or idiom in one line.
local function parity(n)
  if n % 2 == 0 then
    return "even"
  end
  return "odd"
end

-- 3. Return whether `v` is
--    truthy in Lua. (One line. Think about what `not not v` does.)
local function is_truthy(v)
  return not not v
end

-- 4. Clock arithmetic: positions 0..99 on a dial. Starting at `pos`, turn
--    by `delta` (which may be negative or bigger than 100). Return the new
--    position. One line. Hint: with a positive divisor, Lua's % returns
--    a value from 0 to divisor - 1, even for negative input.
local function turn_dial(pos, delta)
  return (pos + delta) % 100
end

-- 5. Collatz: count the steps for n to reach 1. If n is even, n = n // 2,
--    otherwise n = 3n + 1. Use a while loop.
local function collatz_steps(n)
  local steps = 0
  while n > 1 do
    steps = steps + 1
    if n % 2 == 0 then
      n = n // 2
    else
      n = (3 * n) + 1
    end
  end
  return steps
end

-- 6. Return the number of digits in a non-negative integer.
--    Do it two ways (pick one to return): with a loop using // 10,
--    and with tostring and #.
local function digit_count(n)
  local str = tostring(n)
  return #str
end

-- Tests
local check = require("lib.check")
print("\nLesson 01 tests:")
check.eq("sum_multiples(9)", function()
  return sum_multiples(9)
end, 23)
check.eq("sum_multiples(999)", function()
  return sum_multiples(999)
end, 233168)
check.eq("parity(4)", function()
  return parity(4)
end, "even")
check.eq("parity(-3)", function()
  return parity(-3)
end, "odd")
check.eq("is_truthy(0)", function()
  return is_truthy(0)
end, true)
check.eq("is_truthy('')", function()
  return is_truthy("")
end, true)
check.eq("is_truthy(nil)", function()
  return is_truthy(nil)
end, false)
check.eq("is_truthy(false)", function()
  return is_truthy(false)
end, false)
check.eq("turn_dial(50, 60)", function()
  return turn_dial(50, 60)
end, 10)
check.eq("turn_dial(5, -10)", function()
  return turn_dial(5, -10)
end, 95)
check.eq("turn_dial(0, -1234)", function()
  return turn_dial(0, -1234)
end, 66)
check.eq("collatz_steps(1)", function()
  return collatz_steps(1)
end, 0)
check.eq("collatz_steps(27)", function()
  return collatz_steps(27)
end, 111)
check.eq("digit_count(0)", function()
  return digit_count(0)
end, 1)
check.eq("digit_count(12345)", function()
  return digit_count(12345)
end, 5)
check.summary()
