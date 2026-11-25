--[[
LESSON 04: STRINGS, PATTERNS & READING INPUT  (~60 min)

AoC is about 50% parsing. Lua has no regex. It has "patterns", which are
simpler and different. Learn them well.
]]

-- Method syntax
-- s:upper() is the same as string.upper(s). The colon passes the object
-- as the first argument (lesson 05 explains how).
local greeting = "Hello, World"
print(greeting:lower(), greeting:len(), greeting:rep(2, "|"), greeting:reverse())

-- Substrings & characters
print(greeting:sub(1, 5))  -- "Hello"  (1-based, end inclusive)
print(greeting:sub(-5))    -- "World"  (negative = count from the end)
print(greeting:sub(8, 8))  -- "W"      a single char
print(greeting:byte(1))    -- 72       char -> ASCII code
print(string.char(72)) -- "H"
-- s[i] doesn't work on strings. Use s:sub(i, i).
-- Iterate the chars:  for i = 1, #s do local ch = s:sub(i, i) end
-- Or:                  for ch in s:gmatch(".") do ... end

-- string.format (like printf)
print(string.format("%d items, %.2f avg, %s, %5s|, %-5s|, %x", 3, 2.5, "ok", "r", "l", 255))
print(("%03d"):format(7)) -- calling methods on a string literal needs parentheses

-- Patterns: the cheat sheet
--   .   any char         %a  letter      %d  digit       %s  whitespace
--   %w  alphanumeric     %p  punctuation %u/%l upper/lower
--   %A, %D, %S...  UPPERCASE = complement (%D = non-digit)
--   [abc]  char set   [^abc]  negated   [%w_]  classes inside sets
--   *  0+ greedy   +  1+ greedy   -  0+ lazy (not *?)   ?  optional
--   ^  anchor start   $  anchor end   ( )  capture
--   %  escapes special chars (backslash doesn't):  %.  %-  %(  %%  %[
--   %b()  balanced pair   %f[%w]  frontier (word boundary)
-- Not supported: alternation (a|b), {n,m} counts, quantifiers on groups.
-- A common trap: "-" is a quantifier. To match a literal minus, use "%-".

-- find: returns start, stop (plus any captures). Pass true as the 4th
-- argument for a plain-text search with no pattern magic.
print(("abc123def"):find("%d+"))     -- 4 6
print(("a.b"):find(".", 1, true))    -- 2 2

-- match: returns the captures (or the whole match if there are none)
print(("move 3 from 1 to 9"):match("move (%d+) from (%d+) to (%d+)")) -- "3" "1" "9" (strings, so call tonumber)
local key, val = ("color=blue"):match("(%w+)=(%w+)")
print(key, val)

-- gmatch: iterate over all the matches
for num in ("x=-3, y=14, z=7"):gmatch("%-?%d+") do io.write(tonumber(num), " ") end
print()

-- gsub: replace. Returns the new string and a count.
print(("a-b-c"):gsub("%-", "+"))          -- a+b+c 2
print(("hello"):gsub("l", { l = "L" }))   -- a table works as the replacement
print(("1 2 3"):gsub("%d", function(d) return d * 2 end))
print(("John Smith"):gsub("(%w+) (%w+)", "%2 %1"))

-- Splitting (no built-in split, so you write one in the exercises)
-- The common one-liner for "split on whitespace":
local words = {}
for w in ("  alpha beta   gamma "):gmatch("%S+") do words[#words + 1] = w end
print(#words, words[2])

-- Reading input files
-- Line by line (no trailing newlines):
--   for line in io.lines("inputs/day01.txt") do ... end
-- Whole file:
--   local f = assert(io.open("inputs/day01.txt", "r"))
--   local text = f:read("a")
--   f:close()
-- From stdin (lua solve.lua < input.txt):
--   for line in io.lines() do ... end     or     io.read("a")
-- Watch for a trailing "\n" when you read the whole file. Strip it with
-- text:gsub("%s+$", "") or match("^(.-)%s*$").
-- Splitting into blocks separated by blank lines: text = text .. "\n\n", then
-- for block in text:gmatch("(.-)\n\n") do ... end

-- Exercises

-- 1. split(s, sep): split on a literal separator (sep may be ","
--    or ", " or "."). Keep empty fields: split("a,,b", ",") -> {"a","","b"}.
--    Hint: loop with s:find(sep, pos, true).
local function split(s, sep)
  -- TODO
end

-- 2. Return every integer in a string (including negatives) as NUMBERS.
--    "x=-3, y=14 and 7" -> { -3, 14, 7 }. You'll use this every day of AoC.
local function ints(s)
  -- TODO
end

-- 3. Parse "Game 12: 3 blue, 4 red; 1 red, 2 green" into
--    { id = 12, max = { blue = 3, red = 4, green = 2 } }
--    (max = the highest count seen for each color).
local function parse_game(line)
  -- TODO
end

-- 4. Turn a multi-line string into a grid: grid[row][col] = char
local function to_grid(text)
  -- TODO
end

-- 5. Is the string a palindrome, ignoring case and non-letters?
local function is_palindrome(s)
  -- TODO
end

-- 6. Run-length encode: "aaabccdddd" -> "a3b1c2d4"
--    Hint: you can't do (.)%1* in Lua patterns, so loop over the chars.
local function rle(s)
  -- TODO
end

-- 7. Return the words that begin with a capital letter: "The cat met Bob"
--    -> { "The", "Bob" }
local function capitalized(s)
  -- TODO
end

-- Tests
local check = require("lib.check")
print("\nLesson 04 tests:")
check.eq("split ,", function() return split("a,b,c", ",") end, { "a", "b", "c" })
check.eq("split empty", function() return split("a,,b", ",") end, { "a", "", "b" })
check.eq("split ', '", function() return split("x, y, z", ", ") end, { "x", "y", "z" })
check.eq("split '.'", function() return split("1.2.3", ".") end, { "1", "2", "3" })
check.eq("ints", function() return ints("x=-3, y=14 and 7") end, { -3, 14, 7 })
check.eq("ints big", function() return ints("9007199254740993") end, { 9007199254740993 })
check.eq("parse_game", function() return parse_game("Game 12: 3 blue, 4 red; 1 red, 2 green") end,
  { id = 12, max = { blue = 3, red = 4, green = 2 } })
check.eq("to_grid", function() return to_grid("ab\ncd") end, { { "a", "b" }, { "c", "d" } })
check.eq("to_grid trailing nl", function() return #to_grid("ab\ncd\n") end, 2)
check.eq("palindrome", function() return is_palindrome("A man, a plan, a canal: Panama") end, true)
check.eq("not palindrome", function() return is_palindrome("Lua") end, false)
check.eq("rle", function() return rle("aaabccdddd") end, "a3b1c2d4")
check.eq("capitalized", function() return capitalized("The cat met Bob") end, { "The", "Bob" })
check.summary()
