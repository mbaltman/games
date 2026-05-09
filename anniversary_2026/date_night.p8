pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- main loop
game_state = -1
-- -1: not set yet
-- 0:start screen
-- 1:anania's room
-- 2:date
-- 3:letter

function _init()
	set_palette()
	show_ss()
	music(0, 10000)
end

function show_ss()
game_state =0
run_animation(s_animations, animate_sign_down)
end

function start_game()
	is_sleeping = true
	a_outfit_sprite = 113
	a_hair_sprite = 98
	a_hair_offset = 3
 
	a_pos = {x=31,y=30}

	game_state =1
	run_animation(a_animations,wakeup_routine)
end

function start_date()
	a_pos.x = 21
	a_pos.y = 16
	is_sleeping = false
	alarm_is_beeping = false
	game_state =2
	text[1] = "maxwell is waiting for you."
end

function show_letter()
game_state =3
end

function _update()
  if(game_state == 0) then
			update_start_screen()
  elseif(game_state == 1) then
			update_anania_position()
	 elseif(game_state == 2)then
   update_anania_position()
   update_date()
  elseif(game_state ==3)then
   update_letter()
  end
end

function _draw()
  if(game_state == 0) then
   draw_startscreen()
  elseif(game_state ==1) then
  	draw_room_bg()
  	draw_anania()
  	draw_room_fg()
  elseif(game_state ==2)then
   draw_date_bg()
   draw_anania()
   draw_date_fg()
  elseif(game_state ==3)then
   draw_letter()
  end
end


function draw_palette()
	rectfill(0,0,128,128,0)
	for i =0,15 do
		rectfill(0,4 * i, 4, 4* (i+1),i)
	end
end

function set_palette()
	poke(0x5f2c, 0x40)
	pal(0,0, 1)
	pal(1,128, 1)
	pal(2,132, 1)
	pal(3,130, 1)
	pal(4,133, 1)
	pal(5,141, 1)
	pal(6,134, 1)
	pal(7,129, 1)
	pal(8,140, 1)
	pal(9,131, 1)
	pal(10,3, 1)
	pal(11,136, 1)
	pal(12,137, 1)
	pal(13,142, 1)
	pal(14,143, 1)
	pal(15,15, 1)
end	



-->8
-- start screen
s_animations = {}
can_see_button = false

function update_start_screen()
	process_animations(s_animations)
	
	if(can_see_button) then
		if(btn(4)) then
			run_animation(s_animations, animate_sign_up)
		 run_animation(s_animations, fadeout_ss_routine)

		end
 end
end

function draw_startscreen()
	rectfill(0,0,128,128,7)
	draw_stars()
	draw_fadeout(fadeout_pixels,0)
	draw_sign()
 draw_start()
 is_sleeping = false
 a_outfit_sprite = 115
 a_hair_sprite = 71
 a_hair_offset = 0
 
 a_pos.x = 30
 a_pos.y = 80
 draw_anania()
 draw_maxwell(80,80)
  spr(167,55,80,2,2) 

end

sign_pos={x=40,y=-50}
sign_speed = 2
sign_frame = 0

function animate_sign_down()
	sign_frame = 0
	while sign_pos.y< -5 do
		sign_frame += 1
			if(sign_frame % sign_speed == 0) then 
				sign_pos.y +=1
			end
		yield()
	end
	can_see_button = true
end

function animate_sign_up()
	can_see_button = false
	sign_frame = 0
	while sign_pos.y > - 90 do
		sign_frame += 1
			if(sign_frame % sign_speed == 0) then 
				sign_pos.y -=1
			end
		yield()
	end
end



function draw_sign()
	
	-- sign cables
	rectfill(sign_pos.x,sign_pos.y, sign_pos.x + 1, sign_pos.y + 30,0)
	rectfill(sign_pos.x + 40 ,sign_pos.y, sign_pos.x + 41, sign_pos.y + 30,0)
 --sign
 rectfill(sign_pos.x-20, sign_pos.y+30,sign_pos.x+65,sign_pos.y+55,12)
 rectfill(sign_pos.x-4, sign_pos.y+55,sign_pos.x+47,sign_pos.y+70,12)

 -- rounded corners 
 spr(134, sign_pos.x-20,sign_pos.y+30,1,1,false,true)
 spr(134, sign_pos.x+58,sign_pos.y+30,1,1,true,true)
 spr(134, sign_pos.x-20,sign_pos.y+48,1,1,false,false)
 spr(134, sign_pos.x+58,sign_pos.y+48,1,1,true,false)

 spr(134, sign_pos.x-4,sign_pos.y+63,1,1,false,false)
 spr(134, sign_pos.x+40,sign_pos.y+63,1,1,true,false)


 l_pos= {x=sign_pos.x-18, y=sign_pos.y+35}
 --letters
 --a
 spr(128,l_pos.x,l_pos.y,1,2)
 spr(128,l_pos.x+8,l_pos.y,1,2,true,false)
 --n
 spr(130,l_pos.x+15,l_pos.y,2,2)
 --a
 spr(128,l_pos.x+25,l_pos.y,1,2)
 spr(128,l_pos.x+33,l_pos.y,1,2,true,false)
 --n
 spr(130,l_pos.x+40,l_pos.y,2,2)
 --i
 spr(131,l_pos.x+51,l_pos.y,1,2)
 --a
 spr(128,l_pos.x+54,l_pos.y,1,2)
 spr(128,l_pos.x+62,l_pos.y,1,2,true,false)
 --'s
 spr(132,l_pos.x+64,l_pos.y,2,2)

 -- date night 

 spr(160,l_pos.x + 18, l_pos.y + 22,6,2)
end

