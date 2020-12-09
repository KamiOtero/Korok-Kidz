pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--koolkid'z marble-ous adventure
--authors: brianna, sam, kami

--main
function _init()
    --global variables
    state="logo"
    map_state="backyard"
    player_x=20
    player_y=20
    speed=2
    kid_sprite=6
    frog_sprite=8
    dialog_cooldown = 0
    backyard_marble=false
    house_marble=false
    townsquare_marble=false
    junkyard_marble=false
    school_marble=false
    playground_marble=false
    library_marble=false
    win=false
    level=1

    --pre-initialize
    dtb_init()
    minigame_init()
    --first state
    logo_init()
end

--state handling
function _update()
    if state=="logo" then logo_update()
    elseif state=="menu" then menu_update()
    elseif state=="dialog" then dtb_update()
    elseif state=="minigame" then update_minigame()
	else game_update() end
end

function _draw()
    if state=="logo" then logo_draw()
    elseif state=="menu" then menu_draw()
    elseif state=="dialog" then dtb_draw()
    elseif state=="minigame" then draw_minigame()
	else game_draw() end
end

--gameplay 
function game_init()
	state="game"
	--hitboxes
	player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15} -- 24,23,31,35
	top_border={0,0,127,0}
	left_border={0,0,0,127}
	right_border={127,0,127,127}
    bottom_border={0,127,127,127}
    door_top1_border={0,0,40,0}
    door_top2_border={80,0,127,0}
    door_left1_border={0,0,0,40}
    door_left2_border={0,80,0,127}
    door_right1_border={127,0,127,40}
    door_right2_border={127,80,127,127}
    door_bottom1_border={0,127,60,127}
    door_bottom2_border={80,127,127, 127}

	npc1={60,62,69,69}
	dialog_npc1={57,59,72,72}

    --set state
    update=game_update()
    draw=game_draw()
end


function game_update()
	state="game"
	dialog_cooldown = dialog_cooldown - 1
    move()
    map_update()
	--collide with npc1
	if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   npc1[1],npc1[2],npc1[3],npc1[4] )
	then
	 	 blocked()
	end
	--in npc dialog box
	if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   dialog_npc1[1],dialog_npc1[2],dialog_npc1[3],dialog_npc1[4] )
	then
	  if btn(4) and (dialog_cooldown <= 0) then 
	    state="dialog"
	    dtb_disp("ribbit ribbit")
        dialog_cooldown=5
        if(map_state=="backyard") backyard_marble=true
        if(map_state=="house") house_marble=true
        if(map_state=="townsquare") townsquare_marble=true
        if(map_state=="junkyard") junkyard_marble=true
        if(map_state=="school") school_marble=true
        if(map_state=="playground") playground_marble=true
        if(map_state=="library") library_marble=true

      end
      if btn(5) and (dialog_cooldown <= 0) then 
	    state="minigame"
	  end
    end
    
    if( backyard_marble==true and 
        house_marble==true and
        townsquare_marble==true and
        junkyard_marble==true and
        school_marble==true and
        playground_marble==true and
        library_marble==true) then
        map_state="beach"
        win=true
    end
end

function game_draw()
	state="game"
    cls()
    draw_map()
    sspr((kid_sprite*8), 0, 16, 16, player_x, player_y, 16, 16)

	--rect(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],1)

	--rect(npc1[1],npc1[2],npc1[3],npc1[4],6)
	--rect(dialog_npc1[1],dialog_npc1[2],dialog_npc1[3],dialog_npc1[4],7)
    sspr((frog_sprite*8), 0, 8, 8, npc1[1], npc1[2], 8, 8)
    if(win==true) then print("Lets go to the beach!!!", 20, 25) end

end

function draw_map()
    --backyard
    if map_state=="backyard" then map(0, 0, 0, 0, 128, 32) end
    --townsquare
    if map_state=="townsquare" then map(16, 0, 0, 0, 128, 32) end
    --playground
    if map_state=="playground" then map(32, 0, 0, 0, 128, 32)	end
    --house
    if map_state=="house" then map(0, 16, 0, 0, 128, 32) end
    --junkyard
    if map_state=="junkyard" then map(16, 16, 0, 0, 128, 32) end
    --library
    if map_state=="library" then map(32, 16, 0, 0, 128, 32) end
    --school
    if map_state=="school" then map(48, 0, 0, 0, 128, 32) end
    --beach
    if map_state=="beach" then map(48, 16, 0, 0, 128, 32) end
end




