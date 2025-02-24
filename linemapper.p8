pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--liftime functions

speed_multiplier = 1

function _init()
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
	
	 options_ranked = get_options(ci)
 
 	max_rank = 0
 	
 	for o in all(options_ranked) do 
			o.rank  = count(get_options(o))
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
 	if fill_b then
 	  check_for_fill(ci, line_color) 
 	end
 	
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

function get_options(p) 
	 options_final = {}
 	for o in all(get_neighbors(p)) do 
	 	if inbounds(o) then 
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

function inbounds(p) 
	if p.x > 0 and 
		 	p.x < 129 and
		 	p.y > 0 and 
		 	p.y < 129 then
		 	return true
	end
	return false
end

function print_t(t)
	for x=1, count(t) do 
		for y=1, count(t[x]) do
			pset(x - 1, y - 1, t[x][y])
		end
	end
end

function get_neighbors(p)
		x = p.x 
		y = p.y
		neighbors = {}
	 add(neighbors, {x=x+1, y=y})
	 add(neighbors, {x=x,   y=y+1})
		add(neighbors, {x=x-1, y=y})
		add(neighbors, {x=x,   y=y-1})
		return neighbors
end

function merge_tables(t_1, t_2)
	result = {}
	
	for v in all(t_1) do 
		add(result,v)
	end
	
	for v in all(t_2) do 
		add(result,v)
	end

 return result 
end

function contains(t,v)
 for v_in_t in all(t) do 
 	if v_in_t == v then 
 		return true 
 	end
 end
 
 return false

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

-->8
--fill boundaries 
fill_b = true 

-- -1 not set yet 
-- 0 no
-- 1 yes 
-- 2 in progress in call tree
should_be_filled = {}

-- changed point coordinate 
function check_for_fill(point, c_index)
	print("source point p.x"..point.x.."p.y"..point.y)
 
 for x=1, 128 do 
		should_be_filled[x] = {}
		for y=1, 128 do 
			should_be_filled[x][y] = -1
		end
	end
	
	should_be_filled[point.x][point.y] = 1
	
 for p in all(get_neighbors(point)) do
 	print("checking p.x"..p.x.."p.y"..p.y)
 	shouldfill = set_should_be_filled(p,c_index)
 	if shouldfill then 
 		print("yes! should fill")
 		start_fill(p, c_index)
 	end
 end
end

function set_should_be_filled(
p,
c_index
)
 --	print("set should be filled p.x"..p.x.."p.y"..p.y)

 --print_t(should_be_filled)

	if not inbounds(p) then 
		return false
	end
	
	if grid[p.x][p.y] == c_index then 
		should_be_filled[p.x][p.y] = 1
		return true 
	end
	
	if should_be_filled[p.x][p.y] != -1 then 
		if should_be_filled[p.x][p.y] == 1 then 
			return true 
		else 
		 return false	
		end
	end
	
	for n in all(get_neighbors(p)) do
		if not set_should_be_filled(n, c_index) then
			should_be_filled[p.x][p.y] = 0
			return false 			
		end
	end
	
	should_be_filled[p.x][p.y] = 1
	return true  
end

function start_fill(p, c_index)
	print("start_fill p.x"..p.x.." p.y"..p.y)
 if grid[p.x][p.y] == c_index then 
   return 
 end
	grid[p.x][p.y] = c_index
  
	for n in all(get_neighbors(p)) do 
		if not inbounds(n) then 
			return 
		end
		
		if grid[n.x][n.y] != c_index
		then
			start_fill(n, c_index)
		end
	end
	
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
