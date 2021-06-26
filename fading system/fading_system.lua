-- TODO: document this
-- very WIP, under slow but heavy development, but quite usable
-- depends on
--    floor, max, min  (common_shortenings.lua)
--    clamp            (math_utils.lua)
--    pal              (drawing_utils.lua)
--    flip, wait       (loop_utils.lua)


-- one-liners (pick one)
	--[[ fade_in/fade_out                      001 ]] local _fdefinc,_fsteps,_fpc=0.05,6,1 local _flut={{ 1, 8, 0, 0, 0, 0}, { 2, 1, 8, 0, 0, 0}, { 3, 2, 1, 8, 0, 0}, { 4, 3, 2, 1, 8, 0}, { 5, 6, 7,15, 8, 0}, { 6, 7,15, 8, 0, 0}, { 7,15, 8, 0, 0, 0}, { 8, 0, 0, 0, 0, 0}, { 9, 8, 0, 0, 0, 0}, {10, 9, 8, 0, 0, 0}, {11,10, 9, 8, 0, 0}, {12,13,14,15, 8, 0}, {13,14,15, 8, 0, 0}, {14,15, 8, 0, 0, 0}, {15,15, 8, 0, 0, 0}, } local function screen_state() local t,pek={},peek4 for i=1,240*136 do t[i]=pek(i-1)end return t end local function _calc_fade() local p,s=clamp(_fpc,0,1),1/_fsteps local i=floor(p/s)+1 for n=1,15 do pal(n, _flut[n][i], true) end end local function prep_fade(dir) if     dir == "in"  then _fpc=1 elseif dir == "out" then _fpc=0 end end local function fade(dir, spd, scr_state) spd=spd or _fdefinc if     dir == "in"  then _fpc=max(0, _fpc-spd) elseif dir == "out" then _fpc=min(1, _fpc+spd) end _calc_fade() end local function check_fade(dir) if     dir == "in"  then  if _fpc>0 then fade(dir) end elseif dir == "out" then  if _fpc<1 then fade(dir) end end end local function fadeb(dir, spd, wait_in, wait_out, scr_state) spd,wait_in,wait_out=spd or _fdefinc,wait_in or 0,wait_out or 0 wait(wait_in) local pek,pok=peek4,poke4 if not scr_state then scr_state={} for i=1,240*136 do scr_state[i]=pek(i-1)end end if dir=="in" then _fpc=1 while _fpc>0 do _fpc=max(0,_fpc-spd) for i=1,240*136 do pok(i-1,scr_state[i])end _calc_fade() flip() end elseif dir=="out" then _fpc=0 while _fpc<1 do _fpc=min(1,_fpc+spd) if _fpc<1 then for i=1,240*136 do pok(i-1,scr_state[i]) end end _calc_fade() flip() end end wait(wait_out) end
	--[[ fade_in/fade_out (w/ auto-lut)        001 ]] local _fdefinc,_fsteps,_fpc=0.05,6,1 local _flut local _fpal={8,1,2,3,6,7,15,0,8,9,10,13,14,15,8} local function _gen_lut() _fsteps=0 local t,c,n={} for i=1,15 do t[i],c,n={i},i,1 repeat n=n+1 if n>_fsteps then _fsteps=n end c=_fpal[c] ins(t[i],c) until c==0 or n>16 if c~=0 then error("color "..i.." doesn't fade to 0")end end for i=1,15 do for s=1,_fsteps do if not t[i][s] then t[i][s]=0 end end end _flut=t end	if not _flut then _gen_lut() end local function screen_state() local t,pek={},peek4 for i=1,240*136 do t[i]=pek(i-1)end return t end local function _calc_fade() local p,s=clamp(_fpc,0,1),1/_fsteps local i=floor(p/s)+1 for n=1,15 do pal(n, _flut[n][i], true) end end local function prep_fade(dir) if     dir == "in"  then _fpc=1 elseif dir == "out" then _fpc=0 end end local function fade(dir, spd, scr_state) spd=spd or _fdefinc if     dir == "in"  then _fpc=max(0, _fpc-spd) elseif dir == "out" then _fpc=min(1, _fpc+spd) end _calc_fade() end local function check_fade(dir) if     dir == "in"  then  if _fpc>0 then fade(dir) end elseif dir == "out" then  if _fpc<1 then fade(dir) end end end local function fadeb(dir, spd, wait_in, wait_out, scr_state) spd,wait_in,wait_out=spd or _fdefinc,wait_in or 0,wait_out or 0 wait(wait_in) local pek,pok=peek4,poke4 if not scr_state then scr_state={} for i=1,240*136 do scr_state[i]=pek(i-1)end end if dir=="in" then _fpc=1 while _fpc>0 do _fpc=max(0,_fpc-spd) for i=1,240*136 do pok(i-1,scr_state[i])end _calc_fade() flip() end elseif dir=="out" then _fpc=0 while _fpc<1 do _fpc=min(1,_fpc+spd) if _fpc<1 then for i=1,240*136 do pok(i-1,scr_state[i]) end end _calc_fade() flip() end end wait(wait_out) end