--minigame
function minigame_init()
    scr_w=128
    scr_h=128
    pointerx1 = scr_w/2
    pointery1 = scr_h
    pointerx2 = scr_w/2
    pointery2 = scr_h - 10
    marble_sprite=38
    marblex = scr_w/2 - 3
    marbley = scr_h - 4
    marble_hitbox={marblex, marbley, marblex + 7, marbley + 7}
    speed = 2
    right = true
    up=true
    shoot=false
    moving=true
    select=false
    drawPower=false
    marble_height=1
    marble_width=1 --really 8 px

    powerx1 = 105
    powery1 = 60
    powerx2 = 115
    powery2 = 60

    --main circle
    circ_hitbox={31, 11, 97, 77}

    --add marbles in circle.
    if(level==1) then
        marble2_sprite=32
        marble2x=64
        marble2y=34
        marble2_hitbox={marble2x, marble2y, marble2x + 7, marble2y + 7}
        marble2_hit = false

    elseif(level==2) then
        marble2_sprite=32
        marble2x=64
        marble2y=34
        marble2_hitbox={marble2x, marble2y, marble2x + 7, marble2y + 7}
        marble2_hit = false

        marble3_sprite=33
        marble3x=44
        marble3y=34
        marble3_hitbox={marble3x, marble3y, marble3x + 7, marble3y + 7}
        marble3_hit = false

    elseif(level==3) then

    elseif(level==4) then

    elseif(level==5) then

    elseif(level==6) then

    end

    state="minigame"
    update=update_minigame()
    draw=draw_minigame()
end 

function update_minigame()
    state="minigame"
	--main marble
	if  right==true and moving==true then
		pointerx1+=speed pointerx2+=speed
		if shoot==false then marblex+=speed marble_hitbox[1]+=speed marble_hitbox[3]+=speed end
		if pointerx1 >= 128 then right=false end
	end
	if right==false and moving==true then  
		pointerx1-=speed pointerx2-=speed
		if shoot==false then marblex-=speed marble_hitbox[1]-=speed marble_hitbox[3]-=speed end
		if pointerx1 <= 0 then right=true end
	end
	if (btnp(4)) then shoot=true moving=false drawPower=true end

	--powerlevel
	if shoot==true then 
		function wait(a) for i = 1,a do flip() end end --wait funciton

		if  up==true and select==false then
			powery1-=speed powery2-=speed
			if powery1 <= 60 then up=false end
		end
		if  up==false and select==false then
			powery1+=speed powery2+=speed
			if powery1 >= 90 then up=true end
		end
		if (btnp(5)) then 
			select=true 
			if powery1 >= 60 and powery1 <= 70 then speed=3 end
			if powery1 >= 70 and powery1 <= 80 then speed=2 end
			if powery1 >= 80 and powery1 <= 90 then speed=1 end
		end
		if select==true then
			main_marble_mover()

			if(level==1) then
				--marble2
				if hitbox_collide(marble_hitbox[1], marble_hitbox[2], marble_hitbox[3], marble_hitbox[4],   marble2_hitbox[1], marble2_hitbox[2], marble2_hitbox[3], marble2_hitbox[4])  then
					marble2_hit=true
				end
				if marble2_hit == true then
					marble2x+=speed --TODO: Update so it goes opposite of player marble
					marble2y-=speed
				end
			elseif(level==2) then
				--marble2
				if hitbox_collide(marble_hitbox[1], marble_hitbox[2], marble_hitbox[3], marble_hitbox[4],   marble2_hitbox[1], marble2_hitbox[2], marble2_hitbox[3], marble2_hitbox[4])  then
					marble2_hit=true
				end
				if marble2_hit == true then
					marble2x+=speed --TODO: Update so it goes opposite of player marble
					marble2y-=speed
				end
				--marble3
				if hitbox_collide(marble_hitbox[1], marble_hitbox[2], marble_hitbox[3], marble_hitbox[4],   marble3_hitbox[1], marble3_hitbox[2], marble3_hitbox[3], marble3_hitbox[4])  then
					marble3_hit=true
				end
				if marble3_hit == true then
					marble3x-=speed
					marble3y-=speed
				end
			elseif(level==3) then

			elseif(level==4) then

			elseif(level==5) then

			elseif(level==6) then

			end
		end
	end
end

