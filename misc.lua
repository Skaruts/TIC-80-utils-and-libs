
	--[[ tonum - a slightly better tonumber    002 ]]
		local function tonum(v)
			if type(v)=="boolean" then
				return v and 1 or 0
			end
			return tonumber(v)
		end

	--[[ Bounds checking                       003 ]]
		-- replace the placeholders MIN_X, MAX_X, etc...
		local function inbounds(x,y)
			return x>=MIN_X and x<MAX_X and y>=MIN_Y and y<MAX_Y
		end
		local function outbounds(x,y)
			return x<MIN_X and x>=MAX_X and y<MIN_Y and y>=MAX_Y
		end

