--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
-- 	      Print utilities
--
--  Notes:
--      tx     means text           (string)
--      c      means color          (int)
--      sc     means shadow color   (int)
--      oc     means outline color  (int)
--      s      means scale          (int)
--      fw     means fixed width    (bool)
--      ox/oy  means offset x/y     (int)
--
--
--  Functions:
--       txtw(tx,fw,s)                    - get text width
--
--       printo(tx,x,y,c,oc)              - print with outline
--       prints(tx,x,y,c,sc,fw,s)         - print with shadow
--       printsc(tx,x,y,c,sc,fw,s)        - print with shadow centered
--
--       printg(t,x,y,c,fw,s,ox,oy)       - print on grid
--       printgs(t,x,y,c,sc,fw,s,ox,oy)   - print on grid with shadow
--       printgsc(tx,x,y,c,sc,fw,s)       - print grid/shadow/centered
--
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
	--[[ txtw - get text width                 002 ]]
		local function txtw(tx,fw,s,sf)
			return print(tx,0,-99,-1,fw or false,s or 1,sf or false)
		end

	--[[ printo - print with outline           002 ]]
		-- Use whichever version is preferable. The second one
		-- can be tweaked to only do diagonals or sides, making
		-- a thinner outline.
		local function printo(tx,x,y,c,oc)
			for j=y-1,y+1 do
				for i=x-1,x+1 do
					print(tx,i,j,oc)
				end
			end
			print(tx,x,y,c)
		end
		local function printo(tx,x,y,c,oc)
			local p=print
			p(tx,x-1,y,  oc)
			p(tx,x+1,y,  oc)
			p(tx,x,  y-1,oc)
			p(tx,x,  y+1,oc)

			p(tx,x-1,y-1,oc)
			p(tx,x+1,y-1,oc)
			p(tx,x-1,y+1,oc)
			p(tx,x+1,y+1,oc)

			p(tx,x,y,c)
		end

	--[[ printc - print with shadow centered  001 ]]
		-- TODO: TEST THIS
		-- To center on an axis, pass 'nil' to it.
		-- depends on 'txtw'
		local function printc(tx,x,y,w,h,c,fw,s)
			c,fw,s,w,h=c or 15,fw or false,s or 1,w or 240, h or 136
			if not x then x=(w//2-txtw(tx)//2) end
			if not y then y=(h//2-3) end
			print(tx,x,y,c,fw,s)
		end


	--[[ prints - print with shadow            001 ]]
		local function prints(tx,x,y,c,sc,fw,s)
			fw,s=fw or false,s or 1
			print(tx,x+1,y+1,sc,fw,s)
			print(tx,x,y,c,fw,s)
		end

	--[[ printsc - print with shadow centered  001 ]]
		-- To center on an axis, pass 'nil' to it.
		-- depends on 'txtw'
		local function printsc(tx,x,y,c,sc,fw,s)
			fw,s=fw or false,s or 1
			if not x then x=(240//2-txtw(tx)//2) end
			if not y then y=(136//2-3) end
			print(tx,x+1,y+1,sc,fw,s)
			print(tx,x,y,c,fw,s)
		end


--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
-- 		print on an 8x8 grid
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
	--[[ printg - print on grid                002 ]]
		function printg(t,x,y,c,fw,s,ox,oy)
			fw,s=fw or false,s or 1
			x,y=x*8+1+ox or 0,y*8+1+oy or 0
			print(t,x,y,c,fw,s)
		end

	--[[ printgc - print on grid centered      001 ]]
		-- To center on an axis, pass 'nil' to it.
		-- depends on 'txtw'
		local function printgc(tx,x,y,c,sc,fw,s)
			fw,s=fw or false,s or 1
			if not x then x=(240//8)//2-(txtw(tx)//8)//2 end
			if not y then y=(136//8)//2 end
			print(tx,x*8,y*8,c,fw,s)
		end

	--[[ printgs - print on grid with shadow   008 ]]
		function printgs(t,x,y,c,sc,fw,s,ox,oy)
			fw,s=fw or false,s or 1
			x,y=x*8+1+(ox or 0),y*8+1+(oy or 0)
			print(t,x+1,y+1,sc,fw,s)
			print(t,x,y,c,fw,s)
		end

	--[[ printgsc - print grid/shadow/centered 009 ]]
		-- To center on an axis, pass 'nil' to it.
		-- depends on 'txtw'
		local function printgsc(tx,x,y,c,sc,fw,s)
			fw,s=fw or false,s or 1
			if not x then x=(240//8)//2-(txtw(tx)//8)//2 end
			if not y then y=(136//8)//2 end
			print(tx,x*8+1,y*8+1,sc,fw,s)
			print(tx,x*8,y*8,c,fw,s)
		end
