	--[[ pal - palette swapping (like pico8)   008 ]]
		-- mimics pico-8's 'pal'. See: https://pico-8.fandom.com/wiki/Pal
		-- for a simpler 'pal' function check out TIC-80's code snippets
		--    pal(c1,c2) - swaps c1 for c2 in the next drawing call (spr, map, etc)
		--    pal(c1,c2,true) - same as above, but in the screen memory
		--
		-- if 'p' is true (default false) then 'pal' changes the screen palette.
		--
		-- IMPORTANT: While using 'p=true', all that 'pal' does is caching
		-- changes to a screen palette, which is a simple and fast operation.
		-- To actually update the screen, you must call 'pal(true)' somewhere.
		-- If no changes were made to the screen palette, then 'pal(true)' will
		-- do nothing. But if changes were made, then 'pal(true)' will be a
		-- heavy task, as it does actual color substitution on the entire
		-- screen memory (every pixel). So you should use it wisely.
		-- Anything drawn after a 'pal(true)' call, will be unnafected.
		local _scr_pal={}
		local function pal(c1,c2,p)
			if c2 then
				if not p then
					poke4(0x3FF0*2+c1,c2)
				else
					_scr_pal[c1]=c2
					_scr_pal[16]=true -- use index 16 as 'dirty' flag
					-- TODO: can't I just empty the palette and use the array length as the flag?
				end
			elseif not c1 then
				local pok=poke4
				for i=0,15 do pok(0x3FF0*2+i,i)end
			elseif c1==true then
				if _scr_pal[16]then
					local pek,pok=peek4,poke4
					for i=0,136*240-1 do
						local c=pek(i)
						if _scr_pal[c]then
				    		pok(i,_scr_pal[c])
				    	end
					end
					_scr_pal[16]=false
				end
			end
		end

	--[[ clip / with_clip / nested clipping    005 ]]
		-- overrides 'clip' and uses a LIFO queue to
		--   allow nested clipping
		-- depends on unpk (common_shortenings.lua)
		--
		-- NOTE: this requires that you ALWAYS call 'clip()' to
		-- reset the clipping area. Forgettting it will cause
		-- problems. You can use 'with_clip' to be safer:
		--     with_clip(10,10,50,50, function()
		--         -- stuff
		--     end)

		local _clpq,clip,with_clip={
			clip=clip,lvls={},
			push=function(t,c)t.lvls[#t.lvls+1]=c end,
			peek=function(t)return t.lvls[#t.lvls]end,
			pop=function(t)
				local c=t.lvls[#t.lvls]
				t.lvls[#t.lvls]=nil
				return c
			end,
		}
		function clip(...)
			local c
			if ...~=nil then
				c={...}
				_clpq:push(c)
			else
				_clpq:pop()
				c=_clpq:peek()or{}
			end
			_clpq.clip(unpk(c))
		end
		function with_clip(x,y,w,h,f)
			clip(x,y,w,h)
			f()
			clip()
		end

	--[[ sprg - spr but grid based             008 ]]
		local function sprg(gs,i,x,y,ac,s,f,r,cw,ch)
			spr(i,x*gs,y*gs,ac or -1,s or 1,f or false,r or 0,cw or 1,ch or 1)
		end

	--[[ sprp - spr with palette swapping      005 ]]
		local function sprp(i,x,y,c,sc,ac,s,f,r,cw,ch)
			pal(sc,c)
			spr(i,x,y,ac or -1,s or 1,f or false,r or 0,cw or 1,ch or 1)
			pal()
		end

	--[[ circbo - circle border w/ outline     001 ]]
		-- Use whichever version is preferable. The second one
		-- can be tweaked to only do diagonals or sides, making
		-- a thinner outline.
		local function circbo(x,y,w,h,c,oc)
			for j=y-1,y+1 do
				for i=x-1,x+1 do
					circb(i,j,r,oc)
				end
			end
			circb(x,y,r,c)
		end
		local function circbo(x,y,r,c,oc)
			local cb=circb
			cb(x-1,y,  r,oc)
			cb(x+1,y,  r,oc)
			cb(x,  y-1,r,oc)
			cb(x,  y+1,r,oc)

			cb(x-1,y-1,r,oc)
			cb(x+1,y-1,r,oc)
			cb(x-1,y+1,r,oc)
			cb(x+1,y+1,r,oc)

			cb(x,y,r,c)
		end

	--[[ circo - circle w/ outline             001 ]]
		-- Use whichever version is preferable. The second one
		-- can be tweaked to only do diagonals or sides, making
		-- a thinner outline.
		local function circo(x,y,w,h,c,oc)
			for j=y-1,y+1 do
				for i=x-1,x+1 do
					circ(i,j,r,oc)
				end
			end
			circ(x,y,r,c)
		end
		local function circo(x,y,r,c,oc)
			local cf=circ
			cf(x-1,y,  r,oc)
			cf(x+1,y,  r,oc)
			cf(x,  y-1,r,oc)
			cf(x,  y+1,r,oc)

			cf(x-1,y-1,r,oc)
			cf(x+1,y-1,r,oc)
			cf(x-1,y+1,r,oc)
			cf(x+1,y+1,r,oc)

			cf(x,y,r,c)
		end

	--[[ rectbo - rect border w/ outline       001 ]]
		-- Use whichever version is preferable. The second one
		-- can be tweaked to only do diagonals or sides, making
		-- a thinner outline.
		local function rectbo(x,y,w,h,c,oc)
			for j=y-1,y+1 do
				for i=x-1,x+1 do
					rectb(i,j,w,h,oc)
				end
			end
			rectb(x,y,w,h,c)
		end
		local function rectbo(x,y,w,h,c,oc)
			local rb=rectb
			rb(x-1,y,  w,h,oc)
			rb(x+1,y,  w,h,oc)
			rb(x,  y-1,w,h,oc)
			rb(x,  y+1,w,h,oc)

			rb(x-1,y-1,w,h,oc)
			rb(x+1,y-1,w,h,oc)
			rb(x-1,y+1,w,h,oc)
			rb(x+1,y+1,w,h,oc)

			rb(x,y,w,h,c)
		end

	--[[ recto - rect w/ outline               001 ]]
		-- Use whichever version is preferable. The second one
		-- can be tweaked to only do diagonals or sides, making
		-- a thinner outline.
		local function recto(x,y,w,h,c,oc)
			for j=y-1,y+1 do
				for i=x-1,x+1 do
					rect(i,j,w,h,oc)
				end
			end
			rect(x,y,w,h,c)
		end
		local function recto(x,y,w,h,c,oc)
			local r=rect
			r(x-1,y,  w,h,oc)
			r(x+1,y,  w,h,oc)
			r(x,  y-1,w,h,oc)
			r(x,  y+1,w,h,oc)

			r(x-1,y-1,w,h,oc)
			r(x+1,y-1,w,h,oc)
			r(x-1,y+1,w,h,oc)
			r(x+1,y+1,w,h,oc)

			r(x,y,w,h,c)
		end
