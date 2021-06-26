--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
--        Vector
--
--  Notes:
--      - Should work fine, but I haven't tested everything.
--      - It has a lot of stuff, but you can remove stuff
--        you don't use.
--
--  Usage:
--      Use the general (slower) vec constructor
--        a = vec(10,20)
--        b = vec()
--
--      Or use the fast constructors 'vec2', 'vec0' and 'vecv',
--      if performance is critical. These require either
--      all parameters or none, respectively. For most uses,
--      the general constructor should be fine, though.
--
--      Use "a % b" to check if a and b are the same vector object.
--      Use "a == b" to check if a and b are equivalent vectors.
--
--  Dependencies:
--      abs, flr, ceil, sqrt, max, min, atan2
--      tostr, setmt, raweq
--      fmt
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
	--[[ vec - a vector2 object                004 ]]
		local _VMT,vec0,vec2,vecv,vec={}
		function vec(x,y)
			if not x then return vec0()end
			if not y then return vecv(x)end
			return vec2(x,y)
		end
		function vec0()return setmt({x=0,y=0},_VMT)end
		function vecv(t)return setmt({x=t.x,y=t.y},_VMT)end
		function vec2(x,y)return setmt({x=x,y=y},_VMT)end
		_VMT={
			__index=_VMT,
			__tostring=function(t)return fmt("(%s,%s)",t.x,t.y)end,
			__mod=function(a,b)return raweq(a,b)end,
			__add=function(a,b)return type(b)=="number"and vec2(a.x+b,a.y+b)or vec2(a.x+b.x,a.y+b.y)end,
			__sub=function(a,b)return type(b)=="number"and vec2(a.x-b,a.y-b)or vec2(a.x-b.x,a.y-b.y)end,
			__mul=function(a,b)return type(b)=="number"and vec2(a.x*b,a.y*b)or vec2(a.x*b.x,a.y*b.y)end,
			__div=function(a,b)return type(b)=="number"and vec2(a.x/b,a.y/b)or vec2(a.x/b.x,a.y/b.y)end,
			__idiv=function(a,b)return type(b)=="number"and vec2(a.x//b,a.y//b)or vec2(a.x//b.x,a.y//b.y)end,
			__eq=function(a,b)return a.x==b.x and a.y==b.y end,
			__concat=function(a,b)return tostr(a)..tostr(b)end,
			__pow=function(a,b)
				if type(b)=="number"then return vec2(a.x^b,a.y^b)end
				return vec2(a.x^b.x,a.y^b.y)
			end,
			__unm=function(v)return vec2(-v.x,-v.y)end,
			__len=function(v)return sqrt(v.x*v.x+v.y*v.y)end,
			len=function(v)return sqrt(v.x*v.x+v.y*v.y)end,

			split=function(v)return v.x,v.y end,

			dist2=function(t,o)return abs(sqrt((t.x-o.x)^2+(t.y-o.y)^2))end,
			abs=function(v)return vec2(abs(v.x),abs(v.y))end,
			angle=function(v)return atan2(v.y,v.x)end,
			rot=function(v)--[[TODO]]end,
			dot=function(a,b)return a.x*b.x+a.y*b.y end,
			cross=function(v)--[[TODO]]end,

			floor=function(v) v.x=flr(v.x), v.y=flr(v.y) end,
			floored=function(v)return vec2(flr(v.x),flr(v.y))end,
			ceil=function(v)v.x=ceil(v.x),v.y=ceil(v.y)end,
			ceiled=function(v)return vec2(ceil(v.x),ceil(v.y))end,
			round=function(v)v.x=flr(v.x+0.5),v.y=flr(v.y+0.5)end,
			rounded=function(v)return vec2(flr(v.x+0.5),flr(v.y+0.5))end,
			norm=function(v) --[[TODO]] end,
			normed=function(v)return v/sqrt(#v)end,
			swap=function(v)v.x,v.y=v.y,v.x end,
			swaped=function(v)return vec2(v.y,v.x)end,
			clamp=function(v,l,h)
				if type(l)=="number" then v.x=max(l,min(v.x,h)),v.y=max(l,min(v.y,h))
				else v.x=max(l.x,min(v.x,h.x)),v.y=max(l.y,min(v.y,h.y))
				end
			end,
			clamped=function(v,l,h)
				if type(l)=="number" then return vec2(max(l,min(v.x,h)),max(l,min(v.y,h)))
				else return vec2(max(l.x,min(v.x,h.x)),max(l.y,min(v.y,h.y)))
				end
			end,
			snap=function(v,gs) --[[TODO]] end,
			snapped=function(v,gs)
				if type(gs)=="number"then gs=vec2(gs,gs)end
				local rv,diff=vec0(),vec2(v.x%gs.x,v.y%gs.y)
				if diff.x>=gs.x*0.5 then rv.x=v.x+gs.x-diff.x
				else rv.x=v.x-diff.x end
				if diff.y>=gs.y*0.5 then rv.y=v.y+gs.y-diff.y
				else rv.y=v.y-diff.y end
				return rv
			end,
		}
