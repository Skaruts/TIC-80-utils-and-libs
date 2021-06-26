	--[[ TinyIMUI Extensions                    006 ]]
		--[[ pal rendering                          002 ]]
			-- depends on 'pal'  (drawing_utils.lua)
			-- define 'pal' render step and rendering functions and pass them along to the ui
			ui.add_render_step("pal",
				function(...)ui.push_render_step("pal",{...})end,
				pal
			)
		--[[ sprp rendering                         001 ]]
			-- depends on 'sprp' and 'pal'  (drawing_utils.lua)
			ui.add_render_step("sprp",
				function(...)ui.push_render_step("sprp",{...})end,
				sprp
			)
		--[[ nframe rendering                       002 ]]
			local function _draw_quad(x,y,w,h,u,v,u2,v2)
				textri(x, y,   x+w,  y,    x+w, y+h,   u, v,   u2, v,    u2, v2)
				textri(x, y,   x+w, y+h,   x,   y+h,   u, v,   u2, v2,    u, v2)
			end
			ui.add_render_step("nframe",
				function(...)ui.push_render_step("nframe",{...})end,
				function(x,y,w,h,i,bw,s)
					-- i   - sprite index (def 0) (the top left index of the frame)
					-- bw  - border width (def 3)
					-- s   - sprite scale (def 1)
					i,bw,s=i or 0,bw or 3,s or 1
					-- reference:
						--      x     x2               x3
						--    y  ----- ---------------- -----  v
						--      |     |                |     |
						--   y2  ----- ---------------- -----  v2
						--      |     |                |     |
						--      |     |                |     |
						--   y3  ----- ---------------- -----  v3
						--      |     |                |     |
						--       ----- ---------------- -----  v4
						--      u     u2               u3    u4
					local x2,x3,y2,y3=x+bw,x+w-bw,y+bw,y+h-bw
					local cw,ch=x3-x2,y3-y2  -- center w/h

					local UVS=8*s -- uv size

					local u,v=i%16*8,i//16*8
					local u4,v4=u+UVS,v+UVS
					local u2,v2,u3,v3=u+bw,v+bw,u4-bw,v4-bw

					--          x   y      w   h      u1  v1     u2  v2
					_draw_quad( x,  y,     bw, bw,    u,  v,     u2, v2 )  -- top left
					_draw_quad( x3, y,     bw, bw,    u3, v,     u4, v2 )  -- top right
					_draw_quad( x,  y3,    bw, bw,    u,  v3,    u2, v4 )  -- bottom left
					_draw_quad( x3, y3,    bw, bw,    u3, v3,    u4, v4 )  -- bottom right

					_draw_quad( x,  y2,    bw, ch,    u,  v2,    u2, v3 )  -- left
					_draw_quad( x3, y2,    bw, ch,    u3, v2,    u4, v3 )  -- right

					_draw_quad( x2, y,     cw, bw,    u2, v,     u3, v2 )  -- top
					_draw_quad( x2, y3,    cw, bw,    u2, v3,    u3, v4 )  -- bottom

					_draw_quad( x2, y2,    cw, ch,    u2, v2,    u3, v3 )  -- center
				end
			)
		--[[ tiled1 rendering (from 3x1 sprs)       004 ]]
			ui.add_render_step("tiled1",
				function(...)
					ui.push_render_step("tiled1",{...})
				end,
				function(idx,x,y,w,h,ac)
					local i1,i2=idx+1,idx+2
					local tiles_w,tiles_h = w//8,h//8

					clip(x+8,y+8,w-16,h-16)		-- fill background
						for j=0,tiles_h do
							for i=0,tiles_w do
								spr(i2, x+i*8, y+j*8, ac, 1, false, 0)
							end
						end
					clip()
					-- TODO: iirc this doesn't need +1
					clip(x+8,y,w-16+1, h)		-- horizontal borders
						for i=0,tiles_w do
							spr(i1, x+i*8, y,     ac, 1, false, 0)
							spr(i1, x+i*8, y+h-8, ac, 1, false, 2)
						end
					clip()
					clip(x,y+8,w, h-16+1)		-- vertical borders
						for j=0,tiles_h do
							spr(i1, x,     y+j*8, ac, 1, false, 3)
							spr(i1, x+w-8, y+j*8, ac, 1, false, 1)
						end
					clip()
					clip(x,y,w,h)		-- corners
						spr(idx, x,      y,      ac,1,false,0)  -- tl
						spr(idx, x+w-8,  y,      ac,1,false,1)  -- tr
						spr(idx, x+w-8,  y+h-8,  ac,1,false,2)  -- br
						spr(idx, x,      y+h-8,  ac,1,false,3)  -- br
					clip()
				end
			)
		--[[ tiled2 rendering (from 3x2 sprs)       004 ]]
			ui.add_render_step("tiled2",
				function(...)
					ui.push_render_step("tiled2",{...})
				end,
				function(x,y,w,h,idx,ac)
					local tw,th=w//8,h//8  -- width/height in tiles

					local tl,t,bl,b=idx,idx+1,idx+16,idx+1+16
					local ibg=idx+2

					clip(x+8,y+8,w-16,h-16)		-- fill background
						for j=1,th-1 do
							for i=1,tw-1 do
								spr(ibg, x+i*8, y+j*8, ac, 1, 0, 0)
							end
						end
					clip()
					clip(x+8,y,w-16, h)		-- horizontal borders
						for i=0,tw do
							spr(t, x+i*8, y,     ac, 1, 0, 0)
							spr(b, x+i*8, y+h-8, ac, 1, 0, 0)
						end
					clip()
					clip(x,y+8,w, h-16)		-- vertical borders
						for j=0,th do
							spr(b, x,     y+j*8, ac, 1, 0, 1)
							spr(b, x+w-8, y+j*8, ac, 1, 0, 3)
						end
					clip()
					clip(x,y,w,h)		-- corners
						spr(tl, x,      y,      ac,1,0,0)  -- tl
						spr(tl, x+w-8,  y,      ac,1,1,0)  -- tr
						spr(bl, x+w-8,  y+h-8,  ac,1,1,0)  -- br
						spr(bl, x,      y+h-8,  ac,1,0,0)  -- br
					clip()
				end
			)
		--[[ tooltip addon                          004 ]]
			-- TODO: improve. It's still not great
			local _ttp={
				id=_NID,
				txt="",
				on=false,
				timer=0,
				delay=0.25,
				x=0,y=0,
				fg=0,bg=14,
				fw=false,s=1,smf=true,
				ofx=3,ofy=4,
			}
			ui.add_addon(_ttp)
			-- ui._ttp=_ttp

			function _ttp._disable(t)
				t.txt=""
				t.timer=t.delay
				t.on=false
				t.id=_NID
			end

			function _ttp.start_frame(t)
				if t.timer>0 and t.id then
					t.timer=mmoved() and t.delay or t.timer-dt
				end
				-- if not ui._is_cached_hovd(t.id) then -- or ui._is_cached_prsd(ttp.id) then
				-- 	t:_disable()
				-- end
			end

			function _ttp.end_frame(t)
				local item = ui._it_info

				if not item then
					if t.id then t:_disable() end
					return
				elseif t.id == item.id then
					if item.mouse_exited then
						t:_disable()
						return
					end
				end
				if item.pressed then
					t:_disable() -- TODO: this should be just timer reset
					-- t.timer=t.delay
					return
				end

				if not t.id or t.id ~= item.id then
					t:_set_tooltip(item)
				end

				if t.id then
					t:_update_pos()
					if t.timer <= 0 then
						ui.rect(t.x-1, t.y-1, t.tw, 8, t.bg)
						ui.print(t.txt, t.x, t.y, t.fg, t.fw, t.s, t.smf)
					end
				end
			end

			function _ttp._update_pos(t)
				t.x=mx+t.ofx
				t.y=my+t.ofy

				if t.x+t.tw >= 240 then
					t.x = t.x - ((t.x+t.tw) - 240)
				end
				if t.y+8 >= 136 then
					t.y = my-t.ofy -- TODO: test this. Not sure it's good
				end
			end

			function _ttp._set_tooltip(t,item)
				local oid=_ttp.id

				t.id=item.id
				t.txt=item.tip
				t.tw=print(t.txt,nil,nil,0,t.fw,t.s,t.smf)+1
				t.on=true
				t:_update_pos()

				if t.id ~= oid then-- and t.timer <= 0 then
					t.timer=t.delay
				end
			end
