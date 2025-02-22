pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--liftime functions

speed_multiplier = 20 

function _init()
 --rectfill(0,0,124,124,0)
 init_line()
end

function _update() 
 for i=1,speed_multiplier do 
 	update_line()
 end

end

function _draw()
	draw_line()
	draw_cursor()
end



-->8
--ai line manager
color_options = {
{c=4,h=15},
{c=3,h=11},
{c=2,h=14},
}

color_index = 1

grid = {}
length = 1
ci = {x = 64, y=64}
delay = 1
delay_constant = 5
background = 1

line_color = 3
line_highlight = 11

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
	
	 options_ranked = get_options(ci.x, ci.y)
 
 	max_rank = 0
 	
 	for o in all(options_ranked) do 
			o.rank  = count(get_options(o.x,o.y))
			if grid[o.x][o.y] == 1 then 
			  o.rank += 3
			end
	  max_rank = max(max_rank,o.rank)
		end
		
	 options_final = {}
	 
	 for o in all(options_ranked) do 
	  if o.rank == max_rank then 
	    add(options_final,o)
	  end
	 end
		
 	if count(options_final) == 0 then 
 		increment_index()
 		delay = delay_constant
 		return
 	end
 	
 	grid[ci.x][ci.y] = line_color
 	ci = pickrnd(options_final)
 	delay = delay_constant
	end
end

function draw_line()
	for x=1,128 do 
		for y=1,128 do 
			grid_color = grid[x][y]
			rect(x-1,y-1,x-1,y-1,grid_color)		
		end
	end
	rect(ci.x-1,
						ci.y-1,
						ci.x-1,
						ci.y-1,
						line_highlight)		

end

function increment_index()
   color_index += 1
   if color_index > count(color_options) then 
   	color_index = 1
   end
 		next_color = color_options[color_index]
 		line_color = next_color.c
 		line_highlight = next_color.h
end

function get_options(x,y) 
		options_possible = {}
	 add(options_possible, {x=x+1, y=y})
		add(options_possible, {x=x-1, y=y})
		add(options_possible, {x=x,   y=y+1})
		add(options_possible, {x=x,   y=y-1})
	 options_final = {}
 	for o in all(options_possible) do 
	 	if o.x > 0 and 
	 	   o.x < 129 and
	 				o.y > 0 and 
	 				o.y < 129 then 
		 	if grid[o.x][o.y] != line_color then
		 		add(options_final,o)  
		 	end
	 	end
 	end
 	
 	return options_final
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
-->8
-- cursor controller 

cursor_position = {x=60,y=60}


function draw_cursor()
	rect(cursor_position.x,
						cursor_position.y,
						cursor_position.x,
						cursor_position.y,
						7)		
end
-->8
-- score manager 

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