function draw_start()
 if(not can_see_button)then
   return
 end 
 ss_pos = {x=46,y=100,w=30,h=10}
 
 rectfill(ss_pos.x,ss_pos.y,ss_pos.x + ss_pos.w, ss_pos.y+ss_pos.h,3)
 print("start",ss_pos.x + 6,ss_pos.y+3,15)
end


-- (x,y,is_on,frame_count_to_state_change)
star_coords = {
{5,5,true,50},
{7,70,true,100},
{10,7,true,200},
{10,65,true,250},
{12,58,true,230},

{25,3,true,80},

{30,110,true,120},
{36,117,true,100},

{40,80,true,220},

{50,70,true,180},
{60,45,true,180},


{100,20,false,80},
{110,6,true,300},

{100,100,false,80},
{104,120,true,20},
}
function draw_stars()
  for coord in all(star_coords) do 
    should_decrease = rnd(20)
    if(should_decrease < 18) then 
  		coord[4] -= 1
  		  if(coord[4] <= 0)then
  		  	coord[3] = not coord[3]
  		  	if (coord[3]) then
  		  		coord[4] = 180 + rnd(180)
  		  	else 
  		  	 coord[4] = 6 + rnd(3)
  		  	end
  		  end
  		end
  		
  		if( coord[3]) then
  			pset(coord[1],coord[2],15)
    end
  end
end

fadeout_pixels = {}
fadeout_pool = {}

function fadeout_ss_routine()
	wait_for(60)	
	fadeout_pixels = {}
	fadeout_pool = {}
	fadeout_routine(fadeout_pool,fadeout_pixels)
	wait_for(15)	
	start_game()
	fadeout_pixels = {}
	fadeout_pool = {}
end
-->8
-- anania
a_pos = {x=31,y=30}
a_speed = 0
a_curr_frame = 0

is_sleeping = true
is_sitting = false
is_wearing_glasses = false
a_animations = {}

a_outfit_sprite = 113
a_hair_sprite = 98
a_hair_offset = 3

function update_anania_position()
 process_animations(a_animations)
 
 if(is_sleeping or is_sitting) then 
  return 
 end
 
 a_curr_frame +=1
	a_curr_frame = a_curr_frame % (a_speed * 2)
	if(a_curr_frame != 0) then 
	 return 
	end
	local new_a_pos = {x=a_pos.x, y=a_pos.y}

	
	if(btn(0)) then
	  new_a_pos.x -= 1
	elseif(btn(1)) then
		 new_a_pos.x += 1
	elseif(btn(2)) then
		 new_a_pos.y -= 1
	elseif(btn(3)) then
		 new_a_pos.y += 1
	end
	
	local walkable_square_cp = nil
	-- square containing point
	if(game_state == 1) then 
		walkable_square_cp = point_is_in_squares(new_a_pos, walkable_squares)
	else 
			walkable_square_cp = point_is_in_squares(new_a_pos, walkable_squares_date)
	end
	if(walkable_square_cp != nil) then
	a_pos.x = new_a_pos.x
	a_pos.y = new_a_pos.y
	end
	
	local interactive_square_cp = nil
	if(game_state == 1) then 
		interactive_square_cp = point_is_in_squares(a_pos, interactive_squares)
 else 
 	interactive_square_cp = point_is_in_squares(a_pos, interactive_squares_date)
 end
 if(interactive_square_cp != nil) then
			interactive_square_cp[5]()
		if(btn(4)) then 
			interactive_square_cp[6]()
		end
	else 
		text[2] = ""
	end
end

function draw_anania()
	palt(0,false)
	palt(15,true)
 spr(face_sprite(),a_pos.x, a_pos.y,1,1)
 spr(face_sprite(),a_pos.x + 7, a_pos.y,1,1, true, false)
 
 spr(112,a_pos.x, a_pos.y+8,1,1)
 spr(112,a_pos.x + 7, a_pos.y+8,1,1, true, false)
 
 palt(0,false)

 spr(a_outfit_sprite,a_pos.x, a_pos.y+ 8,1,1)
 spr(a_outfit_sprite,a_pos.x + 7, a_pos.y + 8,1,1, true, false)
 
 draw_hair()
 
 if(is_wearing_glasses) then 
 	spr(119,a_pos.x, a_pos.y)
 	spr(119,a_pos.x + 7, a_pos.y,1,1,true,false)
 end 
 
 palt()
end

function draw_hair()
	spr(a_hair_sprite,a_pos.x, a_pos.y + a_hair_offset,1,1)
	spr(a_hair_sprite,a_pos.x + 7, a_pos.y + a_hair_offset,1,1,true, false)
end

function face_sprite()
	if (is_sleeping) then
		return 97
	end
		return 96	
end

function wakeup_routine()
 wait_for(30)
 
 text[1] = "z"
 
 for j = 1,10 do
  wait_for(30)
 	text[1] ..= "z"
 end
 
 wait_for(15)

 text[1] = "good morning!"

 alarm_is_beeping = true
 music(-1)
 sfx(11,3)
 is_sleeping = false
 wait_for(120)
 if(alarm_is_beeping) then
 	text[1] = "turn off your alarm"
 end
end

function is_dressed()
	return a_outfit_sprite != 113
end


function hair_done()
	return a_hair_sprite != 98
end




-->8
-- anania's room			

bed_pos = {x = 18,y = 25}

alarm_is_beeping = false
walkable_squares = {
{4,30,60,32}, -- get out of bed
{4,30,5,80}, -- rug to left of bed
{46,27,98,80}, -- rug to right of bed
{6,55,98,80}, -- rug under bed

{96,80,116,88} --hallway
}

interactive_squares = {

}

function hallway_button_pressed()
 if(not is_dressed() or not hair_done()) then 
 	return 
 end 
 start_date()
end

function set_hallway_text()
 if(alarm_is_beeping) then 
 	return 
 elseif(not is_dressed()) then 
   text[2] = "no clothes?"
 elseif(not hair_done()) then 
   text[2] = "in your bonnet?"
 else 
   text[2] = " press a to go on date" 
 end
