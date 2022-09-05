# Screen fading system

There are two modes for this fading system:
- the normal mode, where you control everything, and is easier to understand.
- the blocking mode, which controls your loop so it can halt it while fading (this requires the addon in blocking_fade.lua)

Use whichever you like. A word of warning though, the blocking mode is a bit hacky and more complicated, and you can probably achieve the same effect with the regular mode, anyway. It also uses [`flip()`](https://github.com/Skaruts/TIC-80-utils-and-libs/blob/main/loop_utils.lua), which is a function I made that mimicks [Pico-8's flip() function](https://pico-8.fandom.com/wiki/Flip) using coroutines, and which I couldn't make 100% reliable (as explained below in [#Blocking mode](#blocking-mode)).

## Examples
I've used this fading system in a [WIP roguelike](https://github.com/Skaruts/Pigventure-or-something). There I used both modes.

## Normal mode

The first thing you should do is configure the `_fpal` table in the fading system code according to the palette you're using. '_fpal' stores the colors to which each color fades into.
```lua
--       1   2  3  ...
_fpal = {10, 5, 7, ...}
```
The above one means color 1 fades to color 10, color 2 to 5, 3 to 7, and so on. In other words, where color 1 exists, it will be replaced by color 10, color 2 by color 5, etc.

`_fpal` requires 15 elements (not 16). Color 0 is assumed to be the black color, and is not included in `_fpal`.

This code was writen in TIC 0.70, so the default values in `_fpal` were set for the old palette, and since I still prefer it, I never changed it. If you use that palette, you may not have to change anything either.

Once you configured `_fpal`, you should call `fade_in_prep()`, `fade_out_prep()` or `fade_prep()` before doing any actual screen fading. Those functions reset the system, so it can be used, and you should call the appropriate one only once before every screen fade.

Then call the screen fading functions you need. The example below fades-in the screen.

```lua
function switch_game_state(st)
	if st == "menu" then
		fade_in_prep()
		game_state = "menu"
	elseif st == "game" then
		-- (...)
	end
end

function TIC()
	if game_state == "menu" then
		fade_in()
		-- do other menu stuff

		draw_menu()
	else
		-- (...)
	end

	fade_commit()

	draw_gui()
end
```
Make sure to call `fade_commit()` at the end of the loop, after you've already drawn evrything that you want to be affected by the fading system. Anything that isn't supposed to be faded, draw it after that.

`fade_in()`, `fade_out()` and `fade()` can be called every frame. They'll perform a fading step each frame until the fading has finished. After that they'll simply do nothing until you call the appropriate `*_prep()` function again. 

The only functions that take arguments are:
- **`fade_prep(fade_in: boolean)`** - prepare for a fade in/out
- **`fade(fade_in: boolean)`** - perform a fade in/out step

The parameter `fade_in` is false by default, so they prepare and perform fade-outs by default.


## Blocking mode
You'll need to include the addon in [blocking_fade.lua](https://github.com/Skaruts/TIC-80-utils-and-libs/blob/main/fading%20system/blocking_fade.lua) in your code, as well as its dependencies from [loop_utils.lua](https://github.com/Skaruts/TIC-80-utils-and-libs/blob/main/loop_utils.lua)
- `flip()`
- `wait()`

You still need to call `fade_in_prep()`, `fade_out_prep()` or `fade_prep()` before using this.

Then whenever you want to perform a blocking fade, you simply call `fadeb(dir)`, where `dir` is a string with the fading direction: `"in"` or `"out"`.

The only thing you really have to do differently is, instead of calling `fade_commit()` as before, you need to call `pal(true)` from within the `TIC()` function inside the `flip` code.

`flip` requires you to allow it to take over the TIC loop function (read its instructions for more info on this), and it includes the actual `TIC()` function in it. You have to put `pal(true)` after everything in it.

```lua
--[[ flip - mimics pico-8 flip             002 ]]
	-- (...)
	function TIC()
		_doloop()
		pal(true)
	end
	-- (...)
```

This is because there's a bug somewhere I've never been able to fix. If you call `fade_commit()` in your own loop function, the fadings won't work properly.



