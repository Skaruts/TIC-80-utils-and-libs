	--[[ Debug drawing stuff                   003 ]]
		-- TODO: add a grid-step choice
		local function draw_dbg_grid(c)
			c=c or 12
			for i=0,240,8 do line(i,0,i,136,c)end
			for j=0,136,8 do line(0,j,240,j,c)end
		end
		local function draw_dbg_center_lines(c)
			c=c or 15
			line(240/2,0,240/2,136,c)
			line(0,136/2,240,136/2,c)
		end
