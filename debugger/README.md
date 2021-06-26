# Debugger

---

## Usage

Tweak the default settings:
 - `dbg.key` - key to toggle the debugger on/off
 - `dbg.on` - flag to keep track of if the debugger is on or off
 - `dbg.fg`/`dbg.bg` - colors the debugger uses to draw text and background
 - `dbg.use_padding` - padding between lines
 - `dbg.fw` - text fixed width

Call `dbg:draw()` at the end of every frame, so it gets rendered over everything else.

```lua
function TIC()
	-- stuff

	dbg:draw()
end
```

And add a way to use the `dbg.key`:

```lua
function TIC()
	-- stuff

	if keyp(dbg.key) then
		dbg:toggle()
	end

	-- other stuff

	dbg:draw()
end
```

---
## Debugging

You can track/monitor values using `monitor(key,val,n)`:

```lua
function TIC()
	-- stuff

	monitor("hp:", player.hp)
	monitor("dt", fmt("%.3f", dt)) -- delta time
	monitor("fps", fmt("%d",1//dt))
end
```

The optional 3rd argument `n` is for aligning the values at 'n' amount of characters from the left.

---
## Benchmarking

You can do benchmarks by passing a function to `bm()` or `bma()`:

```lua
function func1()
	-- stuff
end

function func2()
	bma("func1's bm", func1)
end
```

Or you can wrap some code in a function:

```lua
function func()
bma("some bm", function() --start_bm

	-- stuff

end) --end_bm
end
```

A call to `bm()` or `bma()` will display the benchmark results in the same way `monitor()` does (they both use `monitor()` internally).

`bma()` differs from `bm()` in that `bma()` also calculates and displays an average of the benchmarking results. This is useful when the results fluctuate too much to be readable.

(The `--start_bm` and `--end_bm` comments are a personal convention of mine that you can ignore if you want. They make it easy for me to select and delete all benchmarks at once if I want. My choice to not indent benchmark lines that wrap code, is also a personal preference.)