function draw_minigame()
    state="minigame"
	cls()
    print("press 'z' to aim", 33, 90, 10)
    print("press 'x' to fire!", 30, 100, 10)
	map(64,0,0,0,128,32)
	line(pointerx1, pointery1, pointerx2, pointery2,7) -- pointer	
	line(0,scr_h-15,scr_w,scr_h-15,8) --straight line
	circ(64, 44, 32, 8) --circle

	if drawPower==true then
		rectfill( 110, 60, 110, 70, 11)
		rectfill( 110, 70, 110, 80, 10)
		rectfill( 110, 80, 110, 90, 8)
		line(powerx1, powery1, powerx2, powery2,7) -- pointer	
	end

	--rect(circ_hitbox[1], circ_hitbox[2], circ_hitbox[3], circ_hitbox[4], 11)
	--rect(marble_hitbox[1], marble_hitbox[2], marble_hitbox[3], marble_hitbox[4], 10)
	--rect(marble2_hitbox[1], marble2_hitbox[2], marble2_hitbox[3], marble2_hitbox[4], 11)

	--print marbles
	spr(marble_sprite, marblex, marbley, marble_width, marble_height)
	if(level==1) then 
		spr(marble2_sprite, marble2x, marble2y, marble_width, marble_height)
	elseif(level==2) then 
		spr(marble2_sprite, marble2x, marble2y, marble_width, marble_height)
		spr(marble3_sprite, marble3x, marble3y, marble_width, marble_height)
	elseif(level==3) then

	elseif(level==4) then

	elseif(level==5) then

	elseif(level==6) then

	end

	--check win condition
	if(level==1) then 
		if(marble2_hit == true and marbley > 100 ) then state="game" end
	elseif(level==2) then 
		if(marble2_hit == true and marble3_hit == true and marbley > 100 ) then state="game" end
	elseif(level==3) then

	elseif(level==4) then

	elseif(level==5) then

	elseif(level==6) then

	end
end
   
function main_marble_mover()
	marbley-=speed marblex=marblex 
	marble_hitbox[2]-=speed
	marble_hitbox[4]-=speed  
	marble_hitbox[1]=marble_hitbox[1] 
	marble_hitbox[3]=marble_hitbox[3]
	if marbley<=-5 then 
		--reset
		drawPower=false
		shoot=false 
		select=false
		moving=true
		marblex=pointerx1 - 3 
		marbley=pointery1 - 4 
		marble_hitbox[1] = marblex
		marble_hitbox[2] = marbley
		marble_hitbox[3] = marblex + 7
		marble_hitbox[4] = marbley + 7
	end
end







--other states
--logo state
function logo_init()
    logo=0
    logo_x=48
    logo_y=30
    logo_animation=0

    state="logo"
    update=logo_update()
    draw=logo_draw()
end

function logo_update()
    state = "logo"
    if (time() - logo_animation) > 1 then 
        logo += 1
        logo_animation=time()
    end
    if (logo > 2) then menu_init() end
end

function logo_draw()
    state="logo"
    cls()
    sspr((logo*16), 0, 16, 16, logo_x, logo_y, 32, 32)
    print("korok kidz presents...",25,70,3)
    print("kool kid'z", 30, 80, 8)
    print("marble-ous adventure!",20,90,11)
end

--menu state
function menu_init()
    --variables for menu
    options = {"new game", "how to play", "quit"}
    selected = 0
    numoptions = 3
    input=0
    frog_x=0
    frog_y=70
    --handle state
    state="menu"
    update=menu_update()
    draw=menu_draw()
end

function menu_update()
    state="menu"
    --scrolling between options
	if(btn(3) and input <= 0) then
        input = 5
		selected=selected+1
		selected = selected % numoptions
	elseif(btn(2) and input <= 0) then
        input = 5
        input=input+1
        selected=selected-1
        selected = selected % numoptions
	end
	
	--menu actions
	if(btn(4)) then
		if(selected == 0) then
            game_init()
        elseif(selected == 1) then 
            --TODO diplay instructions
		elseif(selected == 2) then
			cls()
			extcmd('shutdown')
		end
	end
    input=input-1

    --move froggo
    if(frog_x < 128) then frog_x=frog_x+2
    else frog_x=0
    end

end

function menu_draw()
    state="menu"
    cls()
    map(16, 0, 0, 0, 128, 32)
    --print froggo
    sspr((frog_sprite*8), 0, 8, 8, frog_x, frog_y, 8, 8)
	if selected == 0 then
		print(options[1],50,45,12)
	else
		print(options[1],50,45,0)
	end
	
	if selected == 1 then
		print(options[2],50,55,12)
	else
		print(options[2],50,55,0)
    end
    
    if selected == 2 then
		print(options[3],50,65,12)
	else
		print(options[3],50,65,0)
	end
end


