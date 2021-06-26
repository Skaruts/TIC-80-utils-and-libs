	--[[ tm_check - time stuff / dt            003 ]]
		-- call 'tsecs' without args to get current time in secs
		-- call 'tm_check' at the start of every frame to update t/dt/t2
		local t,t1,t2,dt,tsecs,tm_check=0,time()
		function tsecs(tm) return (tm or time())/1000 end
		function tm_check()
			t=t+1
			t2=time()/1000
			dt=t2-t1
			t1=t2
		end

	--[[ flip - mimics pico-8 flip             002 ]]
		-- depends on 'tunpk' (table_utils.lua)

		-- IMPORTANT: unfortunately, the only hacky way I could make
		-- this work requires taking over the function TIC here.
		-- So, to use this, add an underscore to your TIC function,
		-- like so:
		--     function _TIC()
		--         -- your code here as usual
		--     end
		-- Your '_TIC' function is called from here, and will run
		-- in a coroutine.
		--
		-- NOTE: error messages will look slightly different when using
		-- this, because they're coming from inside a coroutine (or because
		-- I don't know what I'm doing. :D).

		local _C,_TIC,_doloop,_loop_co,_cxpcall,flip,_cresume2=coroutine
		local _cstatus,_cresume,_ccreate,_cyield=_C.status,_C.resume,_C.create,_C.yield
		function TIC()
			_doloop()
		end
		function _cxpcall(co)
			local outp={_cresume(co)}
			if outp[1]==false then
				return false,outp[2],debug.traceback(co)
			end
			return tunpk(outp)
		end
		function flip()
			_cyield(_loop_co)
		end
		function _cresume2(co)
			local v,e,tb = _cxpcall(_loop_co)
			if not v then error(e .. "\n" .. tb,4)end
		end
		function _doloop()
			if _loop_co ~= nil then
				local status = _cstatus(_loop_co)
				if status == "dead" then
					_loop_co = _ccreate(_TIC)
					_cresume2(_loop_co)
				elseif status == "suspended" then
					_cresume2(_loop_co)
				end
			else
				_loop_co = _ccreate(_TIC)
				_cresume2(_loop_co)
			end
		end

	--[[ wait - freezes game for 'n' frames    002 ]]
		-- depends on 'flip'
		local function wait(n)
			if not n or n<=0 then return end
			for i=n,0,-1 do
				flip()
			end
		end
