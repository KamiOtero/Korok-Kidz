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
    kid_sprite=65
    kid_animation=0
    frog_sprite=80
    mid_1=44 --for walls/entries
    mid_2=84 --for walls/entries
    dialog_cooldown=0
    flip_y=false
    backyard_marble=false
    house_marble=false
    townsquare_marble=false
    junkyard_marble=false
    school_marble=false
    playground_marble=false
    library_marble=false
    win_marble=false
    win=false
    level=1 --for minigame
    count=1 --for animations

    intro=true

    --pre-initialize
    dtb_init()
    --first state
    logo_init()
end

--state handling
function _update()
    dtb_update()
    if state=="logo" then logo_update()
    elseif state=="menu" then menu_update()
    elseif state=="minigame" then update_minigame()
    elseif state=="credits" then credits_update()
	else game_update() end
end

function _draw()
    if state=="logo" then logo_draw()
    elseif state=="menu" then menu_draw()
    elseif state=="minigame" then draw_minigame()
    elseif state=="credits" then credits_draw()
	else game_draw() end
end

--gameplay 
function game_init()
	state="game"
	--hitboxes
	player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15} -- adjusted for sprite
	top_border={0,0,127,0}
	left_border={0,0,0,127}
	right_border={127,0,127,127}
    bottom_border={0,127,127,127}
    door_top1_border={0,0,mid_1+5,0}
    door_top2_border={mid_2-5,0,127,0}
    door_left1_border={0,0,0,mid_1+5}
    door_left2_border={0,mid_2-5,0,127}
    door_right1_border={127,0,127,mid_1+5}
    door_right2_border={127,mid_2-5,127,127}
    door_bottom1_border={0,127,mid_1+5,127}
    door_bottom2_border={mid_2-5,127,127,127}

	froggo={60,62,69,69}
    dialog_froggo={57,59,72,72}

    --set state
    update=game_update()
    draw=game_draw()
end