--helper functions
function hitbox_collide(ax1, ay1, ax2, ay2, bx1, by1, bx2, by2)
    local c1 = ay1 <= by2
    local c2 = ay2 >= by1
    local c3 = ax1 <= bx2
    local c4 = ax2 >= bx1
    if c1 and c2 and c3 and c4 then
      return true
    else
      return false
    end
  end
  
  function blocked()
      --hitbox
      if btn(2) then player_hitbox[2]+=speed player_hitbox[4]+=speed end --up
      if btn(3) then player_hitbox[2]-=speed player_hitbox[4]-=speed end --down
      if btn(0) then player_hitbox[1]+=speed player_hitbox[3]+=speed end --left
      if btn(1) then player_hitbox[1]-=speed player_hitbox[3]-=speed end --right
      --player
      if btn(0) then player_x=player_x+speed end
      if btn(1) then player_x=player_x-speed end
      if btn(2) then player_y=player_y+speed end
      if btn(3) then player_y=player_y-speed end
  end
  
  function move()
      --hitbox
      if btn(2) then player_hitbox[2]-=speed player_hitbox[4]-=speed end --up
      if btn(3) then player_hitbox[2]+=speed player_hitbox[4]+=speed end --down
      if btn(0) then player_hitbox[1]-=speed player_hitbox[3]-=speed end --left
      if btn(1) then player_hitbox[1]+=speed player_hitbox[3]+=speed end --right
      --player
      if btn(0) then player_x=player_x-speed end
      if btn(1) then player_x=player_x+speed end
      if btn(2) then player_y=player_y-speed end
      if btn(3) then player_y=player_y+speed end
  end

function doorTop() 
    if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   door_top1_border[1],door_top1_border[2],door_top1_border[3],door_top1_border[4]) or
       hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   door_top2_border[1],door_top2_border[2],door_top2_border[3],door_top2_border[4])
    then
        blocked()
    end
end
function doorRight() 
    if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   door_right1_border[1],door_right1_border[2],door_right1_border[3],door_right1_border[4]) or
       hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   door_right2_border[1],door_right2_border[2],door_right2_border[3],door_right2_border[4])
    then
        blocked()
    end
end
function doorBottom() 
    if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   door_bottom1_border[1],door_bottom1_border[2],door_bottom1_border[3],door_bottom1_border[4]) or
       hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   door_bottom2_border[1],door_bottom2_border[2],door_bottom2_border[3],door_bottom2_border[4])
    then
        blocked()
    end
end
function doorLeft() 
    if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   door_left1_border[1],door_left1_border[2],door_left1_border[3],door_left1_border[4]) or
       hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   door_left2_border[1],door_left2_border[2],door_left2_border[3],door_left2_border[4])
    then
        blocked()
    end
end

function wallTop() 
    if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   top_border[1],top_border[2],top_border[3],top_border[4])
    then
        blocked()
    end
end

function wallRight() 
    if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   right_border[1],right_border[2],right_border[3],right_border[4])
    then
        blocked()
    end
end
function wallBottom() 
    if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   bottom_border[1],bottom_border[2],bottom_border[3],bottom_border[4])
    then
        blocked()
    end
end
function wallLeft() 
    if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],  left_border[1],left_border[2],left_border[3],left_border[4])
    then
        blocked()
    end
end

