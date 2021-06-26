## TICkle IMGUI

TICkle is an immediate mode GUI system. The goal is to make it small, simple to use, and flexible. Given TIC-80's code limits, making it (and keeping it) small is the primary goal.

I'm no expert UI crafter, though, so don't expect something expertly done. This is an experimental learning project I've been working on for some time in LÖVE and ported to TIC-80 out of the need for a small and minimalistic GUI.

TICkle is a framework, not a ready-made GUI out of the box. It doesn't come with any defined widgets, it just gives you building blocks to develop them however you like, and it's extendable. (TODO: some examples.)

Widgets are called 'items' in the framework (shorter and easier to type).

This is very WIP, so the code is still a bit messy and full of unnecessary comments that take a toll in the character limits of TIC-80, unless you're using v0.80+.

It ought to support keyboard/gamepad input, but the code for this is still very rough and untested.

### Usage

TICkle depends on a few of my utilities and shortenings:
 - mouse_states      (mouse/mouse_states.lua)
 - clip/with_clip	 (drawing_utils.lua)
 - unpk, setmt       (common_shortenings.lua)
 - fmt               (common_shortenings.lua) - this is only for the __tostring, which is for debugging only
 - dmerge            (table_utils.lua)

These functions must be called every frame:

 - **`ui.start_frame()`** - call before using the UI in any way, so that it can prepare things and gather user input.
 - **`ui.end_frame()`** - call when there's no more UI related stuff being done. All rendering is done in here.

If your game uses the mouse, and you want to avoid mouse input affecting your game when the mouse is over the UI, you can wrap your mouse handling code in a simple check:

```lua
if not ui.mouse_on_ui then
	-- game-related mouse handling in here
end
```

If you need to hide, lock or deactivate items, there are three switches you can use:
 - ui.visible  (default: true)
 - ui.locked   (default: false)
 - ui.active   (default: true)

When an item is created, the state of those three switches will determine its behavior. If `ui.visible==false` then the item won't even be created at all. If `ui.locked==true` or `ui.active==false`, then the item will not respond to any input. The intended difference between *locked* and *active* is just that *locked* means the item is temporarily frozen (e.g. when a modal popup takes over), while *not active* means the item is actually turned off (with faded colors or some other kind of visual feedback).

Here's a simple popup example:

```lua
local popup = false

ui.with_locked(popup, function()
	-- if popup is false, then ui is not locked and these items receive input
	Container("cont1", 10, 10, 50, 50, function(t)
		Button("btn1", 5, 5, "Open Popup", function(t)
			if t.released then popup = true end
		end)
	end)
end)

if popup then
	Container("popup1", 40, 40, 20, 20, function(t)
		Button("btn1", 5, 5, "Close Popup", function(t)
			if t.released then popup = false end
		end)
	end)
end
```

All functions that start with `with_` are inspired by Python's `with` keyword, and they handle starting and ending a process safely. In the code above, `with_locked` will lock or unlock the ui according to `popup`, execute the code for the `Container`, and then revert back to the previous locked state. So the items that exist outside of `with_locked` are unaffected.

These are the functions you can use to alter the state of the UI:

 - **`ui.show()`**
 - **`ui.hide()`**
 - **`ui.with_visible(b,f)`**
 - **`ui.enable()`**
 - **`ui.disable()`**
 - **`ui.with_active(b,f)`**
 - **`ui.lock()`**
 - **`ui.unlock()`**
 - **`ui.with_locked(b,f)`**



















---


### Rendering items

