	--[[ Bresenham Stuff                       003 ]]
		-- depends on abs (math.abs)
		local Bres={
			line=function(x1,y1,x2,y2,exclude_start)
				exclude_start=exclude_start or false
				local pts,dtx,dty={},x2-x1,y2-y1
				local ix,iy=dtx>0 and 1or-1,dty>0 and 1or-1
				dtx,dty=2*abs(dtx),2*abs(dty)
				if not exclude_start then
					pts[#pts+1]={x=x1,y=y1}
				end
				if dtx>=dty then
					err=dty-dtx/2
					while x1~=x2 do
						if err>0or(err==0 and ix>0)then
							err,y1=err-dtx,y1+iy
						end
						err,x1=err+dty,x1+ix
						pts[#pts+1]={x=x1,y=y1}
					end
				else
					err=dtx-dty/2
					while y1~=y2 do
						if err>0or(err==0 and iy>0)then
							err,x1=err-dty,x1+ix
						end
						err,y1=err+dtx,y1+iy
						pts[#pts+1]={x=x1,y=y1}
					end
				end
				return pts
			end,

			circle=function(xc,yc,r)
				-- TODO: test this
				local pts={}
				-- TODO: are inner functions like these bad?
				local p=function(x,y)pts[#pts+1]={x=x,y=y}end
				local circle=function(xc,yc,x,y)
					p(xc+x, yc+y)
					p(xc-x, yc+y)
					p(xc+x, yc-y)
					p(xc-x, yc-y)
					p(xc+y, yc+x)
					p(xc-y, yc+x)
					p(xc+y, yc-x)
					p(xc-y, yc-x)
				end

				local x,y,d=0,r,3-2*r

				circle(xc,yc,x,y)
				while y>=x do
					x=x+1
					if d>0 then
						y=y-1
						d=d+4*(x-y)+10
					else
						d=d+4*x+6
					end
					circle(xc,yc,x,y)
				end
				return pts
			end
		}