end

add(interactive_squares,{100,80,128,96, set_hallway_text, hallway_button_pressed})


function draw_room_bg()
	-- room 
	rectfill(0,0,128,128,0)
	rectfill(3,3,124,106,6)
	rectfill(0,60,2,95,7)
	rectfill(3,32,124,106,4)
	
	--rug
	rectfill(6,34,119,105,1)
	spr(3,6,34)
	spr(3,6,98,1,1,false,true)
	spr(3,112,98,1,1,true,true)
	spr(3,112,34,1,1,true, false)
	rectfill(100,85,128,100,1)


	-- wall decorations
	spr(0,13,7) -- a
	  --records
	pal(15,8)
	spr(4,30,6)
	pal(15,10)
	spr(4,25,13)
	pal(15,11)
	spr(4,78,8)
	pal(15,12)
	spr(4,71,14)
	pal(15,10)
	spr(4,80,19)
	pal(15,143)

	-- furniture
	spr(1,4,22,2,2) --flower table
	spr(16,8,20) -- bottles
	spr(36,48,26,2,2) -- side tables
	
	palt(0,false)
	palt(15,true)
	draw_alarm_clock()
	spr(5,40,6,4,2) -- wigs 
	palt()
	
	spr(9,105,6,2,2) -- poster
	spr(41,90,9,2,2) -- mannequin
 spr(38,70,30,3,2) -- chest
	-- bed
	spr(32,bed_pos.x,bed_pos.y,4,2)
	
	draw_fan()
	draw_desk()
	
	draw_text()
	
 -- draw_squares(walkable_squares)
end

function draw_room_fg()
	spr(64,bed_pos.x,bed_pos.y+16,4,2)

	draw_closet()
	draw_clothes()
end

fan_speed = 15
curr_frame = 0
function draw_fan()
	curr_frame += 1
	curr_frame = curr_frame % (fan_speed * 2) 
	blade_sprite = 43
	if (curr_frame < fan_speed) blade_sprite = 45
	
	spr(blade_sprite,100,25,2,2) -- blades
	spr(11,100,25,2,2) -- case
end

function draw_desk()
	spr(13,100,54,1,2) -- chair
 spr(68,112,50,2,4) -- desk
end


beep_frame = -1 
beep_speed = 15
beep_on = false

function draw_alarm_clock()
	if(alarm_is_beeping) then
	  beep_frame += 1
	  beep_frame = beep_frame % 10
	  if(beep_frame == 0) then 
	   beep_on = not beep_on
	  end
	else 
	  beep_on = false
	end
	
	if(not beep_on) then
	pal(11,0)
	end
	spr(14,50,22,2,1)	
	pal(11,11)
end

function stop_alarm()
	sfx(-1,3)
	music(0, 10000)
 alarm_is_beeping = false
 text[1] = "get ready for your date"
end

function set_alarm_text()
  if(alarm_is_beeping) then 
  text[2] = "press a to snooze"
  else
  text[2] = ""
  end
end

add(interactive_squares,{46,27,50,29, set_alarm_text, stop_alarm})

c_pos = {x=10,y=84,h=20,w=80}
function draw_closet()
	-- first pole
	rectfill(c_pos.x, c_pos.y, c_pos.x + 2, c_pos.y + c_pos.h, 3)
 line(c_pos.x, c_pos.y + 2, c_pos.x + c_pos.w, c_pos.y + 2, 3)
 
 -- center poles
 line(c_pos.x + 30, c_pos.y + 2, c_pos.x + 30, c_pos.y +c_pos.h, 3)
 line(c_pos.x + 50, c_pos.y + 2, c_pos.x + 50, c_pos.y +c_pos.h, 3)
 -- shelf 
 line(c_pos.x + 30, c_pos.y + c_pos.h -2, c_pos.x + 50, c_pos.y +c_pos.h - 2, 3)
 line(c_pos.x + 30, c_pos.y + c_pos.h -6, c_pos.x + 50, c_pos.y +c_pos.h - 6, 3)
 rectfill(c_pos.x+31,c_pos.y + c_pos.h-5, c_pos.x + 49, c_pos.y +c_pos.h -3, 4)
 -- last pole
 rectfill(c_pos.x + c_pos.w , c_pos.y, c_pos.x + c_pos.w + 2, c_pos.y + c_pos.h, 3)

end

add(interactive_squares,
{3,20,15,35, 
function() text[2] = "do you need lube right now?"end, 
function() end})

-->8
-- ananias clothes 

-- sprite index, show_on_hanger, x,y, 
clothes = {
	{114, true, 10,87},-- pink dress
	{115, true, 20,87},-- overalls
	{99,  true, 30,87},-- striped dress
	{86,  true, 50,87},-- cowboy
	{102,  true, 60,87},-- jeans + t shirt
	{118,  true, 70,87},-- skirt + shirt
}

wig_index = 0

wigs = {
	{70, 3},-- straight
	{71, 0},-- afro
	{87, 2},-- natural

}

function draw_clothes()
	spr(19,15,85)
	spr(19,25,85)
	spr(19,35,85)
	spr(19,55,85)
	spr(19,65,85)
	spr(19,75,85)
	
	palt(0,false)
	palt(15,true)

	for outfit in all(clothes) do 
		if(outfit[2]) then 
			spr(outfit[1],outfit[3],outfit[4])
			spr(outfit[1],outfit[3]+ 8,outfit[4],1,1,true,false)

		end
	end
 palt()
end

function set_clothes_text()
  if(alarm_is_beeping) then 
    return 
  end
  
  text[2] = "press a to pick outfit"
end

