
	--[[ range - python-like range (0-indexed) 002 ]]
		-- I did this one for fun; I'm not sure it's useful
		-- it works almost exactly like python's 'range()'
		--     for i in range(10) do
		--         print(i)
		--     end
		local function range(b,e,s) -- begin[,end[,step]]
		    if not b or b==e or s==0 then error("invalid range",2)end
		    if not e then e,b=b,0 end
		    if not s then s=e>b and 1 or -1 end
		    -- prevent infinite loop
		    if (e<b and s>0) or (e>b and s<0) then error("invalid step",2)end
		    local i=b-s
		    return e>b
		        and function()
		            i=i+s
		            if i<e then return i end
		        end
		        or function()
		            i=i+s
		            if i>e then return i end
		        end
		end

	--[[ zpairs - ipairs, but 0-indexed        001 ]]
		-- TODO: just return the function for next, like 'all' does,
		--       or first I should test which is faster
		local function _znxt(t,i)
			if i+1<=#t then
				i=i+1
				return i,t[i]
			end
		end
		local function zpairs(t)
			return _znxt,t,-1
		end

	--[[ all - ipairs but without index        001 ]]
		-- based on pico8 'ALL()'
		--   for v in all(t) do
		--       print(v)
		--   end
		local function all(t)
			local i,n=0,#t
			return function()
				i=i+1
				if i<=n then return t[i]end
			end
		end

	--[[ zall - all, but 0-indexed             001 ]]
		local function zall(t)
			local i,n=-1,#t
			return function()
				i=i+1
				if i<=n then return t[i]end
			end
		end
