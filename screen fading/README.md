# Screen fading

I made an example cart for this fading system. You can play it [here]().

### Usage

The first step is to create a new fader object, and give it a table specifying how the colors are supposed to fade.

```lua
function init()
	my_fade = Fader.new( {0,8,1,2,3,6,7,15,0,8,9,10,13,14,15,8} )
end
```
```lua
--  0, 1  2  3  4  ...
   {0, 8, 1, 2, ...}
```

Each index in the table represents each of the 16 colors in TIC-80, and the number in each index is the color it should fade to. The table given above means color 0 fades to color 0, color 1 to 8, 2 to 1, 3 to 2, and so on. In other words, where color 1 exists, it will be replaced by color 8, color 2 by color 1, etc.

The color that represents black should be in its respective index. The configuration above is meant for the default palette, where black is color 0, so it's the 1st index of the table. (For the purposes of determining which index each color belongs to, you can think of that table as if the indexing was zero-based.)

If you're using another palette, or if you wish the fader to fade toward another color (untested), just make sure that color is in its index (e.g., if it's color 7, then put it in the 7th index), as the fader interprets the color that fades to itself as the black color.

When a fader is created, internally it creates a lookup table for fade-outs, and an inverted one for fade-ins.

Now you can use the fader.

```lua
function TIC()
	if game_state == "game_over" then
		if btn(4) then
			my_fade:fade_out(0.05, 60)
		end
	elseif game_state == "menu"
		-- (...)
	end

	my_fade:update()
	Fader.commit()

	draw_gui()  -- <-- not affected
end
```

The update function `my_fade:update()` updates the state of the fading while it's performing a fade. If the fader isn't currently fading, then it does nothing. 
(And `my_fade:fade_in()` and `my_fade:fade_out()` do nothing if the fader is already performing a fade.)

Make sure to call `Fader.commit()` at the end of the loop, after you've already drawn evrything that you want to be affected by the fading system. Anything that isn't supposed to be faded, draw it after that.

**Note:** `Fader.commit()` is a heavy operation: it switches colors on the entire screen itself. So it might be better to avoid calling it more than once per frame.

**`my_fade:fade_in(speed)`** takes one argument for the speed at which to perform the fade (default 0.05).

**`my_fade:fade_out(speed, hold)`** takes two arguments: the speed (same as above), and a `hold` number argument (default 0), which is the number of frames the fader should keep the screen black for, after the fading has finished. 


