	--[[ blocking fade in/out addon            002 ]]
		-- depends on:
		--    the fade_in/fade_out system above
		--    max, min  (common_shortenings.lua)
		--    flip, wait       (loop_utils.lua)
		--
		-- functions:
		--     fadeb(dir, speed, wait_bef, wait_aft, scr_state)
		--
		-- Fades the screen while blocking the game loop so everything stops.
		-- Great for fade-outs after a player's death, for example.
		-- Waits for 'wait_bef' number of frames, then fades the screen
		-- in 'dir' direction, by 'spd' speed, and then waits for 'wait_aft'
		-- number of frames
		local function fadeb(dir, spd, wait_bef, wait_aft)
			spd,wait_bef,wait_aft=spd or _fdefinc,wait_bef or 0,wait_aft or 0
			wait(wait_bef)
			local pek,pok=peek4,poke4

			local scr_state={} -- keep 1-indexed for maxed performance?
			for i=1,240*136 do scr_state[i]=pek(i-1)end

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

					-- for some odd reason this check is needed here
					-- without it, the screen is reset during 'wait_aft'
					if _fpc<1 then
						for i=1,240*136 do pok(i-1,scr_state[i]) end
					end
					-- print("fading out - ".. _fpc*100 .."%",0,0,12)
					_calc_fade()
					flip()
				end
			end
			wait(wait_aft)
		end
