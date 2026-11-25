# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A one-day self-study course in Lua aimed at Advent of Code. The user is learning, so the lessons are exercises
for the user to solve. Don't fill in `TODO` functions or write `lib/aoc.lua` / `days/*.lua` solutions unless the
user asks you to. Hints, explanations, and reviews of their code (idiomatic-Lua feedback is requested explicitly
at the end of lesson 07) are the default kind of help.

## Commands

Run everything from the repo root, because `require("lib.check")` and `require("lib.aoc")` resolve through
`package.path` relative to the current directory:

    lua lessons/01_basics.lua                       # run one lesson's self-checking tests
    lua days/day00.lua inputs/day00_sample.txt      # run a solution against an input (arg[1] = input path)
    lua                                             # REPL

`lessons/08_neovim.lua` can't run under plain `lua`. It needs Neovim (`:source %`), because it uses the `vim` global.

Formatting uses StyLua (`.stylua.toml`: 2-space indent, 120 columns), but `stylua` isn't installed on this
machine. `.luarc.json` sets lua_ls to Lua 5.5 and declares `vim` as a global.

## Structure

- `lessons/NN_*.lua`: notes in a block comment at the top, `TODO` exercises, then tests at the bottom built
  from `check.eq(name, fn, expected)` calls and a closing `check.summary()`. Lesson 07 is a Markdown puzzle
  spec (the "Supply Depot" grid BFS; sample answers are 19 and 203).
- `lib/check.lua`: the shared test helper. It does deep table equality and wraps each test in `pcall`. It's
  marked "don't edit".
- `lib/aoc.lua`: doesn't exist yet. The user writes it in lesson 06, and lesson 06's tests define its API
  (`lines`, `read`, `split`, `ints`, `grid`, `memoize`, `Queue`, `key`/`unkey`, `DIRS4`/`DIRS8`,
  `sum`/`max`/`min`, `gcd`/`lcm`, `dump`, `bfs`). Lessons 07+ and `days/` depend on it.
- `days/dayNN.lua` solutions follow the part1/part2 template in lesson 07. Inputs go in
  `inputs/dayNN.txt` and `inputs/dayNN_sample.txt`.

## Lua version matters

Use `lua` (PUC Lua 5.5, 64-bit integers) for puzzles, not `luajit` or Neovim's Lua (5.1 semantics, doubles
only, no `//`, `unpack` instead of `table.unpack`). AoC answers often go past 2^53. Course conventions from the
README: string keys like `"x,y"` for coordinate sets, and a real Queue for BFS rather than `table.remove(t, 1)`.
