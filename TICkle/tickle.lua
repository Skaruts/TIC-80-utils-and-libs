--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
--        TICkle IMGUI
--
--  Usage:
--      The rendering is defered to the end of a frame. Rendering functions
--      like 'ui.rect' simply add a render step to the list of steps to be
--      iterated through at frame end. This allows control over when the UI
--      is rendered, and probably makes it a bit more performant, but don't
--      quote me one that.
--
--      So with that in mind, the following functions must be called
--      every frame:
--          ui.start_frame()   - call at frame start, so the GUI can
--                               prepare some stuff and gather user input.
--                               If your widgets use time tracking variables
--                               (e.g. delta time) or anything like that, then
--                               then this function shuold be called after
--                               they're computed.
--          ui.end_frame()     - call at frame end, when there's no more UI
--                               related stuff being done. All rendering is
--                               done here.
--
--      To avoid having mouse input affect your game while the mouse
--      is over the UI, you can do this:
--          if not ui.mouse_on_ui then
--              mouse_handling_func()   -- keep all mouse handling there
--          end
--
--  Dependencies:
--      unpk, setmt, fmt  (common_shortenings.lua)
--      mouse_states      (mouse/mouse_states.lua)
--      dmerge            (table_utils.lua)
--      clip/with_clip    (drawing_utils.lua)
--
--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
	--[[ TICkle Framework                       010 ]]
		-- depends on
		--     unpk, setmt, fmt  (common_shortenings.lua)
		--     mouse_states      (mouse/mouse_states.lua)
		--     dmerge            (table_utils.lua)
		--     clip/with_clip    (drawing_utils.lua)
		--
		-- TODO: find a way to detatch tooltip from ui, to allow user
		--       to implement it however he wants. Make it an extension?
		--       Problem is, the tooltip needs some time-keeping/updating...
		--
		--=--=--=--=--=--=--=--=--=--=--=--
		--       Base Stuff
			-- locked means frozen (e.g. when a modal popup takes over)
			-- inactive means frozen and faded

			local _NID,_NIT,_NOK="NO_ID","NO_ITEM","NO_KEY"
			ui={
				visible=true,
				active=true,
				locked=false,
				mouse_on_ui=false,
				shift=false,
				ctrl=false,
				alt=false,
				info_item=_NIT,
				_rend_steps={},
				_addons={},
				_items={},
				_curr={hovd=_NID,prsd=_NID},
				_prev={hovd=_NID,prsd=_NID},
				_cache={i={},h={},p={}},
				_kb_focus=_NID,
				_key_entered=_NOK,
				_key_char=nil,
				_text_changed=false,
				_it_state_changed=false,
				_timer={
					on=false,
					t=0,
					elapsed=0,
					cooldown=0,
				},
			}

			function ui.add_addon(adn)ui._addons[#ui._addons+1]=adn end

			function ui._push(it)ui._items[#ui._items+1]=it end
			function ui._pop()ui._items[#ui._items]=nil end
			function ui._peek()return ui._items[#ui._items]end

		--=--=--=--=--=--=--=--=--=--=--=--
		--=--=--=--=--=--=--=--=--=--=--=--
		--       State stuff
			function ui.show()ui.visible=true end
			function ui.hide()ui.visible=false end
			function ui.with_visible(b,f)
				local prev=ui.visible
				ui.visible=b
				f()
				ui.visible=prev
			end

			function ui.enable()ui.active=true end
			function ui.disable()ui.active=false end
			function ui.with_active(b,f)
				local prev=ui.active
				ui.active=b
				f()
				ui.active=prev
			end

			function ui.lock()ui.locked=true end
			function ui.unlock()ui.locked=false end
			function ui.with_locked(b,f)
				local prev=ui.locked
				ui.locked=b
				f()
				ui.locked=prev
			end
		--=--=--=--=--=--=--=--=--=--=--=--
		--=--=--=--=--=--=--=--=--=--=--=--
		--       Cache Stuff
			-- item cache - ids (current frame), hovered ids and pressed ids (last frame)
			function ui._cache_item(it)
				-- if ID is claimed, widget is back alive, remove ID (see 'ui.end_frame()')
				if ui._cache.i[it.id]then ui._cache.i[it.id]=nil end
			end

			function ui._is_cached_hovd(id)return ui._cache.h[id]~=nil end
			function ui._is_cached_prsd(id)return ui._cache.p[id]~=nil end

			function ui._cache_hovd(id)ui._cache.h[id]=true end
			function ui._cache_prsd(id)ui._cache.p[id]=true end

			function ui._uncache_hovd(id)ui._cache.h[id]=nil end
			function ui._uncache_prsd(id)ui._cache.p[id]=nil end

		--=--=--=--=--=--=--=--=--=--=--=--
		--=--=--=--=--=--=--=--=--=--=--=--
		--       Rendering Stuff
			function ui.push_render_step(name,args)
				ui._rend_steps[#ui._rend_steps+1]={name,args}
			end

			ui._rend_step_fns={
				rect=rect,
				rectb=rectb,
				line=line,
				print=print,
				spr=spr,
				clip=clip,
			}

			function ui.add_render_step(nm,rs,rsf)
				ui[nm]=rs
				ui._rend_step_fns[nm]=rsf
			end

			function ui.rect(...)ui.push_render_step("rect",{...})end
			function ui.rectb(...)ui.push_render_step("rectb",{...})end
			function ui.line(...)ui.push_render_step("line",{...})end
			function ui.print(...)ui.push_render_step("print",{...})end
			function ui.spr(...)ui.push_render_step("spr",{...})end
			function ui.clip(...)
				local b = {...}
				ui._peek().bounds=b
				ui.push_render_step("clip",b)
			end

			function ui.with_clip(x,y,w,h,f,...)
				ui.clip(x,y,w,h)
				f(...)
				ui.clip()
			end
		--=--=--=--=--=--=--=--=--=--=--=--
		--=--=--=--=--=--=--=--=--=--=--=--
		--       Loop Stuff
			function ui._run_addons(fname)
				for _,addon in ipairs(ui._addons) do
					local f=addon[fname]
					if f then f(addon,it) end
				end
			end

			ui._uchars,ui._chars=
				'ABCDEFGHIJKLMNOPQRSTUVWXYZ=!"#$%&/()_ «»?|;:',
				"abcdefghijklmnopqrstuvwxyz0123456789- <>\\'~`,.  "

			function ui._input(event)
				ui.shift=key(64)
				ui.ctrl=key(63)
				ui.alt=key(65)
				-- ui.tab=keyp(49)

				for i=1,62 do
					if keyp(i, 25, 5) then
						ui._key_entered=i

						-- TODO: problem: TIC's keycodes are incomplete and
						--       incompatible with foreign keyboards,
						--       so receiving text input is limited
						if i <= 48 then
							ui._key_char=(ui.shift and ui._uchars:sub(i,i) or ui._chars:sub(i,i))
						end
					end
				end
				-- monitor("key: ", ui._key_entered)
				-- monitor("char: ", ui._key_char)
				ui._run_addons("input")
			end

			function ui.start_frame()
				ui._input()

				ui.mouse_on_ui=false
				ui._timer.elapsed=ui._timer.elapsed+dt

				if ui._timer.count then
					ui._timer.t=ui._timer.t+dt
					ui._timer.cooldown=ui._timer.cooldown-dt
				end

				if not ui._cache.h[ui.info_item.id]then
					ui.info_item=_NIT
				end

				ui._run_addons("start_frame")
			end

			function ui._render()
				if ui.visible then
					local unpk,_rend_step_fns=unpk,ui._rend_step_fns
					for _,v in ipairs(ui._rend_steps)do
						_rend_step_fns[v[1]](unpk(v[2]))
					end
					ui._rend_steps={}
				end
			end

			function ui.end_frame()
				ui._run_addons("end_frame")

				ui._render()

				if m1 and(ui._curr.prsd==_NID or ui._curr.hovd==_NID)then
					ui._kb_focus=_NID
				end

				if not m1 then
					ui._curr.prsd=_NID
					ui._prev.prsd=_NID
				else
					if ui._curr.prsd==_NID then
						ui._curr.prsd=_NIT   -- this helps telling when mouse is down but no item is clicked
					else
						if ui._curr.prsd~=ui._kb_focus then
							ui._kb_focus=_NID
						end
					end
				end
				-- -- if no widget grabbed tab, clear focus
				if ui._key_entered==49 then -- TAB
					ui._kb_focus=_NID
				end
				ui._key_entered=_NOK
				ui._key_char=nil
				ui._text_changed=false
				if ui._curr.hovd==_NID then
					ui._prev.hovd=_NID
					if ui._curr.prsd==_NID and ui._kb_focus==_NID then
						ui._it_state_changed=false
					end
				end

				-- ---- HOUSEKEEPING -----------------------------------
				-- IDs cached at this point are those that haven't been claimed
				-- by any _items this frame in 'ui._new_item()'. That means
				-- they're orfan IDs from innactive ui items (hidden, gone, etc)
				-- and should be removed here.

				-- clean up orfan IDs
				for id,_ in pairs(ui._cache.i)do
					if ui._cache.h[id]then ui._cache.h[id]=nil end
					if ui._cache.p[id]then ui._cache.p[id]=nil end
				end
				-- gather what's left for next frame
				ui._cache.i=dmerge(ui._cache.h,ui._cache.p)

				------- HOUSEKEEPING DEBUG --------
				-- local hk_str = ""
				-- local lhi_str = ""
				-- local lpi_str = ""
				-- for k,_ in pairs(ui._cache.i) do hk_str = hk_str .. " | " .. tostring(k) end
				-- for k,_ in pairs(ui._cache.h) do lhi_str = lhi_str .. " | " .. tostring(k) end
				-- for k,_ in pairs(ui._cache.p) do lpi_str = lpi_str .. " | " .. tostring(k) end

				-- monitor("ui._cache.i    ", hk_str, 22)
				-- monitor("ui._cache.h  ", lhi_str, 22)
				-- monitor("ui._cache.p  ", lpi_str, 22)
			end
		--=--=--=--=--=--=--=--=--=--=--=--
		--=--=--=--=--=--=--=--=--=--=--=--
		--       Item Stuff
			function ui._make_id(it)
				if it.parent then return it.parent.id.."."..it.id end
				return it.id
			end

			function ui.begin_item(id,x,y,w,h,op)
				return ui._new_item(id,x,y,w,h,op)
			end

			function ui.end_item(it)
				if it.hovered then it:_set_as_last_hovered(true)end
				if it.pressed and it.hovered then it:_set_as_last_pressed(true)end
				ui._pop()
			end

			function ui.with_item(id,x,y,w,h,op,f)
				if ui.visible then
					local t=ui.begin_item(id,x,y,w,h,op)
						if ui.is_under_mouse(t.gx,t.gy,w,h) then
							ui.mouse_on_ui=true
						end
						f(t, t.args and unpk(t.args) or nil)-- -1)
					ui.end_item(t)
					return t
				end
			end

			function ui._set_none_hovered()ui._curr.hovd=_NID end
			function ui._set_none_pressed()ui._curr.prsd=_NID end
			function ui._is_none_pressed()return ui._curr.prsd==_NID end

			local _IDX_LUT = {
				-- global position
				gx=function(t)return t.parent and t.parent.gx+t.x or t.x end,
				gy=function(t)return t.parent and t.parent.gy+t.y or t.y end,
			}
			local Item={}
			local _ITMT={
				__index=function(t,k)
					if Item[k]~=nil then return Item[k]end
					return _IDX_LUT[k]and _IDX_LUT[k](t)
						or nil
				end,
				__tostring=function(t) -- only for debugging
					return fmt("%s(%s,%s,%s,%s,",t.id,t.gx,t.gy,t.w,t.h)
						.. fmt("\n  hovered: %s",t.hovered)
						-- .. fmt("\n  m_enter: %s", t.mouse_entered)
						-- .. fmt("\n  m_exit:  %s", t.mouse_exited)
						-- .. fmt("\n  held:    %s", t.held)
						-- .. fmt("\n  pressed: %s", t.pressed)
						-- .. fmt("\n  release: %s", t.released)
						.. "\n)"
				end,
			}
			function ui._new_item(id,x,y,w,h,op)
				op=op or {}
				local t=setmt({id=id,x=x,y=y,w=w,h=h},_ITMT)

				if #ui._items>0 then t.parent=ui._peek()end
				ui._push(t)
				t.id=ui._make_id(t)

				if ui.active then
					t.hovered=ui._is_cached_hovd(t.id)
					t.held=ui._is_cached_prsd(t.id)
				end
				ui._cache_item(t)

				if type(op)=="function"then op={code=op}end
				for k,v in pairs(op)do
					t[k]=v
				end
				return t
			end

			function ui.is_under_mouse(x,y,w,h)
				return mx>=x and mx<x+w
				   and my>=y and my<y+h
			end

			function ui.has_kb_focus(id)
				return ui._kb_focus==id
			end

			function Item._set_as_last_hovered(t,enable)
				if enable then
					ui._prev.hovd=t.id
					if not ui._is_cached_hovd(t.id)then
						ui._cache_hovd(t.id)
					end
				else
					ui._uncache_hovd(t.id)
				end
			end

			function Item._set_as_last_pressed(t,enable)
				if enable then
					ui._prev.prsd=t.id
					if not ui._is_cached_prsd(t.id) then
						ui._cache_prsd(t.id)
					end
				else
					ui._uncache_prsd(t.id)
				end
			end

			function Item._is_last_hovered(t)
				return ui._prev.hovd==t.id
					or ui._is_cached_hovd(t.id)
			end

			function Item._is_last_pressed(t)
				return ui._prev.prsd==t.id
					or ui._is_cached_prsd(t.id)
			end

			function Item.check_hovered(t,x,y,w,h)
				if not ui.locked and ui.active then
					if ui.is_under_mouse(x,y,w,h)then
						if not t.hovered and (ui._is_none_pressed() or t.held) then
							t.hovered=true
							ui._curr.hovd=t.id
						end
						if t.hovered then
							if not t:_is_last_hovered() then
								t.mouse_entered=true
								if t.tip then ui.info_item=t end
							end
							return true
						end
					else
						t.hovered=false
						if ui._curr.hovd==t.id then
							ui._set_none_hovered()
						end
						if t:_is_last_hovered()or t:_is_last_pressed()then
							t.mouse_exited=true
							t:_set_as_last_hovered(false)
						end
					end
				else
					t.hovered = false
					t:_set_as_last_hovered(false)
				end
				return false
			end

			function Item.check_pressed(t)
				if not ui.locked and ui.active then
					if m1 then
						if t.held then return true end
						if t.hovered and ui._is_none_pressed()then -- and not t.held then
							ui._curr.prsd=t.id
							if not t:_is_last_pressed() then
								t.pressed=true
							else
								t.held=true
							end
							return true
						end
					else
						if t.held then
							if ui._curr.prsd==t.id then
								ui._set_none_pressed()end
							t.held=false
							if t:_is_last_pressed()then
								t:_set_as_last_pressed(false)
								if t.hovered then
									t.released=true
								end
							end
						end
					end
				else
					t.pressed = false
					t.held = false
					t:_set_as_last_pressed(false)
				end
				return false
			end
		--=--=--=--=--=--=--=--=--=--=--=--
