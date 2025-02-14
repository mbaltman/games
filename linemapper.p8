pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--liftime functions

function _init()
 --rectfill(0,0,124,124,0)
 init_line()
end

function _update() 
	update_line()
end

function _draw()
	draw_line()
end



-->8
--ai line manager
grid = {}
length = 1
ci = {x = 64, y=64}
delay = 5
background = 1

function init_line() 
	for x=1, 128 do 
		grid[x] = {}
		for y=1, 128 do 
			grid[x][y] = background
		end
	end
end

function update_line()
	delay -= 1 
	
	if delay == 0 then 
	
	 options_possible = {}
	 add(options_possible, {x=ci.x+1, y=ci.y})
		add(options_possible, {x=ci.x-1, y=ci.y})
		add(options_possible, {x=ci.x,   y=ci.y+1})
		add(options_possible, {x=ci.x,   y=ci.y-1})

	 options_final = {}
 	for o in all(options_possible) do 
	 	if grid[o.x][o.y] == background then
	 		add(options_final,o)  
	 	end
 	end
 	
 	if count(options_final) == 0 then 
 	return
 	end
 	grid[ci.x][ci.y] = 3
 	ci = pickrnd(options_final)
 	delay = 5
	end
end

function draw_line()
	for x=1,128 do 
		for y=1,128 do 
			grid_color = grid[x][y]
			rect(x-1,y-1,x-1,y-1,grid_color)		
		end
	end
	rect(ci.x-1,ci.y-1,ci.x-1,ci.y-1,11)		

end
-->8
--helper functions 

function rndsgn()
	val = rnd(1)
	if val < 0.33 then 
		return -1
	elseif val < 0.66 then
	 return 0
	else
		return 1
	end
end

function pickrnd(list)
 length = count(list)
 index = 1 + flr(rnd(length))
 return list[index]
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
