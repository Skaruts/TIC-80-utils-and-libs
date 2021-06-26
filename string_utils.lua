
	--[[ string.wrap - wrap 's' within 'w'     002 ]]
		-- does word wrapping, basically.
		-- returns a table with substrings of 's'
		-- divided to fit within 'w'.

		-- depends on
		--     split    (string_utils.lua)
		--     txtw     (print.lua)
		function string.wrap(s,w)
			local t,str,wrds,ln={},"",s:split(' ')
			for i,s in ipairs(wrds)do
				ln=str..s
				if txtw(ln)>w then
					t[#t+1]=str
					ln=s
				end
				if i==#wrds then t[#t+1]=ln
				else str=ln..' '
				end
			end
			return t
		end

	--[[ string.del - delete substring s[i..j] 001 ]]
		-- delete substring in 's' from 'i' to 'j' (both inclusive)
		function string.del(s,i,j)
		    i=i or 1
		    j=j or i
		    return s:sub(1,i-1)..s:sub(j+1,-1)
		end

	--[[ string.ends_with                      001 ]]
		-- 'cs' means case sensitive
		-- 'sb' is the substring to compare to
		function string.ends_with(s,sb,cs)
			if sb==nil or sb=="" then return false end
			cs=cs==nil and true or cs
			if not cs then sb=sb:lower()end
			return sb==(cs and s:sub(-#sb) or s:sub(-#sb):lower())
		end

	--[[ string.starts_with                     001]]
		-- 'cs' means case sensitive
		-- 'sb' is the substring to compare to
		function string.starts_with(s,sb, cs)
			if sb==nil or sb=="" then return false end
			cs=cs==nil and true or cs
			if not cs then sb=sb:lower()end
			return sb==(cs and s:sub(1,#sb) or s:sub(1,#sb):lower())
		end

	--[[ string.chars - table of chars in 's'  001 ]]
		function string.chars(s,i0)
			local t,i={},i0 and 0 or 1
			for j in s:gmatch('%U')do
				t[i]=j
				i=i+1
			end
			return t
		end

	--[[ string.bytes - table of bytes in 's'  001 ]]
		function string.bytes(s,i0)
			local t={s:byte(1,#s)}
			if not i0 then return t end  -- TODO: is there a better way to do this?
			for i=1,#t do t[i-1]=t[i]end  -- shift elems to 0 indexed
			t[#t]=nil
			return t
		end

	--[[ string.split - split string at 'sp' 001 ]]
		-- split string by delimiter 'sp'
		-- TODO: iirc this had some edge case issues
		local _DEF_PAT,_L_PAT,_R_PAT='([^, ]+)','([^',']+)'
		-- 'sp' is a string that lists separators to be used
		function string.split(s,sp)
			local t={}
			if sp=="" then
				for i=1,#s do
				    t[#t+1]=s:sub(i,i)
				end
			else
				sp=sp and _L_PAT..sp.._R_PAT or _DEF_PAT
				for word in s:gmatch(sp)do
				    t[#t+1]=word
				end
			end
			return t
		end

	--[[ string.align - align in 'w' from 'p'  001 ]]
		-- depends on ceil    (common_shortenings.lua)

		-- Align string 's' to a position 'p' within 'w' width
		-- filling it with the 'fl' filler if needed
		-- 'p' is a string ('l', 'r' or 'c')    (left/right/center)
		-- 'fl' is a single character
		function string.align(s,w,p,fl)
			local n=w-#s
			if n<=0 then return s end
			fl,p=fl or' ',p or"l"
			if p=='l'then return s..fl:rep(n)end
			if p=='r'then return fl:rep(n)..s end
			if p=='c'then return fl:rep(n//2)..s..fl:rep(ceil(n/2))end
		end

	--[[ string.hexn - hex string to number    001 ]]
		-- depends on tonum, min, max (common_shortenings.lua)
		-- convert hex string to a number: "ff" or "0xff" -> 256
		function string.hexn(s,i,j)
			i=i and max(i,1)or 1
			j=j and min(max(i,j),#s)or#s
			return tonum(s:sub(i,j),16)
		end

	--[[ string.ascii - convert to ascii       001 ]]
		-- returns a table with all characters in 's' converted to their ascii value
		-- if s is a single char then returns one ascii value
		function string.ascii(s,i,j)
			if #s==1 then return s:byte(1,1)end
			i=i and max(i,1)or 1
			j=j and min(max(i,j),#s)or#s
			return {s:byte(i,j)}
		end

	--[[ string.csv - table with csv in 's'    001 ]]
		-- returns a table with all comma separated values in string
		function string.csv(s)
			local t,str={},s:gsub(',',' ')
			for v in str:gmatch("%S+")do   -- will this work?
				t[#t+1]=v
			end
			return t
		end

	--[[ string.cap - capitalize string        002 ]]
		-- depends on
			-- min, max, conc   (common_shortenings.lua)
			-- chars            (string_utils.lua)

		-- no arguments         -> caps every word
		-- one number argument  -> caps the 'i'th word
		-- two number arguments -> caps all words in range from the 'i'th to 'j'th
		function string.cap(s,i,j)
			if not i then -- no arguments, capitalize every word
				local str=s:lower():gsub('_',' '):gsub('  ',' ')
				str=str:gsub("(%a)([%S]*)",function(fst,rst)return fst:upper()..rst:lower()end)
				return str
			end

			i=i and max(i,1)or 1
			j=j and max(i,j)or i -- if 'j' is nil, make it equal to 'i'

			local t=s:lower():gsub('_',' '):chars()
			for i=i,min(j,#t)do
				t[i]=t[i]:gsub("%a",upper,1)
			end
			return conc(t,' ')
		end

	--[[ string.isnum - see if 's' is number   001 ]]
		-- depends on min,max,tonum   (common_shortenings.lua)
		function string.isnum(s,i,j)
			i=i and max(i,1)or 1
			j=j and min(max(i,j),#s)or#s
			return tonum(s:sub(i,j))~=nil
		end

	-- Padding functions based off of
	-- https://github.com/blitmap/lua-snippets/blob/master/string-pad.lua
	-- all of these functions return their result and a boolean
	-- to notify the caller if the string was changed
	--[[ string:lpad - add 'p' to left of 's'  001 ]]
		-- 'w' is the width
		function string.lpad(s,w,p)
			p=p or' '
			local str=p:rep(w-#s)..s
			return str,#str~=#s
		end

	--[[ string:rpad - add 'p' to right of 's' 001 ]]
		-- 'w' is the width
		function string.rpad(s,w,p)
			p=p or' '
			local str=s..p:rep(w-#s)
			return str,#str~=#s
		end

	--[[ string:lpad - add 'p' to left of 's'  001 ]]
		-- depends on lpad, rpad    (string_utils.lua)
		-- 'w' is the width
		function string.pad(s,w,p)
			p=p or' '
			local s1,b1=s:rpad(w//2+#s,p)
			local s2,b2=s1:lpad(w,p)
			return s2,b1 or b2
		end
