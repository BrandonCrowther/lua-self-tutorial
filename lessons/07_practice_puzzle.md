# Lesson 07: Practice puzzle, AoC style (~60 min)

Now do a full puzzle the way you will in December: create `days/day00.lua`,
read the input from a file, and use `lib/aoc.lua`.

Template to start from:

```lua
local aoc = require("lib.aoc")

local function part1(input)
end

local function part2(input)
end

local path = arg[1] or "inputs/day00.txt" -- `arg` holds command-line args
local input = aoc.read(path)
print("Part 1:", part1(input))
print("Part 2:", part2(input))
```

Run it with `lua days/day00.lua inputs/day00_sample.txt`.

---

## The Supply Depot

The elves' supply depot is a grid. `#` is a wall, `.` is floor, `S` is
where you start, and digits `1`-`9` are crates holding that many supplies.

Sample (already saved at `inputs/day00_sample.txt`):

```
###########
#S..#..3#4#
#.#.#.#.###
#.#...#...#
#5#.###.#.#
#...#..9#2#
###########
```

**Part 1:** Find the total supplies in all the crates you can reach from
`S` by walking up, down, left, and right. Crates don't block you.
For the sample, the answer is **19**: crates 5, 3, 9, and 2 are reachable,
but the 4 is walled off.

**Part 2:** For each reachable crate, find its shortest walking distance
from `S`. Sum `distance * supplies` over those crates. For the sample, the
answer is **203** (5 at distance 3, 3 at 10, 9 at 14, 2 at 16).

Then make your own bigger input and confirm it runs fast.

### What this exercises
- reading and parsing a grid
- string keys for visited sets
- BFS with your Queue (adapt `aoc.bfs` or write a version that returns
  every distance: `M.bfs_all(start, neighbors) -> {[state] = dist}`)
- the part1/part2 structure

When you're done, ask Claude to review your solution for idiomatic Lua.