function game_update()
	state="game"
    if(dialog_cooldown >= 0) then dialog_cooldown = dialog_cooldown - 1 end
    move()
    map_update()

    if(map_state=="backyard") then 
        if(intro==true and (dialog_cooldown <= 0) ) then
            dtb_disp("oh hello there! help me find my marbles? maybe sir froggo knows. click 'z' near him to talk to him.")
            intro=false
        end
        --collide with froggo
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   froggo[1],froggo[2],froggo[3],froggo[4] )
        then
            blocked()
        end
        --in froggo dialog box
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   dialog_froggo[1],dialog_froggo[2],dialog_froggo[3],dialog_froggo[4] ) then
                
            if btn(4) and (dialog_cooldown <= 0) and backyard_marble==false then 
                dtb_disp("Oh hey i have one of your marbles! but youll have to play me for it. press 'x' to start the game")
                dialog_cooldown=200 --TODO coolddown is werid but necesary so dialog doesnt loop?
            end

            if btn(5) and backyard_marble==false then 
                level=1
                minigame_init()
            end

            if btn(4) and (dialog_cooldown <= 0) and backyard_marble==true then
                dtb_disp("nooo you got me, take good care of that preciouds marble")
                dialog_cooldown=100
            end
        end
    elseif(map_state=="house") then
        --collide with froggo
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   froggo[1],froggo[2],froggo[3],froggo[4] )
        then
            blocked()
        end
        --in npc dialog box
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   dialog_froggo[1],dialog_froggo[2],dialog_froggo[3],dialog_froggo[4] ) then
            if btn(4) and (dialog_cooldown <= 0) then 
                dtb_disp("hello welcome home")
                dialog_cooldown=100
            end
            if btn(5) and house_marble==false then 
                level=2
                minigame_init()
            end
        end
    elseif(map_state=="townsquare") then
		--collide with froggo
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   froggo[1],froggo[2],froggo[3],froggo[4] )
        then
            blocked()
        end
        --in npc dialog box
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   dialog_froggo[1],dialog_froggo[2],dialog_froggo[3],dialog_froggo[4] ) then
            if btn(4) and (dialog_cooldown <= 0) then 
                dtb_disp("this is the town square!")
                dialog_cooldown=100
            end
            if btn(5) and townsquare_marble==false then 
                level=3
                minigame_init()
            end
        end
    elseif(map_state=="junkyard")then
		--collide with froggo
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   froggo[1],froggo[2],froggo[3],froggo[4] )
        then
            blocked()
        end
        --in npc dialog box
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   dialog_froggo[1],dialog_froggo[2],dialog_froggo[3],dialog_froggo[4] ) then
            if btn(4) and (dialog_cooldown <= 0) then 
                dtb_disp("this is my junkyard >:c")
                dialog_cooldown=100
            end
            if btn(5) and junkyard_marble==false then 
                level=4
                minigame_init()
            end
        end
    elseif(map_state=="school") then
		--collide with froggo
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   froggo[1],froggo[2],froggo[3],froggo[4] )
        then
            blocked()
        end
        --in npc dialog box
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   dialog_froggo[1],dialog_froggo[2],dialog_froggo[3],dialog_froggo[4] ) then
            if btn(4) and (dialog_cooldown <= 0) then 
                dtb_disp("school is cool")
                dialog_cooldown=100
            end
            if btn(5) and school_marble==false then 
                level=5
                minigame_init()
            end
        end
    elseif(map_state=="playground") then
		--collide with froggo
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   froggo[1],froggo[2],froggo[3],froggo[4] )
        then
            blocked()
        end
        --in npc dialog box
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   dialog_froggo[1],dialog_froggo[2],dialog_froggo[3],dialog_froggo[4] ) then
            if btn(4) and (dialog_cooldown <= 0) then 
                dtb_disp("remember to take breaks and get some sunshine")
                dialog_cooldown=100
            end
            if btn(5) and playground_marble==false then 
                level=6
                minigame_init()
            end
        end
    elseif(map_state=="library") then
		--collide with froggo
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   froggo[1],froggo[2],froggo[3],froggo[4] )
        then
            blocked()
        end
        --in npc dialog box
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   dialog_froggo[1],dialog_froggo[2],dialog_froggo[3],dialog_froggo[4] ) then
            if btn(4) and (dialog_cooldown <= 0) then 
                dtb_disp("reading is cool")
                dialog_cooldown=100
            end
            if btn(5) and library_marble==false then 
                level=7
                minigame_init()
            end
        end
    elseif(map_state=="beach") then
		--collide with froggo
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   froggo[1],froggo[2],froggo[3],froggo[4] )
        then
            blocked()
        end
        --in npc dialog box
        if hitbox_collide(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],   dialog_froggo[1],dialog_froggo[2],dialog_froggo[3],dialog_froggo[4] ) then
            if btn(4) and (dialog_cooldown <= 0) then 
                dtb_disp("you win! one last game... for all the marbles???")
                dialog_cooldown=100
            end
            if btn(5) and win_marble==false then 
                level=8
                minigame_init()
            end
        end
    end

	
    --check for win condition
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
    --spr( n, x, y, [w,] [h,] [flip_x,] [flip_y] )
    spr(kid_sprite, player_x, player_y, 2, 2, flip_y, false)
    

	--rect(player_hitbox[1],player_hitbox[2],player_hitbox[3],player_hitbox[4],1)
	--rect(froggo[1],froggo[2],froggo[3],froggo[4],6)
    --rect(dialog_froggo[1],dialog_froggo[2],dialog_froggo[3],dialog_froggo[4],7)

    if(map_state=="backyard") then
        spr(frog_sprite, froggo[1], froggo[2], 1, 1)
    elseif(map_state=="house") then
        spr(frog_sprite, froggo[1], froggo[2], 1, 1)
    elseif(map_state=="townsquare") then
		spr(frog_sprite, froggo[1], froggo[2], 1, 1)
    elseif(map_state=="junkyard")then
		spr(frog_sprite, froggo[1], froggo[2], 1, 1)
    elseif(map_state=="school") then
		spr(frog_sprite, froggo[1], froggo[2], 1, 1)
    elseif(map_state=="playground") then
		spr(frog_sprite, froggo[1], froggo[2], 1, 1)
    elseif(map_state=="library") then
		spr(frog_sprite, froggo[1], froggo[2], 1, 1)
    elseif(map_state=="beach") then
        spr(frog_sprite, froggo[1], froggo[2], 1, 1)
    end


    --display collected marbles
    spr(56, 72, 0, 1, 1)
    spr(56, 80, 0, 1, 1)
    spr(56, 88, 0, 1, 1)
    spr(56, 96, 0, 1, 1)
    spr(56, 104, 0, 1, 1)
    spr(56, 112, 0, 1, 1)
    spr(56, 120, 0, 1, 1)

    --draws over empty circle if collected
    if (backyard_marble==true) spr(49, 72, 0, 1, 1)
    if (house_marble==true) spr(50, 80, 0, 1, 1)
    if (townsquare_marble==true) spr(51, 88, 0, 1, 1)
    if (junkyard_marble==true) spr(52, 96, 0, 1, 1)
    if (school_marble==true) spr(53, 104, 0, 1, 1)
    if (playground_marble==true) spr(54, 112, 0, 1, 1)
    if (library_marble==true) spr(55, 120, 0, 1, 1)

    
    if(win==true) then print("Lets go to the beach!!!", 20, 25, 7) end
    if(win_marble==true) then 
        --TODO add credits
        credits_init()
    end

    --debug
    --print(dialog_cooldown, 10, 10, 10) 

    --draw dialog
    dtb_draw()
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
    marble_sprite=48
    marblex = scr_w/2 - 3
    marbley = scr_h - 4
    marble_hitbox={marblex, marbley, marblex + 7, marbley + 7}
    speed = 3
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

    xmin=40
    xmax=40
    ymin=20
    ymax=40
    --add marbles in circle.
    if(level>=1) then
        marble2_sprite=49
        marble2x=xmin + rnd(xmax) 
        marble2y=ymin + rnd(ymax) 
        marble2_hitbox={marble2x, marble2y, marble2x + 7, marble2y + 7}
        marble2_hit = false

        if(level>=2) then
            marble2_sprite=32
            marble3_sprite=50
            marble3x=xmin + rnd(xmax)  
            marble3y=ymin + rnd(ymax) 
            marble3_hitbox={marble3x, marble3y, marble3x + 7, marble3y + 7}
            marble3_hit = false

            if(level>=3) then  
                marble2_sprite=32
                marble3_sprite=33              
                marble4_sprite=51
                marble4x=xmin + rnd(xmax)  
                marble4y=ymin + rnd(ymax)
                marble4_hitbox={marble4x, marble4y, marble4x + 7, marble4y + 7}
                marble4_hit = false
		
                if(level>=4) then
                    marble2_sprite=32
                    marble3_sprite=33              
                    marble4_sprite=34
                    marble5_sprite=52
                    marble5x=xmin + rnd(xmax)  
                    marble5y=ymin + rnd(ymax)
                    marble5_hitbox={marble5x, marble5y, marble5x + 7, marble5y + 7}
                    marble5_hit = false

                   if(level>=5) then
                        marble2_sprite=32
                        marble3_sprite=33              
                        marble4_sprite=34
                        marble5_sprite=35
                        marble6_sprite=53
                        marble6x=xmin + rnd(xmax) 
                        marble6y=ymin + rnd(ymax)
                        marble6_hitbox={marble6x, marble6y, marble6x + 7, marble6y + 7}
                        marble6_hit = false
		
                        if(level>=6) then
                            marble2_sprite=32
                            marble3_sprite=33              
                            marble4_sprite=34
                            marble5_sprite=35
                            marble6_sprite=36
                            marble7_sprite=54
                            marble7x=xmin + rnd(xmax)  
                            marble7y=ymin + rnd(ymax)
                            marble7_hitbox={marble7x, marble7y, marble7x + 7, marble7y + 7}
                            marble7_hit = false
	
                            if(level>=7) then
                                marble2_sprite=32
                                marble3_sprite=33              
                                marble4_sprite=34
                                marble5_sprite=35
                                marble6_sprite=36
                                marble7_sprite=37
                                marble8_sprite=55
                                marble8x=xmin + rnd(xmax)  
                                marble8y=ymin + rnd(ymax)
                                marble8_hitbox={marble8x, marble8y, marble8x + 7, marble8y + 7}
                                marble8_hit = false
                                if(level>=8)then
                                    --final beach level
                                    marble2_sprite=49
                                    marble3_sprite=50
                                    marble4_sprite=51
                                    marble5_sprite=52
                                    marble6_sprite=53
                                    marble7_sprite=54
                                    marble8_sprite=55
                                end
                            end
                        end
                    end
                end
            end
        end
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
			if powery1 >= 60 and powery1 <= 70 then speed=6 end
			if powery1 >= 70 and powery1 <= 80 then speed=4 end
			if powery1 >= 80 and powery1 <= 90 then speed=2 end
		end
		if select==true then
			main_marble_mover()

            if level>=1 then
                --marble2
                if hitbox_collide(marble_hitbox[1], marble_hitbox[2], marble_hitbox[3], marble_hitbox[4],   marble2_hitbox[1], marble2_hitbox[2], marble2_hitbox[3], marble2_hitbox[4])  then
                    marble2_hit=true
                end
                if marble2_hit == true then
                    marble2x+=speed --TODO: Update so it goes opposite of player marble
                    marble2y-=speed
                end
                if level>=2 then
                    --marble3
                    if hitbox_collide(marble_hitbox[1], marble_hitbox[2], marble_hitbox[3], marble_hitbox[4],   marble3_hitbox[1], marble3_hitbox[2], marble3_hitbox[3], marble3_hitbox[4])  then
                        marble3_hit=true
                    end
                    if marble3_hit == true then
                        marble3x-=speed
                        marble3y-=speed
                    end
                    if level>=3 then
                        --marble4
                        if hitbox_collide(marble_hitbox[1], marble_hitbox[2], marble_hitbox[3], marble_hitbox[4],   marble4_hitbox[1], marble4_hitbox[2], marble4_hitbox[3], marble4_hitbox[4])  then
                            marble4_hit=true
                        end
                        if marble4_hit == true then
                            marble4x+=speed
                            marble4y-=speed
                        end
                        if level>=4 then
                            --marble5
                            if hitbox_collide(marble_hitbox[1], marble_hitbox[2], marble_hitbox[3], marble_hitbox[4],   marble5_hitbox[1], marble5_hitbox[2], marble5_hitbox[3], marble5_hitbox[4])  then
                                marble5_hit=true
                            end
                            if marble5_hit == true then
                                marble5x-=speed
                                marble5y-=speed
                            end
                            if level>=5 then
                                --marble6
                                if hitbox_collide(marble_hitbox[1], marble_hitbox[2], marble_hitbox[3], marble_hitbox[4],   marble6_hitbox[1], marble6_hitbox[2], marble6_hitbox[3], marble6_hitbox[4])  then
                                    marble6_hit=true
                                end
                                if marble6_hit == true then
                                    marble6x-=speed
                                    marble6y-=speed
                                end
                                if level>=6 then
                                    --marble7
                                    if hitbox_collide(marble_hitbox[1], marble_hitbox[2], marble_hitbox[3], marble_hitbox[4],   marble7_hitbox[1], marble7_hitbox[2], marble7_hitbox[3], marble7_hitbox[4])  then
                                        marble7_hit=true
                                    end
                                    if marble7_hit == true then
                                        marble7x+=speed
                                        marble7y-=speed
                                    end
                                    if level>=7 then
                                        --marble8
                                        if hitbox_collide(marble_hitbox[1], marble_hitbox[2], marble_hitbox[3], marble_hitbox[4],   marble8_hitbox[1], marble8_hitbox[2], marble8_hitbox[3], marble8_hitbox[4])  then
                                            marble8_hit=true
                                        end
                                        if marble8_hit == true then
                                            marble8x-=speed
                                            marble8y-=speed
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
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
	if(level>=1) then 
        spr(marble2_sprite, marble2x, marble2y, marble_width, marble_height)
        if(level>=2) then 
            spr(marble3_sprite, marble3x, marble3y, marble_width, marble_height)
            if(level>=3) then
                spr(marble4_sprite, marble4x, marble4y, marble_width, marble_height)
                if(level>=4) then
                    spr(marble5_sprite, marble5x, marble5y, marble_width, marble_height)
                    if(level>=5) then
                        spr(marble6_sprite, marble6x, marble6y, marble_width, marble_height)
                        if(level>=6) then
                            spr(marble7_sprite, marble7x, marble7y, marble_width, marble_height)
                            if(level>=7) then
                                spr(marble8_sprite, marble8x, marble8y, marble_width, marble_height)
                                if(level>=8) then
                                    --anything special?
                                end
                            end
                        end
                    end
                end
            end
        end
    end

	--check win condition
	if(level==1) then 
		if(marble2_hit == true and marbley > 100 ) then backyard_marble=true state="game" end
	elseif(level==2) then 
		if(marble2_hit == true and marble3_hit == true and marbley > 100 ) then house_marble=true state="game" end
	elseif(level==3) then
		if(marble2_hit == true and marble3_hit == true and marble4_hit == true and marbley > 100 ) then townsquare_marble=true state="game" end
	elseif(level==4) then
		if(marble2_hit == true and marble3_hit == true and marble4_hit == true and marble5_hit == true and marbley > 100 ) then junkyard_marble=true state="game" end
	elseif(level==5) then
		if(marble2_hit == true and marble3_hit == true and marble4_hit == true and marble5_hit == true and marble6_hit == true and marbley > 100 ) then school_marble=true state="game" end
	elseif(level==6) then
		if(marble2_hit == true and marble3_hit == true and marble4_hit == true and marble5_hit == true and marble6_hit == true and marble7_hit == true and marbley > 100 ) then playground_marble=true state="game" end
	elseif(level==7) then
		if(marble2_hit == true and marble3_hit == true and marble4_hit == true and marble5_hit == true and marble6_hit == true and marble7_hit == true and marble8_hit == true and marbley > 100 ) then library_marble=true state="game" end
    elseif(level==8) then
		if(marble2_hit == true and marble3_hit == true and marble4_hit == true and marble5_hit == true and marble6_hit == true and marble7_hit == true and marble8_hit == true and marbley > 100 ) then win_marble=true state="game" end
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
        speed=2
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
    if (logo > 3) then menu_init() end
