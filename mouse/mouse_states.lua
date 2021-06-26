--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
--        Mouse States
--
--  Usage:
--      update_mst()         - call this function at the start of every frame frame to update the mouse states
--
--      M1|M2|M3             - constants for left|right|middle buttons (values 1|2|3)
--      mx|my                - mouse position
--      m1|m2|m3             - button states (boolean)
--      mwx|mwy (v0.80+)     - mouse wheel scroll states
--
--      lmx|lmy              - mouse position last frame
--      rmx|rmy              - mouse position relative to last position
--
--	    mbtn( M1|M2|M3 )     - test if a mouse button is currently pressed
--	    mbtnp( M1|M2|M3 )    - test if a mouse button was just pressed
--	    mbtnr( M1|M2|M3 )    - test if a mouse button was just released
--	    mbtnt( M1|M2|M3 )    - see how many frames a mouse button has been held down
--      mmoved()             - check if mouse moved since last frame
--
--      Calling those functions with no parameters returns:
--	        mbtn()   ->  1 or 2 or 3  -  whether any button is being held
--	        mbtnp()  ->  1 or 2 or 3  -  whether any button was just pressed
--	        mbtnr()  ->  1 or 2 or 3  -  whether any button was just released
--	        mbtnt()  ->  1, 2, 3      -  the held time in frames for all 3 buttons
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
-- TODO: could I use binary for the button states?
--       And would it be of any advantage?

	--[[ Mouse States                          006 ]]
		-- reminder: call update_mst() at the start of every frame
		local mx,my,mwx,mwy,lmx,lmy,rmx,rmy=0,0,0,0,0,0,0,0
		local M1,M2,M3,m1,m2,m3=1,2,3,false,false,false
		local m_stt={prev={0,0,0},curr={0,0,0}}
		local mbtn,mbtnp,mbtnr,mbtnt,update_mst
		function mbtn(b)
			if b then return m_stt.curr[b]>0 end
			return m_stt.curr[1]>0
			    or m_stt.curr[2]>0
			    or m_stt.curr[3]>0
		end
		function mbtnp(b)
			if b then return m_stt.curr[b]==1 end
			return m_stt.curr[1]==1
			    or m_stt.curr[2]==1
			    or m_stt.curr[3]==1
		end
		function mbtnr(b)
			if b then return m_stt.prev[b]>0 and m_stt.curr[b]==0 end
			return m_stt.prev[1]>0 and m_stt.curr[1]==0
			    or m_stt.prev[2]>0 and m_stt.curr[2]==0
			    or m_stt.prev[3]>0 and m_stt.curr[3]==0
		end
		function mbtnt(b)
			if b then return m_stt.curr[b] end
			return m_stt.curr[1],m_stt.curr[2],m_stt.curr[3]
		end
		function update_mst()
			lmx,lmy=mx,my
			mx,my,m1,m3,m2,mwx,mwy=mouse()
			rmx,rmy=mx-lmx,my-lmy
			m_stt.prev={m_stt.curr[1],m_stt.curr[2],m_stt.curr[3]}
			m_stt.curr={0,0,0}
			if m1 then m_stt.curr[1]=m_stt.prev[1]+1 end
			if m2 then m_stt.curr[2]=m_stt.prev[2]+1 end
			if m3 then m_stt.curr[3]=m_stt.prev[3]+1 end
		end
		function mmoved()
			return mx~=lmx or my~=lmy
		end
