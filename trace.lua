
	--[[ tracef - trace formatted              001 ]]
		-- depends on fmt
		local function tracef(...)
			trace(fmt(...))
		end

	--[[ tracec - trace csv arguments          003 ]]
		-- depends on conc   (common_shortenings.lua)
		-- TODO: does this really need "\n"?
		local function tracec(...)
			local t={}
			for i=1,select("#",...)do
				t[i]=tostr(select(i,...))
			end
			trace(conc(t,","))
		end

	--[[ traces - trace 'sep' separated args   003 ]]
		-- depends on conc   (common_shortenings.lua)
		-- TODO: concat has issues with certain values
		local function traces(sep,...)
			local t={}
			for i=1,select("#",...)do
				t[i]=tostr(select(i,...))
			end
			trace(conc(t,sep))
		end

	--[[ trace1d - trace a 1D array            001 ]]
		local function trace1d(t)
			-- TODO: couldn't this just use table.concat, like 'trace2d' does?
			local s=""
			for i,v in ipairs(t)do
				s=s..v..","
			end
			trace(s)
		end

	--[[ trace2d - trace a 2d array            002 ]]
		-- depends on conc   (common_shortenings.lua)
		-- trace array 'a', with elements separated by 'sep'
		-- set i0 to true if 'a' is 0-indexed
		function trace2d(a,sep,i0)
			sep=sep or""
			local s,w,c,aj=i0 and 0 or 1,#a[1]
			for j=s,#a do
				c,aj={},a[j]
				for i=s,w do
					c[i+1-s]=aj[i]
				end
				trace(conc(c,sep))
			end
		end

	--[[ trace2d (OLD) - trace a 2d array      001 ]]
		function trace2d(t,sep,i0)
			sep=sep or""
			local prs,cnc=i0 and zall or all,i0 and zconc or conc
			for v in prs(t)do
				trace(cnc(v,sep))
			end
		end

