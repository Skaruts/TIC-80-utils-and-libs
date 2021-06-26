
	-- NOTE: fast versions of table functions do not preserve
	--       the order of items in a table

	--[[ fins - fast insert 'o' in 't'         002 ]]
		local function fins(t,o,i)
			if not i then
				t[#t+1]=o
			else
				t[#t+1]=t[i]
				t[i]=o
			end
		end

	--[[ find - find 'o' in array 't'          001 ]]
		local function find(t,o)
			for i=1,#t do
				local v=t[i]
				if v==o then return i,v end
			end
		end

	--[[ frem - fast remove from 't' at 'i'    002 ]]
		local function frem(t,i)
			local v,s=t[i],#t
			if i==s then
				t[s]=nil
			else
				local l=t[s]
				t[s],t[i]=nil,nil
				t[i]=l
			end
			return v
		end

	--[[ del - removes 'o' from array 't'      001 ]]
		-- depends on
		--     'find'
		--     'rem' (common_shortenings.lua)
		local function del(t,o)
			local i=find(t,o)
			if i then return rem(t,i) end
		end

	--[[ fdel - fast del 'v' from 't'          003 ]]
		-- depends on 'find'
		local function fdel(t,v)
			local i=find(t,v)
			if i then return frem(t,i) end
		end

	--[[ slice - take slice from array         001 ]]
		-- returns a slice of 't',
		-- from index 'f' to 'l',
		-- iterating by 's' step.
		local function slice(t,f,l,s)
			local i,r=1,{}
			for j=f or 1,l or#t,s or 1do
				r[i]=t[j]
				i=i+1
			end
			return r
		end

	--[[ dcopy - table deep copy               001 ]]
		-- Depends on setmt, getmt
		local function dcopy(t)
			if type(t)~='table'then return t end
			local c={}
			for k,v in pairs(t)do c[dcopy(k)]=dcopy(v)end
			return setmt(c,getmt(t))
		end

	--[[ dcopy_test - table deep copy          001 ]]
		-- TODO: is this any faster?
		-- Depends on setmt, getmt
		local function dcopy_test(t)
			local c={}
			for k, v in pairs(t) do
				c[type(k)=="table"and dcopy_test(k)or k]
				=type(v)=="table"and dcopy_test(v)or k
			end
			return setmt(c,getmt(t))
		end

	--[[ copy - shallow copy of table 't'      001 ]]
		-- Depends on setmt, getmt
		local function copy(t)
			local c={}
			for k,v in pairs(t)do
				c[k]=v
			end
			return setmt(c,getmt(t))
		end

	--[[ dupe - duplicate array 't'            001 ]]
		local function dupe(t)
			local c={}
			for i=1,#t do c[i]=t[i] end
			return c
		end

	--[[ dupeh - duplicate hash table 't'      001 ]]
		local function dupeh(t)
			local c={}
			for k,v in pairs(t)do
				c[k]=v
			end
			return c
		end

	--[[ has - check if 'o' is in table 't'    001 ]]
		local function has(t,o)
			for i=1,#t do
				if t[i]==o then return true end
			end
		end
		local contains=has  -- alias

	--[[ dmerge - merge dict/hash tables      001 ]]
		-- depends on 'has'
		function dmerge(a,b,err,...)
			local has,type=has,type
			err=err or"Key '%s' already exists in table."
			local t={}
			for k,v in pairs(a)do if type(k)~="number"then t[k]=v end end
			for k,v in pairs(b)do
				if type(k)~="number" then
					if has(t,k)then print(fmt(err,...or k))
					else t[k]=v
					end
				end
			end
			return t
		end


	--[[ hask - check if 't' has a key 'k'     001 ]]
		-- TODO: should I do separate ones for array or dictionary tables?
		local function hask(t,k)
			for _k in pairs(t)do
				if _k==k then return true end
			end
		end

	--[[ haskv - is 'kv' a key or val in 't'   001 ]]
		-- TODO: should I do separate ones for array or dictionary tables?
		local function haskv(t,kv)
			for k,v in pairs(t)do
				if k==kv or v==kv then return true end
			end
		end

	--[[ dedupe - remove duplicates from array 001 ]]
		local function dedupe(t)
			local hsh,res={},{}
			for i=1,#t do
				local v=t[i]
				if not hsh[v]then
					res[#res+1]=v
					hsh[v]=true
				end
			end
			return res
		end

	--[[ shufled - return shuffled copy of 't' 002 ]]
		-- algorithm from here: https://gist.github.com/Uradamus/10323382
		local function shufled(t)
			local c={}
			for i=1,#t do c[i]=t[i]end
			for i=#c,1,-1 do
				local j=rand(i)
				c[i],c[j]=c[j],c[i]
			end
			return c
		end

	--[[ shufle - shuffle array 't' in place   002 ]]
		local function shufle(t)
			for i=#t,1,-1 do
				local j=rand(i)
				c[i],c[j]=c[j],c[i]
			end
			return t -- just in case needed
		end

	--TODO: --[[ array1 - make new 1d array with 'v'       ]]

	--[[ array2 - make new 2d array with 'v'   002 ]]
		local function array2(w,h,v)
			-- TODO: choice of 0-indexed or 1-indexed
			v=v or false
			local t={}
			for j=0,h-1 do
				t[j]={}
				for i=0,w-1 do t[j][i]=v end
			end
			return t
		end

	--[[ array2b - batch make new 2d arrays    002 ]]
		-- TODO: document this better
		-- vals is table of default values for each array
		-- len of vals tells the amount of arrays to make
		local function array2b(w,h,vals,i0)
			local n,arrays,s,mw,mh=#vals,{},1,w,h
			if i0 then s,mw,mh=0,w-1,h-1 end
			for k=1,n do arrays[k]={} end
			for j=s,mh do
				for k=1,n do arrays[k][j]={} end
				for i=s,mw do
					for k=1,n do arrays[k][j][i]=vals[k] end
				end
			end
			return arrays
		end

	--[[ zconc - concat, but 0-indexed         001 ]]
		local function zconc(t,sep)
			sep=sep or""
			local c={}
			for i=0,#t do
				c[i+1]=t[i]
			end
			return conc(c,sep)
		end

