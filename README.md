# Lua in a day, for Advent of Code

A self-paced, one-day course for learning Lua before Advent of Code. It's
eight lessons of notes and exercises with self-checking tests, plus a
practice puzzle. Along the way you build a small toolkit of AoC helpers
(input parsing, grids, BFS, memoization). All you need is a Lua 5.5
interpreter. There are no other dependencies. Clone it, run the first
lesson, and fix code until the tests pass.

Work through the lessons in order. Each `.lua` lesson has notes at the
top, then exercises with self-checking tests at the bottom. Run each one
from this directory:

    lua lessons/01_basics.lua

Edit, rerun, and repeat until every test passes. Read the notes in the
editor and try things in the `lua` REPL as you go.

| #  | Lesson | Time | You'll learn |
|----|--------|------|--------------|
| 01 | `01_basics.lua` | 45m | locals, types, int vs float, `//` `%`, truthiness, loops, `goto continue` |
| 02 | `02_functions.lua` | 45m | multiple returns, varargs, closures, higher-order functions, memoize |
| 03 | `03_tables.lua` | 60m | arrays (1-indexed), dicts, sets, `pairs`/`ipairs`, sort, 2D grids |
| 04 | `04_strings.lua` | 60m | patterns (not regex), `match`/`gmatch`/`gsub`, split, reading files |
| 05 | `05_metatables_classes.lua` | 60m | `:` methods, metatables, the class pattern, operators, inheritance, `pcall` |
| 06 | `06_modules_toolkit.lua` | 45m | modules & `require`. You build `lib/aoc.lua`, your December toolkit |
| 07 | `07_practice_puzzle.md` | 60m | a full AoC-style puzzle, start to finish |
| 08 | `08_neovim.lua` | 45m | Neovim's Lua API: keymaps, user commands, autocommands for your AoC workflow |

About 7 hours plus breaks. Lessons 01 through 05 cover the language.
06 and 07 apply it to AoC-style problems. 08 is optional and covers
Neovim.

## Layout

    lib/check.lua   test helper (don't edit)
    lib/aoc.lua     your toolkit (you write it in lesson 06)
    days/           your solutions (dayNN.lua)
    inputs/         puzzle inputs (dayNN.txt, dayNN_sample.txt)

## Gotchas to remember

- Arrays start at **1**. `s:sub(i, i)`, not `s[i]`.
- Only `nil` and `false` are falsy. `0` and `""` are truthy.
- `~=` means not-equal. There's no `+=`, no `continue`, and no regex.
- Forget `local` and you've made a global.
- Use `lua` (5.5, 64-bit integers) for AoC, not `luajit`/Neovim (doubles).
- `{1} == {1}` is false. Use string keys like `"x,y"` for coordinate sets.
- `table.remove(t, 1)` is O(n). Use a real Queue for BFS.

## Reference

- *Programming in Lua* (1st ed., free online): https://www.lua.org/pil/contents.html
- Lua 5.5 reference manual: https://www.lua.org/manual/5.5/
- Patterns: https://www.lua.org/manual/5.5/manual.html#6.4.1
- In Neovim: `:help lua-guide`, `:help luaref`