The visuals of items are not done by directly calling any of the rendering functions in TIC-80 (rect, spr, print, etc). TICkle defers all the rendering to the end of a frame, as this allows control over when exactly the UI should be rendered (and maybe it makes it a bit more performant, but don't quote me on that).

To achieve this, TICkle has equivalent functions that instead of drawing, they add a render step to a list that is iterated through at frame end. By deafult, these are the ones available:
 - ui.rect
 - ui.rectb
 - ui.print
 - ui.spr
 - ui.line
 - ui.clip

Note: TICkle uses my own custom `clip` function, which allows nesting clipping tasks, but requires that you ALWAYS call `clip` without arguments to terminate a clipping task. You can also use `ui.with_clip` to be safe.





---



### Defining items

A UI item is simply a function you can call. For example, a simple generic label can look like this:

```lua
function Label(id, x, y, text, color, options)
	return ui.with_item(id, x, y, 0, 0, options, function(t,...)
		ui.print(text, t.gx, t.gy, color)
	end)
end
```

`ui.with_item` wraps the item creation boilerplate. It handles the essentials of an item, does some checks, runs the item code, disposes of the item and returns it.

Note: you don't have to return the item. In some cases it can be useful to have a temporary reference to it, in other cases there's no point to it.

A button function that returns the item allows two ways to invoke the button:

```lua
Button("b1", 10, 10, "Click me!", function(t)
	if t.pressed then trace("1st button pressed") end
end)

local b = Button("b2", 10, 20, "Click me too!")
if b.pressed then trace("2nd button pressed") end
```

Those two items are mere buttons and have no child items, but keep in mind that for container types, you will more often need the first option (or a mix of both), so you can create items inside them. Items invoked within the code of other items become their children. For example, the Button below is a child of the Container.

```lua
Container("cont", 10, 10, 50, 50, function(t)
	Button("btn", 5, 5, "Click me!")
end)
```

---

#### Item Parameters

Every item takes at least an id and a position. Both the id and position are relative the parent. A width and height are optional, but if the item should receive any mouse input, then they should not be zero.

The global position of an item is accessible through the `gx` and `gy` fields of the item. This is usually what you'll want to use for rendering the item at its actual screen position, or for checking mouse input.

How you order the parameters is totally up to you, but the `options` parameter should probably always be the last one. This is because `options` can be a function, or a table containing certain options as well as that same function. For example, the button `"b1"` above could be defined like this:

```lua
-- note, the function is now in the "code" field of a table
Button("b1", 10, 10, "Click me!", { code=function(t)
	if t.pressed then trace("1st button pressed") end
end })
```

When you have no options to pass into the item, you can omit the table and pass in the function in its place. If you also don't have a function to pass into it, you can omit that parameter entirely (and pass `nil` to `ui.with_item` in its place). TICkle figures out internally what `options` is and organizes things accordingly.

During item creation, internally, the contents of `options` are transfered to the item itself, so they become easier to work with. So, for example, `options.code` becomes `item.code`. You can use the `options` parameter to carry any settings or flags specific to your item's implementation, but you should be careful to not use any fields that would override the item's properties (id, x, y, w, h, etc...).

There are three extra fields that are reserved, which are handled by the ui. Two of them can be passed in `options`:
 - `options.code` - (function) the function with the item's content/behavior
 - `options.tip`  - (string) the tooltip of the item (requires a tooltip addon)

The third reserved field is the arguments passed to the `code` function, which are stored in item.args (which will be nil, if no arguments were passed). They get automatically passed into that function's call inside `ui.with_item`, so as long as you're using `ui.with_item` you shouldn't need to care about this field. Just be aware that `options` should not carry an `args` field, to avoid potential issues.

---


#### Item ids

Ids are strings, and can be whatever you want, but must be unique. Items with the same id may not work properly, unless they're children of different parents, since ids are relative to the item's parent. In the example below, the two buttons called `"b1"` are children of the parents `"c1"` and `"c2"`, then TICkle will turn their ids into `"c1.b1"` and `"c2.b1"`.

```lua
Container("c1", 10, 10, 50, 50, function(t)
	Button("b1", 5, 5, "Click me!")
end)

Container("c2", 60, 10, 50, 50, function(t)
	Button("b1", 5, 5, "Click me!")   --  <-- this is fine!
end)
```

---

#### Cheking mouse input

There are two functions you can use for this:

- **`Item:check_hovered(gx, gy, w, h)`**
- **`Item:check_pressed()`**

`Item:check_hovered` takes a global position and a size, and checks whether the mouse is within that rectangle. This function will set the following boolean fields in the item:
 - item.hovered        - is the item currently under the mouse
 - item.mouse_entered  - has the mouse just entered the item's rect
 - item.mouse_exited   - has the mouse just exited the item's rect

It will also give the UI a reference to an item that has a item.tip field if it's being hovered. This reference (`ui.info_item`) can be used to show a tooltip on top of everything else.)

`Item:check_pressed` takes no arguments, and checks whether the mouse is interacting with the item. It will set the following boolean fields in the item:
 - item.pressed  - has the button just been pressed
 - item.released - has the button just been released
 - item.held     - is the button being held down

`Item:check_hovered` will functions will also handle tooltip timing and showing/hiding.


```lua
function SomeItem(id, x, y, w, h, index, options)
	return ui.with_item(id, x, y, w, w, options, function(t,...)
		-- check if the mouse is hovering this item
		t:check_hovered(t.gx, t.gy, w, h) -- you could also use t.w and t.h here

		-- check if the mouse is pressed on this item
		t:check_pressed()

		-- render this item
		ui.spr(index, t.gx, t.gy)

		-- execute the code sent to this item
		if t.code then t:code(...) end
	end)
end
```

From the item you can then call `item.code` to run it. The order of rendering and content depends on the item being implemented. You will probably want the background rendered before the content, though.



---























### Extending TICkle

Since Lua is very flexible, TICkle can be extended probably in more ways than those I can think of. But there are some ways I've already extended it myself:

1- addons: this is very experimental, and curently there's one addon for tooltips. Tooltips were added as an addon to keep the base UI smaller. An addon can define its own `start_frame` and `end_frame` functions, which are called by the UI, and can be added to the UI using `ui.add_addon` at startup.

2- Theme: even though there's only 16 colors in TIC-80, you could still define a `theme` table containing colors and styles for various types of items and states. The implementation of each item should decide what colors to use from there, depending on its state (and the ui state -- visible, locked, etc).

You can also define standalone styles to be used in special items. Styles can be passed into the `options` parameter of the item, and if an item receives a style, it will override the theme.

3- Rendering steps: the UI comes with functions for all basic drawing functions in TIC-80 (rect, spr, print, etc), but you can also add your own. You can check out tiny_imui_extensions.lua for some examples. To add a rendering step:

```lua
-- define the function that will actually draw something:
local function sprp(idx, x, y, c, sc, ac, s, f, r, cw, ch)
	-- spr with palette swapping
	pal(sc, c)
	spr(idx, x, y, ac or -1, s or 1, f or false, r or 0, cw or 1, ch or 1)
	pal()
end

-- define the function that adds that function to the list of render steps
-- this will become 'ui.sprp()' that you can call in your ui items
local function rs_sprp(...)
	ui.push_render_step("sprp", {...})
end

-- And then add both functions as a render step to the ui:
ui.add_render_step("sprp", rs_sprp,	sprp)
```

(The example above is already defined in tiny_imui_extensions.lua)
