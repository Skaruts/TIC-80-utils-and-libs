## TIC-80 libs and utils

Some small utilities and libraries I've built over time from code I use frequently. I needed an way to have them at hand and easily drop them into my projects, and this is the best I could came up with.

I keep these utilities separate so I can pick and use only whatever I need. They're also indented under a small header to allow me to fold the code, and the header itself is indented so I can drop it all into a section of code between comment lines that I can also fold away entirely. That way my utilities are out of the way as I work on my games.

There's a version number on each utility's header that helps me see when a project of mine has an outdated version. It's just a simple iteration number.

Some utilities dependend on each other, or some shortenings, etc, and I try to keep their dependencies listed in place. They all rely also on local functions and variables, so they should be included at the top of a script and their dependencies should go above them.

I also like to drop them in my projects as one-liners that mostly stay out of the way, but I can't keep them stored like that, or else maintenance becomes painful. One-liners are easy to do in Sublime Text with `Ctrl+J` (remove intermingled comments first!). I don't know if this can be done in other editors. In larger utilities, like the fading system, I try to include one-liners for convenience.

Getting errors on one-liners isn't fun, though, so beware.

Keep in mind you can remove stuff you don't need from utilities that bring a lot of baggage, like the vector, the rectangle, etc. You can also remove unneeded comments. In TIC-80 0.70 everything takes a toll on the character limits, and in 0.80 no one seems to really know how that works, so it may be worth taking a minute to strip away excess stuff.

### Some libraries/utils I personally recommend checking out
 - debugger.lua - helps debugging, by tracking variables and doing function benchmarks
 - mouse_states.lua - helps handling mouse input
 - drawing_utils.lua - has a pico8-like 'pal', among other things
 - math_utils.lua - a few useful math related functions
 - table_utils.lua - some useful table handling functions
 - fading_system.lua - (WIP) if you need to do screen fade in/fade out (not documented yet)
 - TICkle - (WIP) an IMGUI I'm making for TIC-80.