end

function logo_draw()
    state="logo"
    cls()
    sspr((logo*16), 0, 16, 16, logo_x, logo_y, 32, 32)
    print("korok kidz presents...",25,70,3)
    print("kool kid'z", 45, 80, 8)
    print("marble-ous adventure!",25,90,11)
end

--menu state
function menu_init()
    --variables for menu
    options = {"play!", "how to play", "quit"}
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
    if win_marble==true then map(16, 0, 0, 0, 128, 32) win_marble=false end --TODO add post-game map for menu
    --print froggo
    spr(frog_sprite,frog_x, frog_y, 1, 1)
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
    up = {100, 75, 100}
    down = {65, 96, 65}
    left = {-98, -73, -98}
    right = {71, 69, 71}
    framerate = 0.05
    flip_y=false
    --hitbox
    if btn(2) then player_hitbox[2]-=speed player_hitbox[4]-=speed end --up
    if btn(3) then player_hitbox[2]+=speed player_hitbox[4]+=speed end --down
    if btn(0) then player_hitbox[1]-=speed player_hitbox[3]-=speed end --left
    if btn(1) then player_hitbox[1]+=speed player_hitbox[3]+=speed end --right
    --player
    if btn(0) then player_x=player_x-speed --left
        if left[count] < 0 then
            kid_sprite=abs(left[count])
            flip_y=true
        else
            kid_sprite=left[count]
            flip_y=false
        end
        if (time() - kid_animation) > framerate then count+=1 kid_animation=time() end
        if count>=#left then count=1 end
    end
    if btn(1) then player_x=player_x+speed --right
        if right[count] < 0 then
            kid_sprite=abs(right[count])
            flip_y=true
        else
            kid_sprite=right[count]
            flip_y=false
        end
        if (time() - kid_animation) > framerate then count+=1 kid_animation=time() end
        if count>=#right then count=1 end
    end
    if btn(2) then player_y=player_y-speed --up
        if up[count] < 0 then
            kid_sprite=abs(up[count])
            flip_y=true
        else
            kid_sprite=up[count]
            flip_y=false
        end
        if (time() - kid_animation) > framerate then count+=1 kid_animation=time() end
        if count>=#up then count=1 end
    end
    if btn(3) then player_y=player_y+speed --down
        if down[count] < 0 then
            kid_sprite=abs(down[count])
            flip_y=true
        else
            kid_sprite=down[count]
            flip_y=false
        end
        if (time() - kid_animation) > framerate then count+=1 kid_animation=time() end
        if count>=#down then count=1 end
    end