--game helpers
function map_update()
	--backyard
    if map_state=="backyard" then
            doorTop()
            wallLeft()
            wallRight()
            wallBottom()
            if (player_x >= 40 and player_x <= 80) and (player_y >= 0 and player_y <= 5) then
                    map_state="house"
                    player_y = 100
                    player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
			end
	end
    --house
    if map_state=="house" then
            doorTop()
            wallLeft()
            wallRight()
            doorBottom()
			if (player_x >= 40 and player_x <= 80) and (player_y >= 0 and player_y <= 5) then
                map_state="townsquare"
                player_y = 100
                player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
			elseif (player_x >= 40 and player_x <= 80) and (player_y >= 122 and player_y <= 127) then
                player_y=10
                player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15} 
                map_state="backyard"
			end
	end 
	--school
    if map_state=="school" then
            doorRight()
            wallTop()
            wallLeft()
            doorBottom()
			if (player_x >= 40 and player_x <= 80) and (player_y >= 122 and player_y <= 127) then
                player_y=10
                player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
                map_state="playground"
			elseif (player_x >= 122 and player_x <= 127) and (player_y >= 40 and player_y <= 80) then
                player_x=10
                player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
                map_state="townsquare"
			end
	end
	--library
    if map_state=="library" then
        doorLeft()
        wallRight()
        wallBottom()
        wallTop()
        if (player_x >= 0 and player_x <= 5) and (player_y >= 40 and player_y <= 80) then
            player_x = 100
            player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
            map_state="townsquare"
        end
	end
	--junkyard
    if map_state=="junkyard" then
        doorBottom()
        wallLeft()
        wallTop()
        wallRight()
        if (player_x >= 40 and player_x <= 80) and (player_y >= 122 and player_y <= 127) then
            player_y = 10
            player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
            map_state="townsquare"
        end
	end
	--playground
    if map_state=="playground" then
        doorTop()
        wallLeft()
        wallRight()
        wallBottom()
        if (player_x >= 40 and player_x <= 80) and (player_y >= 0 and player_y <= 5) then
            player_y = 100
            map_state="school"
            player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
        end
	end
	--townsquare
    if map_state=="townsquare" then
        doorTop()
        doorBottom()
        doorLeft()
        doorRight()
			if (player_x >= 40 and player_x <= 80) and (player_y >= 0 and player_y <= 5) then
                player_y=100 
                player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
                map_state="junkyard"
			elseif (player_x >= 40 and player_x <= 80) and (player_y >= 122 and player_y <= 127) then
                player_y=10
                map_state="house"
                player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
			elseif (player_x >= 0 and player_x <= 5) and (player_y >= 40 and player_y <= 80) then
                player_x=100
                map_state="school"
                player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
			elseif (player_x >= 122 and player_x <= 127) and (player_y >= 40 and player_y <= 80) then
                player_x=10 
                map_state="library"
                player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
			end
	end
end


-->8
--dialog

--bellow needed for dialog--

-- call this before you start using dtb.
-- optional parameter is the number of lines that are displayed. default is 3.
function dtb_init(numlines)
    dtb_queu={}
    dtb_queuf={}
    dtb_numlines=3
    if numlines then
        dtb_numlines=numlines
    end
    _dtb_clean()
end

-- this will add a piece of text to the queu. the queu is processed automatically.
function dtb_disp(txt,callback)
    local lines={}
    local currline=""
    local curword=""
    local curchar=""
    local upt=function()
        if #curword+#currline>29 then
            add(lines,currline)
            currline=""
        end
        currline=currline..curword
        curword=""
    end
    for i=1,#txt do
        curchar=sub(txt,i,i)
        curword=curword..curchar
        if curchar==" " then
            upt()
        elseif #curword>28 then
            curword=curword.."-"
            upt()
        end
    end
    upt()
    if currline~="" then
        add(lines,currline)
    end
    add(dtb_queu,lines)
    if callback==nil then
        callback=0
    end
    add(dtb_queuf,callback)
end

-- functions with an underscore prefix are ment for internal use, don't worry about them.
function _dtb_clean()
    dtb_dislines={}
    for i=1,dtb_numlines do
        add(dtb_dislines,"")
    end
    dtb_curline=0
    dtb_ltime=0
    --return to game state
    if state~="logo" then state="game" end
end

