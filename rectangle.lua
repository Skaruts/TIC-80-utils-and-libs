--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
--        Rectangle
--
--  Notes:
--      - Should work fine, but I haven't tested everything.
--      - It has a lot of stuff, but you can remove stuff
--        you don't use.
--
--  Usage:
--      Use the general (slower) rec constructor
--        a = rec()
--        b = rec(5, 5, 10, 20)
--        c = rec(vec(5, 5), vec(10, 20))
--        d = rec(a)
--
--      Or use the faster constructors, if performance is critical
--        rec0()             -  requires no args
--        recr(rect)         -  requires a rectangle or table
--        recv(vecA, vecB)   -  requires two vectors or tables
--        rec2(x,y,w,h)      -  requires all component numbers (the '2' stands for '2D')
--
--      For most uses, the general constructor should be fine, though.
--
--      Use "a % b" to check if a and b are the same rect object.
--      Use "a == b" to check if a and b are equivalent rects.
--
--  Properties:
--      x, y, w, h                 - dimensions of the rectangle
--      l, t                       - 'left' and 'top' aliases for 'x' and 'y'
--      r|x2, b|y2                 - 'right' and 'bottom' points (not the same as 'w' and 'h')
--      p                          - position   ( vec(x,y) )
--      s                          - size       ( vec(w,h) )
--      c            (read-only)   - center
--      a            (read-only)   - area
--      tl,tr,bl,br  (read-only)   - the 4 corner points (vecs) of the rectangle
--
--  Dependencies:
--      vec
--      flr, min, max
--      tostr, setmt, raweq,
--      fmt
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
	--[[ rec - a rectangle object              004 ]]
		-- read only properties
		local _RMT,_REC_RO,_RILUT,_RNILUT,rec0,recr,recv,rec2,rec={}
		-- constructor
		function rec(x,y,w,h)
			if not x then return rec0()end
			if not y then return recr(x)end
			if not w then return recv(x,y)end
			return rec2(x,y,w,h)
		end
		-- faster constructors (used internally)
		function rec0()return setmt({x=0,y=0,w=0,h=0},_RMT)end
		function recr(r)return setmt({x=r.x or x[1],y=r.y or x[2],w=r.w or x[3],h=r.h or x[4]},_RMT)end
		function recv(a,b)return setmt({x=a.x or x[1],y=a.y or x[2],w=b.x or y[1],h=b.y or y[2]},_RMT)end
		function rec2(x,y,w,h)return setmt({x=x,y=y,w=w,h=h},_RMT)end
		_REC_RO={c=true,a=true,tl=true,tr=true,bl=true,br=true}
		-- lookup table for __index (to read properties)
		_RILUT={
			x2=function(t,k)return t.x+t.w end,
			y2=function(t,k)return t.y+t.h end,
			p=function(t,k)return vec2(t.x,t.y)end,
			s=function(t,k)return vec2(t.w,t.h)end,
			c=function(t,k)return vec2(flr((t.x+t.x+t.w)/2),flr((t.y+t.y+t.h)/2))end,
			a=function(t,k)return t.x*t.y end,
			l=function(t,k)return t.x end,
			r=function(t,k)return t.x+t.w end,
			t=function(t,k)return t.y end,
			b=function(t,k)return t.y+t.h end,
			tl=function(t,k)return vec2(t.x,t.y)end,
			tr=function(t,k)return vec2(t.x+t.w,t.y)end,
			bl=function(t,k)return vec2(t.x,t.y+t.h)end,
			br=function(t,k)return vec2(t.x+t.w,t.y+t.h)end,
		}
		-- lookup table for __newindex (to write properties)
		_RNILUT={
			l=function(t,v)t.x=v end,
			r=function(t,v)t.w=v-t.x end,
			t=function(t,v)t.y=v end,
			b=function(t,v)t.h=v-t.y end,
			x2=function(t,v)t.w=v-t.x end,
			y2=function(t,v)t.h=v-t.y end,
			p=function(t,v)t.x,t.y=v.x,v.y end,
			s=function(t,v)t.w,t.h=v.x,v.y end,
		}
		_RMT={
			__index=function(t,k)
				if _RMT[k]~=nil then return _RMT[k]end
				return _REC_ILT[k]and _REC_ILT[k](t,k)or error(fmt("bad index '%s' for rect",tostr(k)),2)
			end,
			__newindex=function(t,k,v)
				if _REC_RO[k]then error(fmt("'%s' is read only",tostr(k)))end
				return _RNILUT[k]and _RNILUT[k](t,v)or error(fmt("bad index '%s' for rect",tostr(k)),2)
			end,
			__tostring=function(t)return fmt("(%s,%s,%s,%s)",t.x,t.y,t.w,t.h)end,
			--TODO: is this how to add rectangles?
			__add=function(t,o)return rec2(min(t.x,o.x),min(t.y,o.y),max(t.x2,o.x2),max(t.y2,o.y2))end,
			-- use % to check if a and b are the same rectangle object
			__mod=function(a,b)return raweq(a,b)end,
			__eq=function(t,o)return t.x==o.x and t.y==o.y and t.w==o.w and t.h==o.h end,
			__concat=function(t,o)return tostr(t)..tostr(o)end,

			center=function(t)return vec2(flr((t.x+t.x+t.w)/2),flr((t.y+t.y+t.h)/2))end,
			area=function(t)return t.x*t.y end,
			is_flat=function(t)return t.w==0 or t.h==0 end,
			merged=function(t,o)return rec2(min(t.x,o.x),min(t.y,o.y),max(t.x2,o.x2),max(t.y2,o.y2))end,
			clip=function(t,o)return rec2(max(t.x,o.x),max(t.y,o.y),min(t.x2,o.x2),min(t.y2,o.y2))end,
			grow_side=function(s,l,r,t,b)s.x=s.x-l;s.y=s.y-t;s.w=s.w+r;s.h=s.h+b;end,
			grow=function(t,by)t.x=t.x-by/2;t.y=t.y-by/2;t.w=t.w+by/2;t.h=t.h+by/2;end,
			intersects=function(a,b)return a.x<b.x2 and a.x2>b.x and a.y<b.y2 and a.y2>b.y end,
			encloses=function(a,b)return b.x>=a.x and b.y>=a.y and b.x2<a.x2 and b.y2<a.y2 end,
			has_point=function(t,x,y)
				if not y then return x.x>=t.x and x.y>=t.y and x.x<t.x2 and x.y<t.y2 end
				return x>=t.x and y>=t.y and x<t.x2 and y<t.y2
			end,
			-- make it square (by default it reduces the largest side)
			square=function(t,reduce)
				local f=reduce and min or max
				t.w,t.h=f(t.w,t.h),f(t.w,t.h)
			end,
			squared=function(t,reduce)
				local f=reduce and min or max
				return rec2(t.x,t.y,f(t.w,t.h),f(t.w,t.h))
			end,
		}