end

-- if btn(1) then player sprite +=1 player.mirror=false end
-- if player sprite > 3 then player.sprite=1 end 

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
            if (player_x >= mid_1 and player_x <= mid_2) and (player_y <= -5) then
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
			if (player_x >= mid_1 and player_x <= mid_2) and (player_y <= -5) then
                map_state="townsquare"
                player_y = 100
                player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
			elseif (player_x >= mid_1 and player_x <= mid_2) and (player_y >= 128) then
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
			if (player_x >= mid_1 and player_x <= mid_2) and (player_y >= 128) then
                player_y=10
                player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
                map_state="playground"
			elseif (player_x >= 128) and (player_y >= mid_1 and player_y <= mid_2) then
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
        if (player_x <= -5) and (player_y >= mid_1 and player_y <= mid_2) then
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
        if (player_x >= mid_1 and player_x <= mid_2) and (player_y >= 128) then
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
        if (player_x >= mid_1 and player_x <= mid_2) and (player_y <= -5) then
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
			if (player_x >= mid_1 and player_x <= mid_2) and (player_y <= -5) then
                player_y=100 
                player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
                map_state="junkyard"
			elseif (player_x >= mid_1 and player_x <= mid_2) and (player_y >= 128) then
                player_y=10
                map_state="house"
                player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
			elseif (player_x <= -5) and (player_y >= mid_1 and player_y <= mid_2) then
                player_x=100
                map_state="school"
                player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
			elseif (player_x >= 128) and (player_y >= mid_1 and player_y <= mid_2) then
                player_x=10 
                map_state="library"
                player_hitbox={player_x+4, player_y+3, player_x+11, player_y+15}
			end
    end
    if map_state=="beach" then
        wallLeft()
        wallRight()
        wallBottom()
        wallTop()
    end