function _dtb_nextline()
    dtb_curline+=1
    for i=1,#dtb_dislines-1 do
        dtb_dislines[i]=dtb_dislines[i+1]
    end
    dtb_dislines[#dtb_dislines]=""
    sfx(2)
end

function _dtb_nexttext()
    if dtb_queuf[1]~=0 then
        dtb_queuf[1]()
    end
    del(dtb_queuf,dtb_queuf[1])
    del(dtb_queu,dtb_queu[1])
    _dtb_clean()
    sfx(2)
end

-- make sure that this function is called each update.
function dtb_update()
    if #dtb_queu>0 then
        if dtb_curline==0 then
            dtb_curline=1
        end
        local dislineslength=#dtb_dislines
        local curlines=dtb_queu[1]
        local curlinelength=#dtb_dislines[dislineslength]
        local complete=curlinelength>=#curlines[dtb_curline]
        if complete and dtb_curline>=#curlines then
            if btnp(4) then
                _dtb_nexttext()
                return
            end
        elseif dtb_curline>0 then
            dtb_ltime-=1
            if not complete then
                if dtb_ltime<=0 then
                    local curchari=curlinelength+1
                    local curchar=sub(curlines[dtb_curline],curchari,curchari)
                    dtb_ltime=1
                    if curchar~=" " then
                        sfx(0)
                    end
                    if curchar=="." then
                        dtb_ltime=6
                    end
                    dtb_dislines[dislineslength]=dtb_dislines[dislineslength]..curchar
                end
                if btnp(4) then
                    dtb_dislines[dislineslength]=curlines[dtb_curline]
                end
            else
                if btnp(4) then
                    _dtb_nextline()
                end
            end
        end
    end
end

-- make sure to call this function everytime you draw.
function dtb_draw()
    if #dtb_queu>0 then
        local dislineslength=#dtb_dislines
        local offset=0
        if dtb_curline<dislineslength then
            offset=dislineslength-dtb_curline
        end
        rectfill(2,125-dislineslength*8,125,125,0)
        if dtb_curline>0 and #dtb_dislines[#dtb_dislines]==#dtb_queu[1][dtb_curline] then
            print("\x8e",118,120,1)
        end
        for i=1,dislineslength do
            print(dtb_dislines[i],4,i*8+119-(dislineslength+offset)*8,7)
        end
    end
end


__gfx__
000000003000000000000000300000000000000030000000000000000000000000000000b3333b33333333333333333333333333444944495666566665666656
000000003000000000000000300000000000000030000000000000000000000000000a3a333f3333b3b333333333333333b33333999999995555555555666655
00000003b300000000000003b300000000000003b3000000000000000000000000bb333333f3f3333b3333333333c3333b333333494449446656665665666656
0000033bb33000000000033bb33000000000033bb330000000004444444400000b337377333f333b33333333333c3c33333333b3999999995555555555665655
00033bbb3334000000033bbb3334000000033bbb33340000000044f44f4400000337737033333333333333333333c33333333b33444944495666566665666656
033bbb3333333000033bbb3333333000033bbb333333300000004ffffff4000003777370b3b333a33333b3b333333333333333339999999955555b5b55666655
03bb03333333b40003bb33333333b40003bb33333333b40000004f1ff1f40000333733303b333a3a33333b333b3b333333333333494449443b3b33b3b33333b3
3bb0073333033b403bb0073333333b403bb3333333333b4000004effffe4000000000000333333a33333333333b33333333333339999999933b3333333b33333
3330003330073343333000333007334333300033333333430000400ff0040000f00400000000400fffffffff363636363333533344444444cccccccc44444444
33333333300033343333333330003334333333333000333400000555555000005550000000000555ffffff5f636363633663336344499444cccccccc24551449
33333333333333343333333333333334333333333333333400000555575000005750000000000555f55fffff363636366dd536d344999944cccccccc23551669
333303333333cc33333303333333cc33333303330333cc3300000f5557f0000057f0000000000f55ffffffff636363636d5536d349999994cccccccc23551669
03333003333cc33303333000333cc33303333000333cc33300000011110000001100000000000011ffffffff363636363553335349999994cccccccc23551669
03333333333c003003333333333c003003333333333c003000000011110000001100000000000011ff5ff5ff636363633333633344999944cccccccc23551669
00333333333330000033333333333000003333333333300000000010010000000000000000000000ffffffff363636363336d53344499444cccccccc23551669
00033300003333000003330000333300000333000033330000000000000000000000000000000000fffffff5636363633336d53344444444cccccccc23551669
00cccc000088880000bbbb000099990000ffff00001111000011110000000000000000000000000000666dd06666666666666666666666662222222211111111
0c1111c0082222800b3333b009aaaa900f7777f001cccc1001c9c910000000000000000000000000066ddddd6666666666666666666666662222222211111111
c111111c82222228b333333b9aaaaaa9f777777f1cccccc11c9c9c9100000000000000000000000066dddddd6666666666666666444444442222222211111111
c111111c82222228b333333b9aaaaaa9f777777f1cccccc119c9c9c1000000000000000000000000666ddddd6666666665888856444444442222222211111111
c111111c82222228b333333b9aaaaaa9f777777f1cccccc11c9c9c91000000000000000000000000dddddd556666666666888866444444442222222211111111
c111111c82222228b333333b9aaaaaa9f777777f1cccccc119c9c9c1000000000000000000000000dddddd556666666666888866444444442222222211111111
0c1111c0082222800b3333b009aaaa900f7777f001cccc10019c9c100000000000000000000000000d5d55556666666665888856444444442222222211111111
00cccc000088880000bbbb000099990000ffff000011110000111100000000000000000000000000005555006666666666666666444444442222222211111111
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000444444440000000033333b3333b6555665556b33
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044444444000000003b3333b33b665656656565b3
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000004444444400000000bbb55b6633b5565565656b33
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000004444444400000000555555553355555665656533
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000004444444400000000666666553356565655555b33
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044444444000000005555555533b65655556565b3
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000004444444400000000566556663b65565665656b33
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044444444000000005555555533b5565665556533
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003300000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003300000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003300000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003300000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000033bb33000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000033bb33000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000003333bbbb33330000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000003333bbbb33330000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000003333bbbbbb3333334400000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000003333bbbbbb3333334400000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000003333bbbbbb33333333333333000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000003333bbbbbb33333333333333000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000033bbbb3333333333333333bb440000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000033bbbb3333333333333333bb440000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000033bbbb33333333333333333333bb4400000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000033bbbb33333333333333333333bb4400000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000033333300000033333333333333334433000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000033333300000033333333333333334433000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000033333333333333333300000033333344000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000033333333333333333300000033333344000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000033333333333333333333333333333344000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000033333333333333333333333333333344000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000333333330033333300333333cccc3333000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000333333330033333300333333cccc3333000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000033333333000000333333cccc333333000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000033333333000000333333cccc333333000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000033333333333333333333cc00003300000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000033333333333333333333cc00003300000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000003333333333333333333333000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000003333333333333333333333000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000033333300000000333333330000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000033333300000000333333330000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000003030033033300330303000003030333033003330000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000003030303030303030303000003030030030300030000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000003300303033003030330000003300030030300300000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000003030303030303030303000003030030030303000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000003030330030303300303000003030333033303330000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000bbb0bbb0bbb00bb00bb000000b00bbb00b000000bbb00bb000000bb0bbb0bbb0bbb0bbb000000000000000000000000000
000000000000000000000000000000b0b0b0b0b000b000b0000000b00000b0b00000000b00b0b00000b0000b00b0b0b0b00b0000000000000000000000000000
000000000000000000000000000000bbb0bb00bb00bbb0bbb0000000000b00000000000b00b0b00000bbb00b00bbb0bb000b0000000000000000000000000000
000000000000000000000000000000b000b0b0b00000b000b000000000b000000000000b00b0b0000000b00b00b0b0b0b00b0000000000000000000000000000
000000000000000000000000000000b000b0b0bbb0bb00bb0000000000bbb0000000000b00bb000000bb000b00b0b0b0b00b000b000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0000000000000000000000000000010000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0e0e0e0e0e0e0e0f0e0e0e0e0e0e0e0e1d1d1d1d1d1d0d0d0d0d1d1d1d1d1d1d0e0e0e0e0e0e0e0c0c0e0e0e0e0e0e3f1f1f1f1f3b3b3b3b3b3b3b3b1f1f1f1f2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f091c0c0b1c1c1c1c1c1c0c1c0c093e1d090a090b1d0d0d0d0d1d090a0c0b1d3f1b1b1b1b1b1b0a0c1b1b1b1b1b1b3f1f1f1f1f2b2b2b2b2b2b2b2b1f1f1f1f2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0c0c090c0b1c1c1c1c090b0c090c3e1d0b090a0c1d0d0d0d0d1d0b0c090a1d3f1b1b1b1b1b1b0c0b1b1b1b1b1b1b3f1f1f1f1f2b2b2b2b2b2b2b2b1f1f1f1f2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0c0c0c0b1c090a1c0c090c0c0a0c3e1d0a0c090b1d0d0d0d0d1d090a0b091d3f0b0b09090c0c0a0c0c090c0b090b3f1f1f1f1f2b2b2b2b2b2b2b2b1f1f1f1f2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f090c0c0a0b0a0a090a1c0c0c0b0c3e1d090b0c0a1d0d0d0d0d1d0c0b090a1d3f090c0c0c0b0c0c0c0a0c0a0c0c0b3f3b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0c0b090b0a0b0c0c0b0a0c0a0a0c3e1d1d1d1d1d1d0d0d0d0d1d1d1d1d1d1d3f0b0c0a0c0c0c0a0c0c0a0c0c0b0c3f3b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f090c0a090a3e3d3d3f0c090c090c3e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d3f0c0c0c0c0a0c0c0b0c0c0a0c0c0a3f3b2b2d2b2d2b2d2b2b2b2d2b2d2b2d2b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0c090c0c0c3e1e1e3f0c0b0c0c0c3e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d3f0c0a0c0c0c0a1e1e0c0a0c0a0c0c3f3b2b2c2b2c2b2c2b2b2b2c2b2c2b2c2b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0a0c0b0c093e1e1e3f090c0a0b0c3e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d3f0c1a1a1a1a1a1e1e1a1a1a1a1a0c3f3b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0c0c0c0c0c3e0e0e3f0c0c0a0c0c3e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d3f0c1a1a1a1a1a1a1a1a1a1a1a1a0c3f3b2b2d2b2d2b2d2b2b2b2d2b2d2b2d2b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f090b09090a090c0c090b0c0c09093e1d1d1d1d1d1d0d0d0d0d1d1d1d1d1d1d3f0a1a1a1a1a1a1a1a1a1a1a1a1a0a3f3b2b2c2b2c2b2c2b2b2b2c2b2c2b2c2b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0c0b0c090b0c0a090c090c090c0b3e1d0c090a091d0d0d0d0d1d0a0b090c1d3f0c1a1a1a1a1a1a1a1a1a1a1a1a0c3f3b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f090a090c090c0c0a0c0a0a0c0c093e1d090a0b0a1d0d0d0d0d1d090c0b091d3f0c1a1a1a1a1a1a1a1a1a1a1a1a0a3f3b2b2d2b2d2b2d2b2b2b2d2b2d2b2d2b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0b0b0c0c0a090c0b090c09090b0a3e1d0b0c090a1d0d0d0d0d1d0b0a0a0a1d3f0a1a1a1a1a1a1a1a1a1a1a1a1a0a3f3b2b2c2b2c2b2c2b2b2b2c2b2c2b2c2b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0c090c090c0b09090b090c0c090b3e1d0b090c0b1d0d0d0d0d1d0c090b091d3f0b0a0c0a0c0a0c0c0a0c0c090a0b3f3b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d1d1d1d1d1d1d0d0d0d0d1d1d1d1d1d1d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3b3b3b3b3b3b3b2b2b2b2d2d2d2d2d2d2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b2b2b2b2b2b2e2e2e2e2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b2e2e1e2e2e2e2e2e2e2e2e1e2e2e2b2b1a1a1a1a1a1a1a1a1a1a1a1a1a2b2b1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b2e1e2e2e2e2e2e2e2e2e2e2e1e2e2b2b1a1a1a1a1a1a1a1a1a1a1a1a1a1a2b1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b1e2e2e2e2e2e2e2e2e2e2e2e2e1e2b2b1a1a1a1a1a1a1a1a1a1a1a1a1a1a2b1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b2e2e2e2e2e2e2e2e2e2e2e2e2e2e2b2b1a1a1a1a1a1a1a1a1a1a1a1a1a1a2b1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b2e2e2e2e2e2e2e2e2e2e2e2e2e2e2b2b1a1a1a1a1a1a1a1a1a1a1a1a1a1a2b2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f1f1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b2e2e2e2e2e2e2e2e2e2e2e2e2e2e2b2b1a1a1a1a1a1a1a1a1a1a1a1a1a1a2b2f2f2f2f2f2f2f2f2f2f2f2f1f1f1f1f1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b2e2e2e2e2e2e2e2e2e2e2b2d2b2e2b2b1a1a1a1a1a1a1a1a1a1a1a1a1a1a2b2f2f2f2f2f1f1f1f1f2f2f2f1f1f1f1f1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b2e2e2e2e2e2e2e2e2e2e2b2c2b2e2b2b1a1a1a1a1a1a1a1a1a1a1a1a1a1a2b2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f1f1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b2e2e2e2e2e2e2e2e2e2e2b2b2b2e2b2b1a1a1a1a1a1a1a1a1a1a1a1a1a1a2b1f1f2f2f2f2f2f2f2f2f2f2f1f1f1f1f1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b2e2e2e2e2e2e2e2e2e2e2e2e2e2e2b2b1a1a1a1a1a1a1a1a1a1a1a1a1a1a2b1f1f2f2f2f2f2f2f2f2f2f2f2f2f2f1f1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b2e2e2e2e2e2e2e2e2e2e2e2e2e2e2b2b1a1a1a1a1a1a1a1a1a1a1a1a1a1a2b1f1f2f2f2f2f1f2f2f1f2f2f1f1f1f1f1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b1e2e2e2e2e2e2e2e2e2e2e2e2e1e2b2b1a1a1a1a1a1a1a1a1a1a1a1a1a1a2b1f1f2f2f2f2f1f2f2f1f2f2f1f1f1f1f1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b2e1e2e2e2e2e2e2e2e2e2e2e1e2e2b2b1a1a1a1a1a1a1a1a1a1a1a1a1a1a2b1f1f2f2f2f2f1f2f2f1f2f2f2f2f2f1f1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b2e2e1e2e2e2e2e2e2e2e2e1e2e2e2b2b1a1a1a1a1a1a1a1a1a1a1a1a1a1a2b1f1f2f2f2f2f1f2f2f1f2f2f1f1f1f1f1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b2b2b2b2b2b2e2e2e2e2b2b2b2b2b2b2b2b2b2b2b2b1a1a1a1a2b2b2b2b2b2b1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400000705007050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