function pick_outfit(index)
  if(alarm_is_beeping) then 
    return 
  end
  a_outfit_sprite = clothes[index][1]
  clothes[index][2] = false
  
  for outfit in all(clothes) do
  	if(outfit[1] != a_outfit_sprite) then
  	  outfit[2] = true
  	end
  end
  
end

add(interactive_squares,
{10,75,16,80, 
set_clothes_text, 
function() pick_outfit(1) end })

add(interactive_squares,
{20,75,26,80, 
set_clothes_text, 
function() pick_outfit(2) end })

add(interactive_squares,
{30,75,36,80, 
set_clothes_text, 
function() pick_outfit(3) end })

add(interactive_squares,
{50,75,56,80, 
set_clothes_text, 
function() pick_outfit(4) end })

add(interactive_squares,
{60,75,66,80, 
set_clothes_text, 
function() pick_outfit(5) end })

add(interactive_squares,
{70,75,76,80, 
set_clothes_text, 
function() pick_outfit(6) end })


function show_desk_text()
  text[2] = "press a to change hair"
end

wig_just_changed = false

function wait_for_wig()
wig_just_changed = true
wait_for(10)
wig_just_changed = false
end

function desk_button_pressed()
	run_animation(a_animations,wait_for_wig)

  if(wig_just_changed) then 
  	return 
  end
  
  wig_index += 1
  if(wig_index > #wigs) then 
  	wig_index = 1
  end
  a_hair_sprite = wigs[wig_index][1]
  a_hair_offset = wigs[wig_index][2]

end

add(interactive_squares,
{90,47,100,52, 
show_desk_text, 
desk_button_pressed})

-->8
-- coroutine helpers 

function wait_for(frame_count)
	for i = 1,frame_count do
 	yield()
 end
end

function process_animations(p_animations)
	for c in all(p_animations) do
    if costatus(c) then
      coresume(c)
    else
      del(p_animations,c)
    end
  end
end

function run_animation(p_table, p_animation)
c = cocreate(p_animation)
add(p_table,c)
end
-->8
-- collider helpers 
-- point {x,y}
-- square {x1,y1,x2,y2}

-- check if point is in the square
function point_is_in_square(p_point, p_square)
	if(p_point.x >= p_square[1] and 
	   p_point.x <= p_square[3] and
	   p_point.y >= p_square[2] and
	   p_point.y <= p_square[4]) then 
		return true 
	end
	return false   
end

-- check if point is in one of the squares
-- returns the square
function point_is_in_squares(p_point,p_squares)
 for square in all(p_squares) do
		if point_is_in_square(p_point,square) then 
			return square
  end		
 end
 return nil
end

-- draw outlines of all the squares
function draw_squares(p_squares)
 for square in all(p_squares) do
   rect(square[1],square[2],square[3],square[4],0)
 end
end


-->8
-- date


walkable_squares_date = {
{20,16,22,30},-- doorway 
{2,26,85,38},-- top of room
{70,20,100,30},-- walk up to paintings
{1,35,2,70},-- left side of room
{57,35,90,55},-- upper right of room
{80,54,110,56},-- near maxwell
{58,54,73,90},-- middle of room
{1,84,60,90},-- bottom of room left
{60,75,110,85},-- bottom of room right
{2,50,70,70},-- between tables
}

interactive_squares_date = {

}

d_animations = {}
function update_date()
	process_animations(d_animations)
end


function draw_date_bg()
	-- room 
	rectfill(0,0,128,128,0)
	rectfill(3,3,124,106,3)
	rectfill(3,32,124,106,1)
	
	-- employee door 
	rectfill(20,3,37,31,1)
	rectfill(21,4,36,30,4)
	spr(103,25,7)

 -- paintings 
 spr(77,70,6,2,2)
 
 spr(110,100,6,2,2)

	-- plants 
	draw_pot(5,30,1)
	draw_pot(55,27,3)
	
	if(a_pos.y > 30) then 
		draw_pot(100,40,2)
	end
	
	-- draw tables 
	if(a_pos.y > 40) then 
		draw_table_set(20,50)
	end
	if(a_pos.y > 60) then 
		draw_table_set(80,68)
		draw_maxwell(104,62)
	end
	if(a_pos.y > 76) then 
		draw_table_set(17,82)
	end

 --draw_squares(walkable_squares_date)

	draw_text()
end

function draw_date_fg()

	if(a_pos.y <= 30) then 
		draw_pot(100,40,2)
	end

	if(a_pos.y <= 40) then 
		draw_table_set(20,50)
	end
	if(a_pos.y <= 60) then 
		draw_table_set(80,68)
		draw_maxwell(104,62)
	end
	if(a_pos.y <= 76) then 
		draw_table_set(17,82)
		draw_maxwell(104,62)
	end
	
		-- more plants 
	draw_pot(108,96,4)
	
	draw_date_fade_out()

end


function draw_pot(x,y, variation)
	spr(72,x,y,1,2)
	spr(72,x+8,y,1,2,true,false)
	if(variation == 1) then 
		spr(73,x + 5, y - 12, 1,2)
	elseif(variation == 2) then 
		spr(104,x,y-7,2,2)	
	elseif(variation ==3) then 
		spr(74,x-13,y-21,3,3)	
	elseif(variation == 4 ) then
			spr(122,x-4,y-15,3,3)	
	end
end

function draw_table_set(x,y)
 --chairs
	spr(13,x-4,y -3,1,2)
	spr(13,x+28,y -3,1,2,true,false)
	
	--table	
	spr(135,x,y,2,2)
	spr(135,x+ 16,y,2,2,true,false)
end

function draw_maxwell(x,y)
	palt(3,true)
	palt(0,false)
	spr(143,x,y,1,2)
	spr(143,x+7,y,1,2,true,false)
	
	palt()
end


add(interactive_squares_date,
{70,20,100,25, 
function() text[2]= "wow look at that painting" end, 
function() end })

add(interactive_squares_date,
{80,30,120,40, 
function() text[2]= "i ♥ bush" end, 
function() end })

function date_convo_started()
			run_animation(d_animations, animate_show_letter)
end

add(interactive_squares_date,
{70,60,80,70, 
function() text[2]= "press a if you still like him" end, 
date_convo_started})


d_fadeout_pixels = {}
d_fadeout_pool = {}

function animate_show_letter()
	is_sitting=true
	a_pos.x = 75
	a_pos.y = 62
	wait_for(10)
	show_maxwells_heart = true
	wait_for(45)
	show_ananias_heart = true 
	wait_for(100)
	d_fadeout_pixels = {}
	d_fadeout_pool = {}
	fadeout_routine(d_fadeout_pool,d_fadeout_pixels)

	wait_for(45)	
	show_letter()
	d_fadeout_pixels = {}
	d_fadeout_pool = {}
end


show_maxwells_heart = false
show_ananias_heart = false

function draw_date_fade_out()
	if (show_maxwells_heart) then
	spr(167,103,48,2,2) 
	end
	
	if (show_ananias_heart) then 
 spr(167,74,48,2,2) 
 end
 
 draw_fadeout(d_fadeout_pixels,15)
end
-->8
-- text display 

text = {"",""}
function draw_text()
	-- text field
	rectfill(0,110,128,128,14)
	print(text[1], 3,112,0)
	print(text[2], 3,120,0)
end


-->8
-- letter
letter = {
"sometimes things feel ",
"really complicated.",
"i feel",
"   distracted,",
"   overwhelmed,",
"   indecisive.",
" " ,
"one thing i love about pico8",
"games is how simple they are.",
"its all:",
"   0s and 1s",
"   true or false",
"   on or off",
"   up down left right b a start",
"",
"i know real life is messy,", 
"and fuzzy,",
"and not so black and white.",
"",
"but when i am with you",
"i don't worry about it as much.",
"when i am with you, certain",
"things feel that simple.",
"",
"these past two years",
"have genuinely been the",
"happiest of my life.",
"",
"i love you,",
"",
"maxwell"
}

scroll = 120	

function draw_letter()
	rectfill(0,0,128,128,15)

	local index = 0 
	for text_line in all(letter) do
		print(text_line,1,(index * 8) + scroll,0)
		index += 1
	end

end

function update_letter()
	if(btn(2)) then 
	scroll -= 1
	
	elseif(btn(3)) then
		scroll += 1
	end
	
	if (scroll >120) then 
	 scroll = 120 
	end
end
-->8
-- fade out helpers 

function fadeout_routine(p_pool, p_pixels)
 -- reset 
	for i = 0,127 do 
		for j = 0,127 do 
			add(p_pool, {x=i,y=j})
		end
	end 
	base = 5
	while #p_pool > 0 do
		local count_to_remove = base + flr(rnd(20))
		for k=0,count_to_remove do
			if (#p_pool > 0) then
				local index = flr(rnd(#p_pool)) + 1
  		local point = p_pool[index]
  		-- swap
  		p_pool[index] = p_pool[#p_pool]
  		--pop
  		p_pool[#p_pool] = nil
				add(p_pixels, point)
			end 
		end
		yield()	
		base += 1
	end

end

function draw_fadeout(p_pixels,p_color)
  for pixel in all(p_pixels) do 
  	pset(pixel.x, pixel.y,p_color)
  end
end
__gfx__
0007700000000000000000004441111107777000ffffffffff3333333fffffffffffffff3333331113330000033333333333333030000000ffffffffffffffff
0077770000000000000000004411111177777700f3333333f331111133fff33333ffffff3333311111330000333000000000033330000000f3333333ffffffff
0070070000000333333000004111111177ff7700f3222223f311111113ff330003ffffff3333bbb111110000333000000000033330000000330030033fffffff
0070070000033344443330001111111177ff7700f3222223f311111113f3300003ffffff333bbbbb11110000300300000000300330000000377777773fffffff
0777777000034433334430001111111177777700f3225553f311555113f3005553ffffff331111111111000030003000000300033000000037b00b073fffffff
0700007000034433334430001111111107777000f3225553f331555133f3005553ffffff3111111111110000300003000030000333333330370b00b73fffffff
0700007000034433334430001111111100000000f3225533ff3355333ff3005533ffffff31ddd55111110000300000333300000334444443377777773fffffff
7770077700033344443330001111111100000000f3255553ff355553fff3355553ffffff3dddddd511110000300000300300000334444443333333333fffffff
0100010000000333333000000088000000000000f3255553ff355553ffff355553ffffff3d33d33d111100003000003003000003344444430000000000000000
011001100000009aa90000000008000000000000222222222222222222222222222fffff3ddddddd111100003000003333000003344444430000000000000000
010001000000009aa90000000088800000000000ff11fffffffffffffffffff11fffffff3ddddddd111100003000030000300003344444430000000000000000
111011100000009aa90000000800080000000000ff1ffffffffffffffffffff1ffffffff3ddbbbdd111100003000300000030003344444430000000000000000
121012100000099aa99000008000008000000000ffffffffffffffffffffffffffffffff33ddddd1111100003003000000003003333333330000000000000000
12101210000009aaaa9000008888888000000000ffffffffffffffffffffffffffffffff33555551111100003330000000000333330000330000000000000000
1210121000000999999000000000000000000000ffffffffffffffffffffffffffffffff33ddd551111100003330000000000333330000330000000000000000
1110111000000000000000000000000000000000ffffffffffffffffffffffffffffffff00000000000000000333333333333330330000330000000000000000
00000333333333333333333300000000333333333333333333333333333333333333333300000000000000000000000770000000000000000000000000000000
0003333030030030030030333300000035444444444444433cbbbbbbbbbbbbbbbbbbbc3300000773000000000000007777000000077000000000077000000000
0333030030030030030030030333000035444444444444433cbbbbbbbbbbbbbbbbbbbc3300000773000000000000007777000000077700000000777000000000
0330030030030030030030030033000035444444444444433cbbbbbbbbbbbbbbbbbbbc3307777773777700000000007777000000007770000007770000000000
0330030030030030030030030033000035444444444444433cbbbbbbbbbbbbbbbbbbbc3307777777777700000000007777000000000777000077700000000000
0333333333333333333333333333000035444444444444433cccccccc333333ccccccc3307777777777700000000007777000000000077700777000000000000
03fdddddddddddddddddddddddd3000035555555555555533333333333cccc333333333300073777370000000777777777777770000007777770000000000000
03fdd33333333ddd33333333ddd3000033333333333333333cccccccc333333ccccccc3300077777770000007777777777777777000000777700000000000000
03fd3cccccccc3d3cccccccc3dd3000034444444444444433cbbbbbbbbbbbbbbbbbbbc3300077777770000007777777777777777000000777700000000000000
03fd3cccccccc3d3cccccccc3dd3000034444333333444433cbbbbbbbbbbbbbbbbbbbc3300077777770000000777777777777770000007777770000000000000
03fd3cccccccc3d3cccccccc3dd3000034444444444444433ccccccccccccccccccccc3300077777770000000000007777000000000077700777000000000000
03fd3cccccccc3d3cccccccc3dd30000333333333333333333333333333333333333333300773777777000000000007777000000000777000077700000000000
03fd3cccccccc3d3cccccccc3dd30000344444444444444333333333333333333333333300773377777000000000007777000000007770000007770000000000
03fd3cccccccc3d3cccccccc3dd30000344443333334444300000000000000000000000000777307777000000000007777000000077700000000777000000000
03fdd33333333ddd33333333ddd30000344444444444444300000000000000000000000000777307777000000000007777000000077000000000077000000000
03ddddddddddddddddddddddddd30000333333333333333300000000000000000000000000000000000000000000000770000000000000000000000000000000
033333333333333333333333333300003333333333330000ffffeeeeffff0000000888880009aaaa000000000000000000000000cc000000000000cc00000000
03fcccccccccccccccccccccccc300003444444444430000fffeeeeefff000000088222200009aaa000000000000000aaaa00000cccccccccccccccc00000000
03fcccccccccccccccccccccccc300003444444444430000fffeeeeefff0000000822222000000aa000000000000000a99aaa0000c88aa888a9999c000000000
03fcccccccccccccccccccccccc300003444444477770000fffeffffffff0ccc008822220aaaa99000000aa00000000a9999aaaa0c88a8a8aaa999c000000000
03fcccccccccccccccccccccccc30000344444447f970000fffefffffff0c000008888880aaaaa00000aaaaa0000000a99999aaa0c99aaaaaaa999c000000000
03fcccccccccccccccccccccccc300003444444477970000fffefffffffc0fff00888888000aa90000a9aaaaa00000009999999a0c99aa8aaaa999c000000000
03fcccccccccccccccccccccccc300003444444477970000fffefffffff0ffff00088888990099990aaa9aaaa0000000022009900c99899aaaa898c000000000
03fcccccccccccccccccccccccc30000344444447f970000fffeffffffffffff0000888809909000aa9999aaaa100000022000000c888998888888c000000000
03fcccccccccccccccccccccccc300003444444477970000ffffffffffffffff0000088800999aaa00999aaa11100000220000000c888898888888c000000000
033333333333333333333333333300003444444477970000ffffffffffff00000000000000099a9a000999aa11110022200000000c88888888888ac000000000
03333333333333333333333333330000344444447f970000fff64444fff0000000000000000099aa0000000001111022200000000c8888888aa8a9c000000000
033cc3cc3cc3cc3cc3cc3cc3cc3300003444444477970000ff664664fff00fff00000000aaa990000000000000111112200099000c888888989898c000000000
033cc3cc3cc3cc3cc3cc3cc3cc3300003444444477970000ffff4664fff0ffff00000000aaaa0000000000000001111120099990cccccccccccccccc00000000
033cc3cc3cc3cc3cc3cc3cc3cc330000344444447f970000ffff4444fff0ffff00000000aaa90000000000aa0000111112022990cc000000000000cc00000000
033333333333333333333333333300003444444477970000ffff787fffffffff0000000000990000000000aaa222221112222000000000000000000000000000
033000000000000000000000003300003444444477970000ffff444fffffffff000000000090000000000aaaa000022112122000000000000000000000000000
ffffffffffffffffffff0000ffffffff344444447f970000ffffffff000000000000000000000000000000aa000000001122000000000000cc000000000000cc
fffffffffffffffffff00000ffffffff3444444477770000ffffffff00777700000000000000000000000000000000001112000000000000cccccccccccccccc
ffffffffffffffffff000000fff777773444444444430000fff999ff078888700009a9aaaaaaaa00000000000000000001110000000000000c666688777777c0
ffffffffffffffffff000fffffbb77773444444444430000ff99999f07888870099a999aa9aaaaa0000000000000000000112000000000000c6e6688777777c0
ffffffffffffffffff00ffffffff77773444444444430000ffff9999078888709999aa99aaaaaaaa000000000000000000111200000000000c666688778777c0
ffff2222ffff2222ff00ffffffff77773333333333330000ffff77770788887099999a9a9a9a9aaa0000000000000000000111009a0000000c666668777777c0
fff22122fff22222fff00fffffffcccc3444444444430000fff7777700777700999a9aaa99aaaaaa0000000000000000aa011129aa0000000c666668877777c0
fff22122fff22112ffffffffffffbbbb3444444444430000ffffaaaf00000000999999a9aaaaaaaa000000000000000999a11119a00000000c6e6668877777c0
ffff2222ffffffffffffffffffffffff3444444444430000ffffffffffffffff9999999a9aaa9aaa000000000000000000000000000000000c666668887778c0
fffff222ffffffffffffffffffffffff3444444444430000ffffffffffffffff999999999a9aaaaa000000000000099990000000000000000c666666887777c0
fff22111fffffffffffbb333fffc88cc3444444444430000ffff5fffffffffff099999999aaaaaaa09990000000099aaa9000000000000000c6666e6887777c0
ff222222ffffffffffeebbbbffcc88883444444444430000ffff5555ffffffff099999999990000a99a990000009aaa999000000000000000c666666888777c0
ff221222ffffffffffff3bbbffff88883333333333330000ffff5555ffffffff099999990990000a9aaa99000099aa99a900000000000000cccccccccccccccc
ffff2222ffff0000ffff3bbbffff88883300000000330000ffff0000ffffffff00990000009000009aaaa990009aaa9aa900000000000000cc000000000000cc
ffff222fffff000fffffffffffff888f0000000000000000fffffffffff0000000000000009000009aaaaa990099a9aa99000000000000000000000000000000
ffff222fffffffffffffbbbfffff777f0000000000000000ffff666fffff000f0000000000000000999aaaa9909999aa99000000000000000000000000000000
0000000f000000000fff0000ff0000000ff0000000fffff0cccccccc0000000003333333000000000999aaaa90999aaa90000000000000000000000033333333
000000ff000000000fff0000ff00000000ff00000fffffffcccccccc00000003335555550000000000999aaa9909999990000000000000000000000033333333
00000fff000000000fff0000ff000000000f0000fff00fffcccccccc0000003355555555000000000009999a9900999900000000000000000000000033333333
00000ff0000000000ffff000ff00000000000000ff0000ff7ccccccc000000355555555500000000000009999990990000000000000000000000000033333333
00000ff0000000000ff0f000ff00000000000000ff0000007ccccccc000000355555555500000000000000099999990000000000000000000000000033332222
0000ff00000000000ff0f000ff00000000000000fff0000077cccccc000000355555555500000000000000000009990000000000000000000000000033322fff
0000ff00000000000ff0ff00ff00000000000000ffff0000777ccccc00000033555555550000000000000000000999000000000000000000000000003332f7ff
0000ff00000000000ff00f00ff000000000000000ffff00077777ccc00000003335555550000000000000000000099000000000000000000000000003332f7ff
000fffff000000000ff00f00ff0000000000000000fffff000000000000000000333333300000000000000000000990000000000000000000000000033322222
000ff000000000000ff00ff0ff000000000000000000ffff00000000000000000000000400000000000000000000990000000000000000000000000033332222
000ff000000000000ff000f0ff0000000000000000000fff00000000000000000000000400000000000000000000000000000000000000000000000033300004
00ff0000000000000ff000ffff00000000000000000000ff00000000000000000000004400000000000000000000000000000000000000000000000033000004
00ff0000000000000ff000ffff00000000000000ff0000ff00000000000000000000044400000000000000000000000000000000000000000000000033ff0004
00ff0000000000000ff0000fff00000000000000fff00fff00000000000000000000000000000000000000000000000000000000000000000000000033330000
0ff00000000000000ff0000fff000000000000000fffffff00000000000000000000000000000000000000000000000000000000000000000000000033330003
0ff00000000000000ff00000ff0000000000000000fffff000000000000000000000000000000000000000000000000000000000000000000000000033330003
000f000000000f0000000000000000000000f00000f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000f000000000f000000000000000f000000f00000f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000f00000f0fffff00000000f000000000f0f000fffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffff00ffff000f000ff00000ffff0f00fff0fff000f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f00f00f00f000f00f00f0000f00f0f0f00f0f00f00f00000000000000000bb0000bb000000000000000000000000000000000000000000000000000000000000
f00f00f00f000f00ffff0000f00f0f0f00f0f00f00f0000000000000000bbbb00bbbb00000000000000000000000000000000000000000000000000000000000
f00f00f00f000f00f0000000f00f0f0f00f0f00f00f0000000000000000bbbbbbbbbb00000000000000000000000000000000000000000000000000000000000
fffff0fffff00f00ffff0000f00f0f0ffff0f00f00f0000000000000000bbbbbbbbbb00000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000f0000000000000000000000000bbbbbbbb000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000f00000000000000000000000000bbbbbb0000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000f00f000000000000000000000000000bbbb00000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000fff0000000000000000000000000000bb000000000000000000000000000000000000000000000000000000000000000
__label__
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhfhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhfhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhfhhhhhhhhhhhhhhhhh
hhhhhhhhhhfhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhfhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppphhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppphhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppphhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppphhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppphhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhpppppppppffpppppppfffppppffpppppppffpppppppfffppppffpffppppppppffppffpppppppfffffppppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhppppppppffffppppppfffppppffppppppffffppppppfffppppffpffpppppppffffppffpppppfffffffpppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhpppppppffffffpppppfffppppffpppppffffffpppppfffppppffpffppppppffffffppfppppfffppfffpppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhpppppppffppffpppppffffpppffpppppffppffpppppffffpppffpffppppppffppffpppppppffppppffpppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhpppppppffppffpppppffpfpppffpppppffppffpppppffpfpppffpffppppppffppffpppppppffpppppppppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhppppppffppppffppppffpfpppffppppffppppffppppffpfpppffpffpppppffppppffppppppfffppppppppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhppppppffppppffppppffpffppffppppffppppffppppffpffppffpffpppppffppppffppppppffffpppppppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhppppppffppppffppppffppfppffppppffppppffppppffppfppffpffpppppffppppffpppppppffffppppppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhpppppffffffffffpppffppfppffpppffffffffffpppffppfppffpffppppffffffffffpppppppfffffppppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhpppppffppppppffpppffppffpffpppffppppppffpppffppffpffpffppppffppppppffpppppppppffffpppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhpppppffppppppffpppffpppfpffpppffppppppffpppffpppfpffpffppppffppppppffppppppppppfffpppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhppppffppppppppffppffpppffffppffppppppppffppffpppffffpffpppffppppppppffppppppppppffpppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhppppffppppppppffppffpppffffppffppppppppffppffpppffffpffpppffppppppppffppppffppppffpppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhppppffppppppppffppffppppfffppffppppppppffppffppppfffpffpppffppppppppffppppfffppfffpppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhpppffppppppppppffpffppppfffpffppppppppppffpffppppfffpffppffppppppppppffppppfffffffpppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhpppffppppppppppffpffpppppffpffppppppppppffpffpppppffpffppffppppppppppffpppppfffffppppphhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppphhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppphhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppphhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppphhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppphhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhpppppppppppppppppppppppppppppppppppppppppppppppppppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhpppppppfpppppppppfppppppppppppppppppppppfpppppfppppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhpppppppfpppppppppfpppppppppppppppfppppppfpppppfppppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhpppppppfpppppfpfffffppppppppfpppppppppfpfpppfffffppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhppppffffppffffpppfpppffpppppffffpfppfffpfffpppfppppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhppppfppfppfppfpppfppfppfppppfppfpfpfppfpfppfppfppppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhppppfppfppfppfpppfppffffppppfppfpfpfppfpfppfppfppppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhfhhhhhhhhhhhhhhhhhhhhhhhppppfppfppfppfpppfppfpppppppfppfpfpfppfpfppfppfppppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhppppfffffpfffffppfppffffppppfppfpfpffffpfppfppfppppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhppppppppppppppppppppppppppppppppppppppfppppppppppppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhpppppppppppppppppppppppppppppppppppppfpppppppppppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhppppppppppppppppppppppppppppppppppfppfpppppppppppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhppppppppppppppppppppppppppppppppppfffppppppppppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhpppppppppppppppppppppppppppppppppppppppppppppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhfhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhpppppppppppppppppppppppppppppppppppppppppphhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhfhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhfhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0000000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh000000000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh000000000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0ppppp0hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0p00000p0hhhhhhhhhhhhhhhhhoohhhhoohhhhhhhhhhhhhhhhhkkkkkkkhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhp0kkkkk0phhhhhhhhhhhhhhhhoooohhoooohhhhhhhhhhhhhhhkkfffffkkhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0kgkkkgk0hhhhhhhhhhhhhhhhoooooooooohhhhhhhhhhhhhhhkfhfffhfkhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhkkgkkkgkkhhhhhhhhhhhhhhhhoooooooooohhhhhhhhhhhhhhhkfhfffhfkhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhkkkkkkkhhhhhhhhhhhhhhhhhhoooooooohhhhhhhhhhhhhhhhkkkkkkkkkhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhkkkkkhhhhhhhhhhhhhhhhhhhhoooooohhhhhhhhhhhhhhhhhhkkkkkkkhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhpsspppssphhhhhhhhhhhhhhhhhhhoooohhhhhhhhhhhhhhhhhh0000l0000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhppssssssspphhhhhhhhhhhhhhhhhhhoohhhhhhhhhhhhhhhhhh00000l00000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhkkssssssskkhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhff000l000ffhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhssssssshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh0000000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhssshssshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh000h000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh000h000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhfhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhfhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhfhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhfhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh

__map__
00000000000000000000000000000000001e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e000000000000000000000000000000001e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e000000000000000000000000000000001e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e000000000000000000000000000000001e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e000000000000000000000000000000001e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e000000000000000000000000000000001e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e000000000000000000000000000000001e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e000000000000000000000000000000001e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e000000000000000000000000000000001e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011600001174011740117401174011730117201174011740117401174011730117201174011740117401174010740107401074010740107301072010740107401074010740107301072010740107401074010740
3116000018524185201c5241c520000000000018524185201c5241c520000000000018524185201c5241c52018524185201c5241c520000000000018524185201c5241c520000000000018524185201c5241c520
011600000e7400e7400e7400e7400e7300e7200e7400e7400e7400e7400e7300e7200e7400e7400e7400e7400c7400c7400c7400c7400c7300c7200c7400c7400c7400c7400c7300c7200c7400c7400c7400c740
1116000018112181101c1121c110000000000018112181101c1121c110000000000018112181101c1121c11018112181101c1121c110000000000024112241102811228110000000000024112241102811228110
001600001100411000110001100011000110001100011000110001100011000110001100011000110001100021024210202102021020230242302023020230202402424020240202402024010240100000000000
89160000211222112221122211221d1221d1221f1221f12221122211222112221122211222112221122211221f1221f1221f1221f1221c1221c1221f1221f1221c1221c1221c1221c1221c1221c1221c1221c122
0016000000000000001000410000100001000010000100001000010000100001000010000100001000010000100001000021024210202102021020230242302023020230201f0241f0201f0201f0201f0101f010
891600002312223122231222312224122241222312223122241222412224122241222412224122241222412228122281222812228122281222812224122241222412224122241222412224122241222412224122
01160000000000000000000000000e0040e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0001d0241d0201d0201d0201f0241f0201f0201f02021024210202102021020
001600002101021010000000000000000000000c0040c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0001c0241c0201c0201c0201d0241d0201d0201d0201f0241f020
001602021f0101f010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000070000032250322502e2001e2001e2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 00014d40
01 02014d40
00 00010340
00 02010340
00 00040541
00 02060740
00 00080540
00 02090740
02 400a4040

