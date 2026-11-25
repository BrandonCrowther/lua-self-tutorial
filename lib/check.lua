-- Tiny test helper used by every lesson. Read it after lesson 05 (it uses
-- pcall and string.format, which you'll have learned by then).
local M = {}

local passed, failed = 0, 0

-- Color only when stdout is a terminal. `test -t 1` runs in a child shell
-- that inherits our stdout, so it checks the same output. Neovim's :! window
-- and pipes print the escape codes literally.
local use_color = os.getenv("NO_COLOR") == nil and os.execute("test -t 1") == true
local function paint(code, text)
  if not use_color then return text end
  return "\27[" .. code .. "m" .. text .. "\27[0m"
end

-- Deep equality so tables can be compared by contents.
local function deep_eq(a, b)
  if a == b then return true end
  if type(a) ~= "table" or type(b) ~= "table" then return false end
  for k, v in pairs(a) do
    if not deep_eq(v, b[k]) then return false end
  end
  for k in pairs(b) do
    if a[k] == nil then return false end
  end
  return true
end

local function show(v)
  if type(v) ~= "table" then return string.format("%q", v) end
  local parts = {}
  for k, x in pairs(v) do parts[#parts + 1] = tostring(k) .. "=" .. show(x) end
  table.sort(parts)
  return "{" .. table.concat(parts, ", ") .. "}"
end

-- check.eq("name", function() return actual end, expected)
function M.eq(name, fn, expected)
  local ok, actual = pcall(fn)
  if ok and deep_eq(actual, expected) then
    passed = passed + 1
    print("  " .. paint(32, "PASS") .. " " .. name)
  else
    failed = failed + 1
    print("  " .. paint(31, "FAIL") .. " " .. name)
    if ok then
      print("       expected: " .. show(expected))
      print("       got:      " .. show(actual))
    else
      print("       error:    " .. tostring(actual))
    end
  end
end

function M.summary()
  print(string.format("\n%d passed, %d failed", passed, failed))
  if failed == 0 then print("Lesson complete. On to the next one.") end
end

return M
