## TIC-80 Mouse State Handling

This is quite straightforward to use. First make sure you call `update_mst()` before you do any input handling, so the mouse states get updated:

```lua
function TIC()
	update_mst()

	-- other stuff
end
```
Then you can use `mbtn()` or `mbtnp()`, etc, just as you would use `btnp()` or `keyp()`, except they don't support repeating input.


### Reference:

 - **`M1|M2|M3`** - constants for left|right|middle buttons (values 1|2|3)
 - **`mx|my`** - mouse position
 - **`m1|m2|m3`** - button states (boolean)
 - **`mwx|mwy (v0.80+)`** - mouse wheel scroll states

 - **`lmx|lmy`** - mouse position last frame
 - **`rmx|rmy`** - mouse position relative to last position

 - **`update_mst()`** - call this function before input handling to update mouse states

 - **`mbtn( [M1|M2|M3] )`** - test if a mouse button is currently pressed. Calling without arguments tests if *any* mouse button is currently pressed.
 - **`mbtnp( [M1|M2|M3] )`** - test if a mouse button was just pressed. Calling without arguments tests if *any* mouse button was just pressed.
 - **`mbtnr( [M1|M2|M3] )`** - test if a mouse button was just released. Calling without arguments tests if *any* mouse button was just released.
 - **`mbtnt( [M1|M2|M3] )`** - see how many frames a mouse button has been held down for. Calling without arguments returns the held time in frames for all 3 buttons (3 return values).
 - **`mmoved()`** - check if mouse moved since last frame.

