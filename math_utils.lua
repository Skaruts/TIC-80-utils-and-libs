
	--[[ clamp - keep v between l and h        002 ]]
		-- depends on min, max   (common_shortenings.lua)
		local function clamp(v,l,h)return max(l,min(v,h))end

	--[[ wrap - wrap v around l and h          003 ]]
		local function wrap(v,l,h) return v > h and l or v<l and h or v end

	--[[ round - round v to nearest int        003 ]]
		-- depends on floor   (common_shortenings.lua)
		local function round(v)return floor(v+0.5)end

	--[[ lerp - linear interpolate             002 ]]
		local function lerp(a,b,t)return a*(1-t)+b*t end

	--[[ sign - get the sign of v              002 ]]
		local function sign(v)return v>=0 and 1 or -1 end

	--[[ dist - pythagorian distance           001 ]]
		-- depends on sqrt   (common_shortenings.lua)
		local function dist(x,y,x2,y2)local a,b=x-x2,y-y2 return sqrt(a*a+b*b)end

	--[[ sdist - distance squared              001 ]]
		local function sdist(x1,y1,x2,y2)local a,b=x1-x2,y1-y2 return a*a+b*b end

	--[[ chance - random chance in percentage  001 ]]
		-- depends on rand   (common_shortenings.lua)
		local function chance(pct)return rand(100)<pct end
