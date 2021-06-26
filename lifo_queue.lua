--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
--        LIFO Queue
--
--  Functions:
--      push(v)   - adds 'v' to the queue
--      peek()    - returns the last item without removing it
--      pop()     - removes the last item and returns it
--      has(v)    - check if 'v' exists in the queue
--
--  Example:
--      local a = Lifo()
--      a:push(10)
--      print(a:pop())
--
--  Dependencies:
--      setmt  (common_shortenings.lua)
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
	--[[ Lifo - a simplistic LIFO queue        002 ]]
		local _LQMT,lifoq={}
		function Lifo()
			return setmt({},_LQMT)
		end
		_LQMT={
			__index=function(t,k)return _LQMT[k] end,
			push=function(t,v)t[#t+1]=v end,
			peek=function(t)return t[#t]end,
			pop=function(t)
				local i=t[#t]
				t[#t]=nil
				return i
			end,
			has=function(t,v)
				for i=1,#t do
					if t[i]==v then return i end
				end
			end,
			clear=function(t)
				for i=#t,1,-1 do t[i]=nil end
			end,
		}

