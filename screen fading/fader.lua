-- depends on
--    floor, min  (common_shortenings.lua)
--    pal         (drawing_utils.lua)


-- one-liner
	--[[ fade_in/fade_out                      004 ]] local _defspd = 0.05 local Fader = {} Fader.__index = Fader function Fader.new(fpal) local lut, ilut, steps = Fader._gen_lut(fpal) return setmt({dir = 0, fading = false, hold = 0, steps = steps, lut = lut, ilut = ilut, percent = 0, }, Fader) end function Fader.commit() pal(true) end function Fader._gen_lut(fpal) local steps = 0 local lut, ilut, black, c, n = {}, {} for i=1, 16 do if fpal[i] == i-1 then black = i-1 break end end if not black then error("fader: no black color found") end for i = 0, 15 do lut[i], c, n = {}, i, 0 repeat n = n + 1 if n > steps then steps = n end c = fpal[c+1] ins(lut[i], c) until c == black or n > 16 if c ~= black then error("fader: color " .. i .. " never fades to " .. black) end end for i = 0, 15 do ilut[i] = {} for s = 1, steps do if not lut[i][s] then lut[i][s] = black end ilut[i][(steps-s)+1] = lut[i][s] end end return lut, ilut, steps end function Fader._calc_fade(lut, p, steps) local s=1/steps local n=floor(p/s) for i=0,15 do pal(i, lut[i][n], true) end end function Fader._reset(t, dir, spd, hold) t.percent, t.fading = 0, true t.dir, t.spd = dir, (spd or _defspd) if hold and dir > 0 then t.hold = hold end end function Fader.fade_in(t, spd) if t.fading then return end t:_reset(-1, spd) end function Fader.fade_out(t, spd, hold) if t.fading then return end t:_reset(1, spd, hold) end function Fader.update(t) if not t.fading then return end t.percent = min(1, t.percent+t.spd) Fader._calc_fade(t.dir == 1 and t.lut or t.ilut, t.percent, t.steps) if t.percent >= 1 then if t.hold > 0 then t.hold = t.hold-1 return end t.fading = false end end


-- non one-liner
	--[[ fade_in/fade_out                      004 ]]
		-- functions:
		--     Fader.new(fpal)
		--     Fader.commit()
		--     instance.fade_in(speed)
		--     instance.fade_out(speed, hold)
		--     instance.update()
		local _defspd = 0.05 -- default fade speed
		local Fader = {}
		Fader.__index = Fader
		function Fader.new(fpal)
			local lut, ilut, steps = Fader._gen_lut(fpal)
			return setmt({
				dir = 0,
				fading = false,
				hold = 0,
				steps = steps,
				lut = lut,
				ilut = ilut,
				percent = 0,
			}, Fader)
		end
		function Fader.commit()
			pal(true)
		end
		function Fader._gen_lut(fpal)
			local steps = 0
			local lut, ilut, black, c, n = {}, {}
			for i=1, 16 do
				if fpal[i] == i-1 then
					black = i-1
					break
				end
			end
			if not black then error("fader: no black color found") end
			for i = 0, 15 do
				lut[i], c, n = {}, i, 0
				repeat
					n = n + 1
					if n > steps then steps = n end
					c = fpal[c+1]
					ins(lut[i], c)
				until c == black or n > 16
				if c ~= black then error("fader: color " .. i .. " never fades to " .. black)end
			end
			-- fill out remaining space with the black color
			-- and generate inverse lut for fade-ins
			for i = 0, 15 do
				ilut[i] = {}
				for s = 1, steps do
					if not lut[i][s] then lut[i][s] = black end
					ilut[i][(steps-s)+1] = lut[i][s]
				end
			end
			return lut, ilut, steps
		end
		function Fader._calc_fade(lut, p, steps)
			local s=1/steps
			local n=floor(p/s)
			for i=0,15 do
				pal(i, lut[i][n], true)
			end
		end
		function Fader._reset(t, dir, spd, hold)
			t.percent, t.fading = 0, true
			t.dir, t.spd = dir, (spd or _defspd)
			if hold and dir > 0 then t.hold = hold end
		end
		-- fades the screen by 'spd' speed
		function Fader.fade_in(t, spd)
			if t.fading then return end
			t:_reset(-1, spd)
		end
		function Fader.fade_out(t, spd, hold)
			if t.fading then return end
			t:_reset(1, spd, hold)
		end
		function Fader.update(t)
			if not t.fading then return end

			t.percent = min(1, t.percent+t.spd)
			Fader._calc_fade(t.dir == 1 and t.lut or t.ilut, t.percent, t.steps)

			if t.percent >= 1 then
				if t.hold > 0 then
					t.hold = t.hold-1
					return
				end
				t.fading = false
			end
		end
