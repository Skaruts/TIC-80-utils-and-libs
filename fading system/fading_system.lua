-- WIP
-- depends on
--    floor, max, min  (common_shortenings.lua)
--    clamp            (math_utils.lua)
--    pal              (drawing_utils.lua)


-- one-liner
	--[[ fade_in/fade_out                      002 ]] local _fpal={8,1,2,3,6,7,15,0,8,9,10,13,14,15,8} local _fdefinc,_fsteps,_fpc=0.05,6,1 local _flut=nil local function _gen_lut() _fsteps=0 local t,c,n={} for i=1,15 do t[i],c,n={i},i,1 repeat n=n+1 if n>_fsteps then _fsteps=n end c=_fpal[c] ins(t[i],c) until c==0 or n>16 if c~=0 then error("color "..i.." never fades to 0")end end for i=1,15 do for s=1,_fsteps do if not t[i][s] then t[i][s]=0 end end end _flut=t end	if not _flut then _gen_lut() end local function _calc_fade() local p,s=clamp(_fpc,0,1),1/_fsteps local i=floor(p/s)+1 for n=1,15 do pal(n, _flut[n][i], true) end end local function fade_do(spd, fade_in) spd=spd or _fdefinc _fpc = fade_in and max(0, _fpc-spd) or min(1, _fpc+spd) _calc_fade() end local function _do_fade_in(spd) spd=spd or _fdefinc _fpc=max(0, _fpc-spd) _calc_fade() end local function _do_fade_out(spd) spd=spd or _fdefinc _fpc=min(1, _fpc+spd) _calc_fade() end local function fade_prep(fade_in) _fpc = fade_in and 1 or 0 end local function fade_in_prep()  _fpc = 1 end local function fade_out_prep() _fpc = 0 end local function fade_in(spd) if _fpc>0 then _do_fade_in(spd) end end local function fade_out(spd) if _fpc<1 then _do_fade_out(spd) end end local function fade(spd, fade_in) if fade_in then fade_in(spd) else            fade_out(spd) end end local function fade_commit() pal(true) end


-- non-one-liner
	--[[ fade_in/fade_out                      003 ]]
		-- functions
		--     fade_prep(dir)
		--     fade_do(dir)
		--     fade_try(dir)
		-- '_fpal' stores the color to which each color fades into, so
		-- the values {10, 5, 7, ...} mean color 1 fades to color 10,
		-- color 2 to 5, 3 to 7, etc.
		-- Configure it according to your palette.
		-- Starts at 1. Color 0 is assumed to be black and is not included in this table
		local _fpal={8,1,2,3,6,7,15,0,8,9,10,13,14,15,8}

		-- default_fade_increment, fade_steps, fade_percent
		local _fdefinc,_fsteps,_fpc=0.05,6,1
		local _flut=nil -- color fading lookup table

		-- '_gen_lut' uses '_fpal' to calculate the lookup table.
		-- this function runs automatically at start
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
				if c~=0 then error("color "..i.." never fades to 0")end
			end
			-- fill out remaining space with zeros
			for i=1,15 do
				for s=1,_fsteps do
					if not t[i][s] then t[i][s]=0 end
				end
			end
			_flut=t
		end	if not _flut then _gen_lut() end  -- this line auto runs _gen_lut

		local function _calc_fade()
			local p,s=clamp(_fpc,0,1),1/_fsteps
			local i=floor(p/s)+1
			for n=1,15 do
				pal(n, _flut[n][i], true)
			end
		end

		-- fades the screen by 'spd' speed
		local function fade_do(spd, fade_in)
			spd=spd or _fdefinc
			_fpc = fade_in and max(0, _fpc-spd) or min(1, _fpc+spd)
			_calc_fade()
		end
		local function _do_fade_in(spd)
			spd=spd or _fdefinc
			_fpc=max(0, _fpc-spd)
			_calc_fade()
		end
		local function _do_fade_out(spd)
			spd=spd or _fdefinc
			_fpc=min(1, _fpc+spd)
			_calc_fade()
		end

		-- does the preparations for subsequent fading requests
		local function fade_prep(fade_in) _fpc = fade_in and 1 or 0 end
		local function fade_in_prep()  _fpc = 1 end
 		local function fade_out_prep() _fpc = 0 end

		-- checks if screen has been fully faded, if not, fades it more
		-- you can call this function every frame, if the fading is done
		-- it will simply do nothing, until you call 'fade_prep' again

		local function fade_in(spd)
			if _fpc>0 then _do_fade_in(spd) end
		end
		local function fade_out(spd)
			if _fpc<1 then _do_fade_out(spd) end
		end
		local function fade(spd, fade_in)
			if fade_in then fade_in(spd)
			else            fade_out(spd)
			end
		end
		-- Commits the palette changes to the screen.
		-- Call after drawing evertything that you want to be
		-- affected by the fading.
		local function fade_commit()
			pal(true)
		end





















