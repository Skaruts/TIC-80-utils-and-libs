-- NOTE: shortenings may be redundant in TIC 0.80+

	--[[ common shortenings                        ]]
		local getmt,setmt=getmetatable,setmetatable
		local min,max,floor,ceil=math.min,math.max,math.floor,math.ceil
		local abs,rand=math.abs,math.random
		local huge,sin,cos,PI=math.huge,math.sin,math.cos,math.pi
		local tonum,tostr,fmt=tonumber,tostring,string.format
		local tins,trem,tunpk,tconc,tsort=table.insert,table.remove,table.unpack,table.concat,table.sort

		-- screen / 8x8 grid dimensions
		local SW,SH,GW,GH=240,136,30,17

	-- keys / buttons

	--[[ ALL BUTTONS                               ]] local B0_UA,B1_DA,B2_LA,B3_RA,B4_Z,B5_X,B6_A,B7_S=0,1,2,3,4,5,6,7
	--[[ ALL KEYS                                  ]] local A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,UP,DOWN,LEFT,RIGHT,MINUS,EQUALS,LBRACKET,RBRACKET,BKSLASH,SEMICOLON,APOSTROPHE,GRAVE,COMMA,PERIOD,SLASH,SPACE,TAB,BACKSPACE,RETURN,DELETE,INSERT,PAGEUP,PAGEDOWN,HOME,END,CAPSLOCK,CTRL,SHIFT,ALT = 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,58,59,60,61,37,38,39,40,41,42,43,44,45,46,47,48,49,51,50,52,53,54,55,56,57,62,63,64,65
	--[[ Alpha-numeric keys                        ]] local A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36
	--[[ Alphabet keys                             ]] local A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26
	--[[ Numbers keys                              ]] local N0,N1,N2,N3,N4,N5,N6,N7,N8,N9=27,28,29,30,31,32,33,34,35,36
	--[[ Arrow keys                                ]] local UP,DOWN,LEFT,RIGHT=58,59,60,61
	--[[ Brackets/Symbols                          ]] local MINUS,EQUALS,LBRACKET,RBRACKET,BKSLASH,SEMICOLON,APOSTROPHE,GRAVE,COMMA,PERIOD,SLASH=37,38,39,40,41,42,43,44,45,46,47
	--[[ Whitespace                                ]] local SPACE,TAB,BACKSPACE,RETURN=48,49,51,50
	--[[ Home, end, etc                            ]] local DELETE,INSERT,HOME,END=52,53,56,57
	--[[ PgUp/Dn                                   ]] local PAGEUP,PAGEDOWN=54,55
	--[[ Capslock                                  ]] local CAPSLOCK=62
	--[[ Mod keys                                  ]] local CTRL,SHIFT,ALT=63,64,65

	--[[ All keys/buttons in a table               ]]
		local k={
			B0=0,B1=1,B2=2,B3=3,B4=4,B5=5,B6=6,B7=7, -- up,down,left,right,Z,X,A,S
			A=1,B=2,C=3,D=4,E=5,F=6,G=7,H=8,I=9,J=10,K=11,L=12,M=13,N=14,O=15,
			P=16,Q=17,R=18,S=19,T=20,U=21,V=22,W=23,X=24,Y=25,Z=26,
			N0=27,N1=28,N2=29,N3=30,N4=31,N5=32,N6=33,N7=34,N8=35,N9=36,
			UP=58,DOWN=59,LEFT=60,RIGHT=61,
			MINUS=37,EQUALS=38,LBRACKET=39,RBRACKET=40,BKSLASH=41,SEMICOLON=42,
			APOSTROPHE=43,GRAVE=44,COMMA=45,PERIOD=46,SLASH=47,
			SPACE=48,TAB=49,BKSPACE=51,ENTER=50,
			DELETE=52,INSERT=53,HOME=56,END=57,
			CAPSLOCK=62,
			PGUP=54,PGDN=55,
			CTRL=63,SHIFT=64,ALT=65,
		}

