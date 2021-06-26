--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
-- 	      Debugging utilities
--
--  Usage:
--      User settings:
--          dbg.key         (number)  - Key to toggle debugger     (default 41)
--          dbg.active      (bool)    - Is debugger on             (default false)
--          dbg.use_padding (bool)    - Use spacing between lines  (default false)
--          dbg.fixw        (bool)    - Use fixed-width text       (default true)
--          dbg.fg          (number)  - Foregroud (text) color     (default 15)
--          dbg.bg          (number)  - Background color           (default 1)
--
--      Functions:
--          dbg:draw()            Call it at end of every frame
--          dbg:toggle()          Toggles the bebugger on/off
--          dbg:spaced(enable)    Enable/disable vertical spacing on text
--
--          monitor(k,v[,n])      Track the value of a variable
--              k (string)  - name of the value being tracked
--              v (any)     - value to be tracked
--              n (number)  - (optional) align value to 'n' characters from the left
--
--          bm(id,f)              Benchmark a function
--          bma(id,f)             Benchmark with averaging
--              id (string)  - display-name of the benchmark
--              f (function) - the code to be benchmarked
--
--  Examples:
--      monitor("dt", fmt("%.3f", delta_time))
--      monitor("fps", fmt("%d",1//dt))
--      monitor("hp: ", player.hp, 10)
--
--      bma("some bm", some_func)
--
--      bma("some bm", function()
--          -- stuff
--      end)
--
--  Dependencies:
--      tostr,conc,fmt    (common_shortenings.lua)
--      txtw              (print.lua)
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
		--[[ Debug/benchmark utilities             018 ]]
		--  depends on:
		--      tostr, conc, fmt    (common_shortenings.lua)
		--      txtw                (print.lua)
		local _f,monitor,bm,bma=1
		local dbg={
			key=41,
			fg=15,
			bg=3,
			active=false,
			use_padding=true,
			fixw=true,
			h=0,w=0,vals=nil,reg={},
			toggle=function(t)t.active=not t.active end,
			spaced=function(t,b)t.use_padding=b end,
			draw=function(t)
				_f=_f+1
				if _f>500 then
					_f=1
					for k,_ in pairs(t.reg)do t.reg[k]=0 end
				end
				if not t.active then return end
				if t.use_padding then
					local w=t.w*8-t.w*2
					rect(0,0,w+8,t.h*8+8,t.bg)
					for i=1,#t.vals do
						print(t.vals[i],2,(i-1)*8+2,t.fg,t.fixw)
					end
					t.vals,t.w={},0
				else
					local w=txtw(t.vals,t.fixw)
					rect(0,0,w+8,(t.h+1)*6,t.bg)
					print(t.vals,2,2,t.fg,t.fixw)
					t.vals=""
				end
				t.h=0
			end,
		}
		dbg.vals=dbg.use_padding and{}or""
		function monitor(k,v,n)
			local t=dbg
			if not t.active then return end
			if t.use_padding then
				local s
				if v==nil then s=k
				elseif k~=""then
					if n then k=k..rep(' ',n-#k) end
					s=conc({k,tostr(v)})
				else s=tostr(v)
				end
				t.vals[#t.vals+1]=s
				if #s>t.w then t.w=#s end
			else
				if v==nil then t.vals=conc({t.vals,k,'\n'})
				elseif k~=""then
					if n then k=k..rep(' ',n-#k) end
					t.vals=conc({t.vals,k,tostr(v),'\n'})
				else t.vals=conc({t.vals,tostr(v),'\n'})
				end
			end
			t.h=t.h+1
		end
		function bm(id,f)
			local tm=time()
			f()
			monitor(id, fmt("%.2fms",time()-tm))
		end
		function bma(id,f)
			local rg,t1,t2,s=dbg.reg
			if not rg[id]then rg[id]=0 end
			t1=time()
			f()
			t2=time()-t1
			s=fmt("%.2fms",t2)
			rg[id]=rg[id]+t2
			s=s..rep(' ',9-#s)..fmt("%.2fms",rg[id]/_f)
			monitor(id..rep(' ',11-#id),s)
		end