end


-->8
--dialog

--bellow needed for dialog found on lexaloffle: https://www.lexaloffle.com/bbs/?pid=35126 --

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

--thanks to https://www.lexaloffle.com/bbs/?tid=2706
function credits_init()
    text = "thanks for playing"
    f = 0
    state="credits"
    update=credits_update()
    draw=credits_draw()
end

function credits_update()
    f+=5
    state="credits"
end

function credits_draw()
    cls()
    local y
    local c
    local x = 128/2 - (#text*4)/2
    for c=1,#text do
        y = sin((x+f)/100) * 8
        color(5)
        print(sub(text,c,c),x,(64-4)+y)
        y = sin((x+10+f)/100) * 8
        color(7)
        print(sub(text,c,c),x,(64-4)+y)
        x = x+4
    end
    --state = "menu"
end


__gfx__
000000003000000000000000300000000000000030000000000000033000000000000000b3333b33333333333333333333333333444944495666566665666656
000000003000000000000000300000000000000030000000000000003000000000000a3a333f3333b3b333333333333333b33333999999995555555555666655
00000003b300000000000003b300000000000003b300000000000003b300000000bb333333f3f3333b3333333333c3333b333333494449446656665665666656
0000033bb33000000000033bb33000000000033bb33000000000033bb33000000b337377333f333b33333333333c3c33333333b3999999995555555555665655
00033bbb3334000000033bbb3334000000033bbb3334000000033bbb333400000337737033333333333333333333c33333333b33444944495666566665666656
033bbb3333333000033bbb3333333000033bbb3333333000033bbb333333300003777370b3b333a33333b3b333333333333333339999999955555b5b55666655
03bb03333333b40003bb33333333b40003bb33333333b40003bb33333333b400333733303b333a3a33333b333b3b333333333333494449443b3b33b3b33333b3
3bb0073333033b403bb0073333333b403bb3333333333b403bb3333333333b4000000000333333a33333333333b33333333333339999999933b3333333b33333
33300033300733433330003330073343333000333333334333300033333333430000000000000000ffffffff363636363333533344444444cccccccc44444444
33333333300033343333333330003334333333333000333433333333300033340000000000000000ffffff5f636363633663336344499444cccccccc24551449
33333333333333343333333333333334333333333333333433333333333333340000000000000000f55fffff363636366dd536d344999944cccccccc23551669
333303333333cc33333303333333cc33333303330333cc33333303330333cc330000000000000000ffffffff636363636d5536d349999994cccccccc23551669
03333003333cc33303333000333cc33303333000333cc33303333000333cc3330000000000000000ffffffff363636363553335349999994cccccccc23551669
03333333333c003003333333333c003003333333333c003003333333333c00300000000000000000ff5ff5ff636363633333633344999944cccccccc23551669
00333333333330000033333333333000003333333333300000333333333330000000000000000000ffffffff363636363336d53344499444cccccccc23551669
00033300003333000003330000333300000333000033330000033300003333000000000000000000fffffff5636363633336d53344444444cccccccc23551669
00cccc000088880000bbbb000099990000ffff00001111000044440000000000000000000000000000666dd06666666666666666666666662222222266dd66dd
0c1111c0082222800b3333b009aaaa900f7777f001cccc1004ffff40000000000000000000000000066ddddd6666666666666666666666662222222266dd66dd
c111111c82222228b333333b9aaaaaa9f777777f1cccccc14ffffff400000000000000000000000066dddddd66666666666666664444444422222222dd66dd66
c111111c82222228b333333b9aaaaaa9f777777f1cccccc14ffffff4000000000000000000000000666ddddd66666666658888564444444422222222dd66dd66
c111111c82222228b333333b9aaaaaa9f777777f1cccccc14ffffff4000000000000000000000000dddddd556666666666888866444444442222222266dd66dd
c111111c82222228b333333b9aaaaaa9f777777f1cccccc14ffffff4000000000000000000000000dddddd556666666666888866444444442222222266dd66dd
0c1111c0082222800b3333b009aaaa900f7777f001cccc1004ffff400000000000000000000000000d5d555566666666658888564444444422222222dd66dd66
00cccc000088880000bbbb000099990000ffff0000111100004444000000000000000000000000000055550066666666666666664444444422222222dd66dd66
001111000088880000bbbb00009999000011110000cccc000044440000777700006666000000000000000000444444440000000033333b3333b6555665556b33
01234510082222800b3333b009aaaa90012222100c1911c0049999400788887006777760000000000000000044444444000000003b3333b33b665656656565b3
16789ab182e22228b331a33b9aaa4aa9122dd221c191911c41919194787777876777777600000000000000004444444400000000bbb55b6633b5565565656b33
1cdef231822ee228b33a133b94aaa4a912deed21c919191c49191914787887876777777600000000000000004444444400000000555555553355555665656533
14567891822ee228b331a33b9a4aaa4912deed21c191919c41919194787887876777777600000000000000004444444400000000666666553356565655555b33
1abcdef182222e28b33a133b9aa4aaa9122dd221c119191c491919147877778767777776000000000000000044444444000000005555555533b65655556565b3
01234510082222800b3333b009aaaa90012222100c1191c004999940078888700677776000000000000000004444444400000000566556663b65565665656b33
001111000088880000bbbb00009999000011110000cccc00004444000077770000666600000000000000000044444444000000005555555533b5565665556533
cccccccc000111011110000000011101111000000000000011100000000000001110000000000000111000000000001114111000000000111411100000000000
cccccccc0014441444a100000014441444a10000000001114441000000000111444100000000011144410000000011444aa44100000011444aa4410000000000
cccccccc00014444444a100000014444444a1000000014444444100000001444444410000000144444aa10000001444744aa10000001444744aa100000000000
cccccccc00144444444aa10000144444444aa10000014444444441000001444444444100000144444aa44100001447447444a100001447447444a10000000000
11111111001444fff444a100001444fff444a1000000144444444100000014444444410000001444aa4441000014444444444100001444444444410000000000
18eeeee100011f1ff1f1100000011f1ff1f11000000144144ff14100000144144ff14100000144144ff141000001444444441000000144444444100000000000
18eeeee100001f1ff1f1000000001f1ff1f1000000014141f1f1100000014141f1f1100000014141f1f110000000144444441000000014444444100000000000
18eeeee1000151ffff151000000011ffff110000000011fff1f10000000011fff1f10000000011fff1f100000000114144111000000011414411000000000000
00000000001ff511115ff10000015511115510000000001fff1000000000001fff1000000000001fff1000000011f5111155f110000155111155100000000000
00000a3a01ff15555551ff10001f55555555f10000000151111100000000015111000000000001511111000001ff155555551ff10001f5555555f10000000000
00bb333300111cc555511100001f55555555f10000001155f1ff1000000001f55510000000001155f1ff100001ff1c5555551ff10001f5555555f10000000000
0b33737700001cccccc1000001ff1c5555c1ff100001f155ffff1000000001ff551000000001f155ffff100000111ccccccc1110001ffc55555cff1000000000
0337737000001ccc1cc1000001ff1cccccc1ff100001f155111100000000015ff51000000001f1551111000000001ccccccc1000001ffcccccccff1000000000
0377737000001cc11110000000111cc11cc11100000011ccc1000000000001cff1000000000011ccc100000000001ccc1ccc100000011ccc1ccc110000000000
333733300000144100000000000014444441000000014ccccc100000000001cc1000000000014ccccc100000000001111cc10000000011cc1cc1100000000000
00000000000001100000000000000111111000000001441144410000000001444100000000014411444100000000000014410000000001441441000000000000
00011101111000000000000011100000000000111411100000000000000000000000000000000000000000000000000000000000000000000000000000000000
0014441444a100000000011144410000000011444aa4410000000000000000000000000000000000000000000000000000000000000000000000000000000000
00014444444a10000000144444aa10000001444744aa100000000000000000000000000000000000000000000000000000000000000000000000000000000000
00144444444aa100000144444aa44100001447447444a10000000000000000000000000000000000000000000000000000000000000000000000444444440000
001444fff444a10000001444aa44410000144444444441000000000000000000000000000000000000000000000000000000000000000000000044f44f440000
00011f1ff1f11000000144144ff141000001444444441000000000000000000000000000000000000000000000000000000000000000000000004ffffff40000
00001f1ff1f1000000014141f1f110000000144444441000000000000000000000000000000000000000000000000000000000000000000000004f1ff1f40000
000151ffff151000000011fff1f100000000114144111000000000000000000000000000000000000000000000000000000000000000000000004effffe40000
001ff511115ff1000000001fff1000000011f5111155f11000000000000000000000000000000000000000000000000000000000000000000000400ff0040000
01ff15555511ff10000001511100000001ff155555551ff100000000000000000000000000000000000000000000000000000000000000000000055555500000
001115555cc11100000001f55510000001ff1c5555551ff100000000000000000000000000000000000000000000000000000000000000000000055557500000
00001cccccc10000000001ff5510000000111ccccccc1110000000000000000000000000000000000000000000000000000000000000000000000f5557f00000
00001ccc1cc100000000015ff510000000001ccccccc10000000000000000000000000000000000000000000000000000000000000000000000000cccc000000
000011111cc10000000001cff100000000001ccc1ccc100000000000000000000000000000000000000000000000000000000000000000000000001111000000
0000000014410000000001cc10000000000001cc1111000000000000000000000000000000000000000000000000000000000000000000000000001001000000
00000000011000000000014441000000000001441000000000000000000000000000000000000000000000000000000000000000000000000000001001000000
00000000000000000000000000000000000000000000000000011101111000000000000000000000000000000000000000000000000000000000000000000000
090009f0000090000660006600000000000000000000000000144414444100000000000000000000000000000000000000000000000000000000000000000000
9f909f90000099006667776660000000000000000000000000014444444410000000000000000000000000000000000000000000000000000000000000000000
99999990000099906677776660066000099ffff99000000000144444444441000000000000000000000000000000000000000000000000000000000000000000
0909099000000990660707666006670009ffffff90000000001444fff44441000000000000000000000000000000000000000000000000000000000000000000
0ff0ff4444444490667077666000070099f0f0ff9900000000141f1ff1f141000000000000000000000000000000000000000000000000000000000000000000
0fffff4444449990666777666000070099ff0fff9900000001441f1ff1f144100000000000000000000000000000000000000000000000000000000000000000
00cacc9999999ff0066a886677777000999ffff999000000144411ffff1144410000000000000000000000000000000000000000000000000000000000000000
00fffffffffffff000077777777770000003a330000000000111ee1111ee11100000000000000000000000000000000000000000000000000000000000000000
099fff000099fff00007777777777000000fffff00000000001feeeeeeeef1000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000777777770000000ffffff0000f00001feeeeeeeef1000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000607006700000000f9fff9ff00f0001ff1ceeeec1ff100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000707006700000000f9ff9fff0ff0001ff1cccccc1ff100000000000000000000000000000000000000000000000000000000000000000
0000000000000000000070700670000000ff9f9ffffff00000111cc11cc111000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000707005700000000000000000000000001444444100000000000000000000000000000000000000000000000000000000000000000000
00000000000000000006566056600000000000000000000000000111111000000000000000000000000000000000000000000000000000000000000000000000
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
00011101111000000001110111100000000000001110000000000000111000000000000011100000000000111411100000000011141110000001110111100000
0014441444a100000014441444a10000000001114441000000000111444100000000011144410000000011444aa44100000011444aa441000014441444a10000
00014444444a100000014444444a1000000014444444100000001444444410000000144444aa10000001444744aa10000001444744aa100000014444444a1000
00144444444aa10000144444444aa10000014444444441000001444444444100000144444aa44100001447447444a100001447447444a10000144444444aa100
001444fff444a100001444fff444a1000000144444444100000014444444410000001444aa44410000144444444441000014444444444100001444fff444a100
00011f1ff1f1100000011f1ff1f11000000144144ff14100000144144ff14100000144144ff141000001444444441000000144444444100000011f1ff1f11000
00001f1ff1f1000000001f1ff1f1000000014141f1f1100000014141f1f1100000014141f1f110000000144444441000000014444444100000001f1ff1f10000
0001a1ffff181000000011ffff110000000011fff1f10000000011fff1f10000000011fff1f10000000011414411100000001141441100000001a1ffff181000
001ff81111aff1000001a81111a810000000001fff1000000000001fff1000000000001fff1000000011f81111aaf1100001a81111aa1000001ff81111aff100
01ff1aa8aa81ff10001faaa8aa8af100000001a111110000000001a111000000000001a11111000001ff1aaaaa8a1ff10001faaaaa8af10001ff1a8aa811ff10
00111ccaa8a11100001fa8aaaaaaf1000000118af1ff1000000001fa8a1000000000118af1ff100001ff1c8aaaaa1ff10001faaaaaaaf100001118aaacc11100
00001cccccc1000001ff1c8aa8c1ff100001f1aaffff1000000001ffa81000000001f1aaffff100000111ccccccc1110001ffc8aaaacff1000001cccccc10000
00001ccc1cc1000001ff1cccccc1ff100001f1a811110000000001affa1000000001f1a81111000000001ccccccc1000001ffcccccccff1000001ccc1cc10000
00001cc11110000000111cc11cc11100000011ccc1000000000001cff1000000000011ccc100000000001ccc1ccc100000011ccc1ccc1100000011111cc10000
0000144100000000000014444441000000014ccccc100000000001cc1000000000014ccccc100000000001111cc10000000011cc1cc110000000000014410000
00000110000000000000011111100000000144114441000000000144410000000001441144410000000000001441000000000144144100000000000001100000
00000000111000000000001114111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000011144410000000011444aa4410000aaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000144444aa10000001444744aa10000aa98aa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000144444aa44100001447447444a100a8a9aaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001444aa4441000014444444444100aaa98aaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000144144ff14100000144444444100008a9aa800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00014141f1f1100000001444444410000aa9aaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000011fff1f1000000001141441110000aa9a8a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000001fff1000000011f81111aaf110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000001a11100000001ff1aaaaa8a1ff1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000001fa8a10000001ff1c8aaaaa1ff1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000001ffa810000000111ccccccc1110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000001affa10000000001ccccccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000001cff100000000001ccc1ccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000001cc10000000000001cc11110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000144410000000000014410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0e0e0e0e0e0e0e0f0e0e0e0e0e0e0e0e1d1d1d1d1d1d0d0d0d0d1d1d1d1d1d1d0e0e0e0e0e0e0e0c0c0e0e0e0e0e0e3f3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f091c0c0b1c1c1c1c1c1c0c1c0c093e1d090a090b1d0d0d0d0d1d090a0c0b1d3f1b1b1b1b1b1b0a0c1b1b1b1b1b1b3f3b1f1f1f2b2b2b2b2b2b2b2b1f1f1f3b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0c0c090c0b1c1c1c1c090b0c090c3e1d0b090a0c1d0d0d0d0d1d0b0c090a1d3f1b1b1b1b1b1b0c0b1b1b1b1b1b1b3f3b1f1f1f2b2b2b2b2b2b2b2b1f1f1f3b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0c0c0c0b1c090a1c0c090c0c0a0c3e1d0a0c090b1d0d0d0d0d1d090a0b091d3f0b0b09090c0c0a0c0c090c0b090b3f3b1f1f1f2b2b2b2b2b2b2b2b1f1f1f3b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f090c0c0a0b0a0a090a1c0c0c0b0c3e1d090b0c0a1d0d0d0d0d1d0c0b090a1d3f090c0c0c0b0c0c0c0a0c0a0c0c0b3f3b2b2b2b2b2b2b2b2b2b2b2b2b2b2b3b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0c0b090b0a0b0c0c0b0a0c0a0a0c3e1d1d1d1d1d1d0d0d0d0d1d1d1d1d1d1d3f0b0c0a0c0c0c0a0c0c0a0c0c0b0c3f3b2b2b2b2b2b2b2b2b2b2b2b2b2b2b3b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f090c0a090a3e3d3d3f0c090c090c3e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d3f0c0c0c0c0a1c1c1c1c0c0a0c0c0a3f3b2b2d2d2b2d2d2b2d2d2b2d2d2b2b2b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0c090c0c0c3e1e1e3f0c0b0c0c0c3e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d3f0c0a0c0c0c1c1e1e1c0a0c0a0c0c3f3b2b2c2c2b2c2c2b2c2c2b2c2c2b2b2b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0a0c0b0c093e1e1e3f090c0a0b0c3e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d3f0c1a1a1a1a1a1e1e1a1a1a1a1a0c3f3b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0c0c0c0c0c3e0e0e3f0c0c0a0c0c3e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d3f0c1a1a1a1a1a1a1a1a1a1a1a1a0c3f3b2b2d2d2b2d2d2b2d2d2b2d2d2b2b2b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f090b09090a090c0c090b0c0c09093e1d1d1d1d1d1d0d0d0d0d1d1d1d1d1d1d3f0a1a1a1a1a1a1a1a1a1a1a1a1a0a3f3b2b2c2c2b2c2c2b2c2c2b2c2c2b2b3b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0c0b0c090b0c0a090c090c090c0b3e1d0c1c0a091d0d0d0d0d1d0a0b090c1d3f0c1a1a1a1a1a1a1a1a1a1a1a1a0c3f3b2b2b2b2b2b2b2b2b2b2b2b2b2b2b3b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f090a090c090c0c0a0c0a0a0c0c093e1d1c1e1e1c1d0d0d0d0d1d090c0b091d3f0c1a1a1a1a1a1a1a1a1a1a1a1a0a3f3b2b2e2e2e2e2e2e2e2e2e2e2e2b2b3b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0b0b0c0c0a090c0b090c09090b0a3e1d0b1e1e0a1d0d0d0d0d1d0b0a0a0a1d3f0a1a1a1a1a1a1a1a1a1a1a1a1a0a3f3b2b2e2e2e2e2e2e2e2e2e2e2e2b2b3b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f0c090c090c0b09090b090c0c090b3e1d0b091c0b1d0d0d0d0d1d0c090b091d3f0b0a0c0a0c0a0c0c0a0c0c090a0b3f3b2b2b2b2b2b2b2b2b2b2b2b2b2b2b3b2b3c3c3c3c3c3c3c3c3c3c3c3c3c3c2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d1d1d1d1d1d1d0d0d0d0d1d1d1d1d1d1d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3b3b3b3b3b3b3b2b2b2b3b3b3b3b3b3b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3b3b3b3b2e2e2e2e3b3b3b3b3b3b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b1f1f1f1f3b2e2e2e2e3b3b3b3b3b3b1b1c1c0c1a1a1a1a1a1a1a1a1a0c1c1b1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f3b1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b1f1f1f1f2e2e2e2e2e2e2e2e2e3b3b1b1c0c1a1a1a1a1a1a1a1a1a0c0c0c1b3b3b2f2f2f2f2f2f2f2f2f2f2f2f2f3b1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b2e2e2e2e2e2e2e2e2e2e2e2e2e3b3b1b1a1a0c1a1a1a1a1a1a1a1a1a1c1a1b1f1f2f2f2f3b3b3b3b2f2f2f3b3b3b3b1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b2e2e2e2e2e2e2e2e2e2e2e2e2e3b3b1b0c1a1a1a1a1a1a1a1a1a1a1a1a1c1b3b3b2f2f2f2c2c2c2c2f2f2f1f1f1f3b1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b2e2b2c2c2b2e2e2e2e2e2e2e2e3b3b1b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1b1f1f2f2f2f2f2f2f2f2f2f2f2f2f2f3b1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b2e2b3b3b2b2e2e2e2e2e2e2e2e3b3b1b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1b2f2f2f2f2f3b3b3b3b2f2f2f3b3b3b3b1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b2e2b2c2c2b2e2e2e2e2e2e2e2e3b3b1b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1b2f2f2f2f2f1f1f1f1f2f2f2f1f1f1f3b1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b2e2e2e2e2e2e2e2e2e2e2e2e2e2e3b1b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1b2f2f2f2f2f2f2f2f2f2f2f2f1f1f1f3b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b2e2e2e2e2e2e2e2e2e2e2e2e2e2e3b1b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1b2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f3b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b2e2e2e3b3b2e2e2e2e3b3b2e2e3b3b1b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1b3b3b2f2f2f2f2f2f2f2f2f2f3b3b3b3b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b2e2e2e2e3b2e2e2e2e3b2e2e2e2e3b1b0c1a1a1a1a1a1a1a1a1a1a1a1a1a1b1f1f2f2f2f2f3b2f2f3b2f2f1f1f1f3b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b2e2e2e2e3b2e2e2e2e3b2e2e2e2e3b1b1a1a0c1a1a1a1a1a1a1a1a1a1a1c1b1f1f2f2f2f2f1f2f2f1f2f2f2f2f2f3b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b2e1e2e2e3b2e2e2e2e3b2e1e1e2e3b1b1c0c1a1a1a1a1a1a1a1a1a0c1c0c1b3b3b2f2f2f2f1f2f2f1f2f2f3b3b3b3b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b401f1f3b2e2e2e2e3b3b40403b3b1b1c1c0c1a1a1a1a1a1a1a0c1a0c1c1b1f1f2f2f2f2f1f2f2f1f2f2f1f1f1f3b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3b3b3b3b2e2e2e2e3b3b3b3b3b3b1b1b1b1b1b1b1a1a1a1a1b1b1b1b1b1b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400000705007050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