------------

	--[[ fade_in/fade_out                      001 ]]
		-- functions
		--     screen_state()
		--     prep_fade(dir)
		--     fade(dir)
		--     fadeb(dir, speed, wait_in, wait_out, scr_state)
		--     check_fade(dir)
		local _fdefinc,_fsteps,_fpc=0.05,6,1
		local _flut={  -- lookup table (_fsteps must be the same as these fading steps)
			{ 1, 8, 0, 0, 0, 0}, -- color 1 - 6 fading steps
			{ 2, 1, 8, 0, 0, 0}, -- color 2
			{ 3, 2, 1, 8, 0, 0}, -- etc
			{ 4, 3, 2, 1, 8, 0},
			{ 5, 6, 7,15, 8, 0},
			{ 6, 7,15, 8, 0, 0},
			{ 7,15, 8, 0, 0, 0},
			{ 8, 0, 0, 0, 0, 0},
			{ 9, 8, 0, 0, 0, 0},
			{10, 9, 8, 0, 0, 0},
			{11,10, 9, 8, 0, 0},
			{12,13,14,15, 8, 0},
			{13,14,15, 8, 0, 0},
			{14,15, 8, 0, 0, 0},
			{15,15, 8, 0, 0, 0},
		}
		--[[ optional code
			If you want to have a lookup table automatically generated,
			turn _flut to nil and uncomment '_fpal' and '_gen_lut' (below).

			_gen_lut uses _fpal to calculate the lookup table.

			_fpal stores the color to which each color fades into, so
			the values {10, 5, 7, ...} mean color 1 fades to color 10,
			color 2 to 5, 3 to 7, etc.

			_fpal requires manually adjusting it to the palette you use
			but may be simpler than doing _flut by hand

		local _fpal={8,1,2,3,6,7,15,0,8,9,10,13,14,15,8}
		local function _gen_lut()
			_fsteps=0
			local t,c,n={}
			for i=1,15 do
				t[i],c,n={i},i,1
				repeat
					n=n+1
					if n>_fsteps then _fsteps=n end
					c=_fpal[c]
					ins(t[i],c)
				until c==0 or n>16
				if c~=0 then error("color "..i.." doesn't fade to 0")end
			end
			-- fill out zeros
			for i=1,15 do
				for s=1,_fsteps do
					if not t[i][s] then t[i][s]=0 end
				end
			end
			_flut=t
		end	if not _flut then _gen_lut() end  -- this line auto runs _gen_lut
		]]
		local function screen_state()
			local t,pek={},peek4
			for i=1,240*136 do t[i]=pek(i-1)end
			return t
		end
		local function _calc_fade()
			local p,s=clamp(_fpc,0,1),1/_fsteps
			local i=floor(p/s)+1
			for n=1,15 do
				pal(n, _flut[n][i], true)
			end
		end

		local function prep_fade(dir)
			if     dir == "in"  then _fpc=1
			elseif dir == "out" then _fpc=0
			end
		end
		local function fade(dir, spd, scr_state)
			spd=spd or _fdefinc
			if     dir == "in"  then _fpc=max(0, _fpc-spd)
			elseif dir == "out" then _fpc=min(1, _fpc+spd)
			end
			_calc_fade()
		end
		local function check_fade(dir)
			if     dir == "in"  then  if _fpc>0 then fade(dir) end
			elseif dir == "out" then  if _fpc<1 then fade(dir) end
			end
		end

		local function fadeb(dir, spd, wait_in, wait_out, scr_state)
			spd,wait_in,wait_out=spd or _fdefinc,wait_in or 0,wait_out or 0
			wait(wait_in)
			local pek,pok=peek4,poke4
			if not scr_state then
				scr_state={} -- keep 1-indexed for maxed performance
				for i=1,240*136 do scr_state[i]=pek(i-1)end
			end
			if dir=="in" then
				_fpc=1
				while _fpc>0 do
					-- print("fading in - ".. (1-_fpc)*100 .."%",0,0,0)
					_fpc=max(0,_fpc-spd)
					for i=1,240*136 do pok(i-1,scr_state[i])end
					-- print("fading in - ".. (1-_fpc)*100 .."%",0,0,12)
					_calc_fade()
					flip()
				end
			elseif dir=="out" then
				_fpc=0
				while _fpc<1 do
					-- print("fading out - ".. _fpc*100 .."%",0,0,0)
					_fpc=min(1,_fpc+spd)
					-- for some reason this check is needed...
					-- without it, the screen is reset during 'wait_out'
					if _fpc<1 then
						for i=1,240*136 do pok(i-1,scr_state[i]) end
					end
					-- print("fading out - ".. _fpc*100 .."%",0,0,12)
					_calc_fade()
					flip()
				end
			end
			wait(wait_out)
		end
