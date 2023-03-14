SCBumpDynamicBodies = Core.class()

function SCBumpDynamicBodies:init(xtiny, xcworld, xgcam)
	self.tiny = xtiny -- new a ref so we can remove entities from tiny system
	self.tiny.processingSystem(self) -- called once on init and every frames
	self.cworld = xcworld -- cbump world
	self.gcam = xgcam -- rrraptor gideros camera (put here for shakes)
	-- audio fx
	local bgambience = Sound.new("audio/ambience/birds, rain, light breeze, trees crackle.wav")
	local bgchannel = bgambience:play(0,true)
	bgchannel:setVolume(0.4)
	self.sndplayer1hurt = Sound.new("audio/sfx/sfx_deathscream_human14.wav")
	self.sndcoin = Sound.new("audio/sfx/sfx_coin_double1.wav")
	self.sndnmeshoot = Sound.new("audio/sfx/sfx_wpn_laser4.wav")
	self.channel = self.sndplayer1hurt:play(0, false, true)
	self.channel2 = self.sndcoin:play(0, false, true)
end

function SCBumpDynamicBodies:filter(ent) -- tiny function
	return ent.body and ent.isactor
end

function SCBumpDynamicBodies:onAdd(ent) -- tiny function
end

function SCBumpDynamicBodies:onRemove(ent) -- tiny function
end

local col
local visibilitydistance = myappwidth*0.5
function SCBumpDynamicBodies:process(ent, dt) -- tiny function
	-- physics flags
	ent.isfloorcontacts = false
	ent.iswallcontacts = false
	ent.isladdercontacts = false
	ent.isptpfcontacts = false
	ent.ismvpfcontacts = false
	ent.isspringcontacts = false

--	ent.isextrafloorcontacts = false
--	ent.isextramvpffloorcontacts = false

	local function dosound(xchannelid, xsound)
		if xchannelid == 1 then
			if not self.channel:isPlaying() then self.channel = xsound:play() end
			self.channel:setVolume(0.3)
		elseif xchannelid == 2 then
			if not self.channel2:isPlaying() then self.channel2 = xsound:play() end
			self.channel2:setVolume(0.3)
		end
	end

	-- collision filter
	local function collisionfilter(item, other) -- "touch", "cross", "slide", "bounce"
		if item.isplayer1 or item.isnme then -- all actors
			if other.isextrafloor or other.isextramvpffloor then return "cross"
			elseif other.isfloor then return "slide"
			elseif other.isplayer1 then return "slide"
			elseif other.isnme then
				if item.body.vy > 0 then return "bounce"
				else return "slide"
				end
			elseif other.iscollectible then return "cross"
			elseif other.isladder then return "cross"
			elseif other.isblock then
				if item.wasonladder then
					if item.body.vy < 0 then -- going up
						return "bounce"
					end
				end
			elseif other.isptpf then
				if item.isdown and item.isup then -- prevents ptpf while holding both up and down keys XXX
					item.wasdown = true
					item.wasup = true
				end
				if item.isdown and not item.wasdown then
					return "cross"
				end
				if item.body.vy > 0 then -- going down
					local itembottom = item.y + item.h
					local otherbottom = other.y
					if itembottom <= otherbottom then return "slide" end
				end
			elseif other.ismvpf then -- can pass through
				if item.isdown and item.isup then -- prevents pt mvpf while holding both up and down keys XXX
					item.wasdown = true
					item.wasup = true
				end
				if item.isdown and not item.wasdown then -- pass through
					return "cross"
				end
				if item.body.vy > 0 then -- going down
					local itembottom = item.y + item.h
					local otherbottom = other.y + 2 -- some margin
					if itembottom <= otherbottom then return "slide" end
				end
			elseif other.isspring then return "slide"
			end
		elseif item.ispprojectile and other.isnme then return "touch" -- cross
		elseif item.iseprojectile and other.isplayer1 then return "touch" -- cross
		end
	end
	-- player1
	if self.cworld.player1.isdirty and not self.cworld.player1.isdead then
		dosound(1, self.sndplayer1hurt)
		self.cworld.player1.health -= 1
--		print(self.cworld.player1.health)
		self.cworld.player1.sprite:setColorTransform(2, 0.5, 0.5, 1)
		self.cworld.player1.washurt = 10
		self.cworld.player1.isdirty = false
		if self.cworld.player1.health <= 0 then
			self.cworld.player1.isdead = true
		end
	end
	-- nmes
	for i = #self.cworld.nmes, 1, -1 do -- scan in reverse
		if self.cworld.nmes[i].isdirty then -- destroy
			self.cworld.nmes[i].health -= 1
			self.cworld.nmes[i].washurt = 5
			self.cworld.nmes[i].sprite:setColorTransform(1, 2, 1, 2)
			self.cworld.nmes[i].isdirty = false
			if self.cworld.nmes[i].health <= 0 then
				self.cworld.nmes[i].sprite:setColorTransform(1, 1.5, 1, 1)
				self.tiny.worlds:removeEntity(self.cworld.nmes[i]) -- SDrawable removed from cbump world on system remove (=dead)
				self.cworld.nmes[i] = nil
				table.remove(self.cworld.nmes, i)
			end
		else
			-- shoot
			if math.distance(
					self.cworld.nmes[i].x, self.cworld.nmes[i].y,
					self.cworld.player1.x, self.cworld.player1.y) < 200 and -- 300
--					math.sign(self.cworld.nmes[i].body.vx) == -math.sign(self.cworld.player1.body.vx) then
					(math.sign(self.cworld.nmes[i].body.vx) == -1 and
--						(math.sign(self.cworld.player1.body.vx) == 0 or math.sign(self.cworld.player1.body.vx) == 1)) or
						math.sign(self.cworld.player1.body.vx) == 1) or
					(math.sign(self.cworld.nmes[i].body.vx) == 1 and
--						(math.sign(self.cworld.player1.body.vx) == 0 or math.sign(self.cworld.player1.body.vx) == -1))
						math.sign(self.cworld.player1.body.vx) == -1)
						then
				if self.cworld.nmes[i].shoottimer <= 0 then
					self.cworld.nmes[i].shoottimer = 50
				end
			end
			-- perfs? XXX
			if math.distance(
					self.cworld.nmes[i].x, self.cworld.nmes[i].y,
					self.cworld.player1.x, self.cworld.player1.y) > visibilitydistance then -- don't draw
				self.cworld.nmes[i].sprite:setVisible(false)
			else
				if not self.cworld.nmes[i].sprite:isVisible() then
					self.cworld.nmes[i].sprite:setVisible(true)
				end
			end
		end
	end
	-- coins
	for i = #self.cworld.coins, 1, -1 do -- scan in reverse
		if self.cworld.coins[i].isdirty then -- destroy
			dosound(1, self.sndcoin)
			self.tiny.worlds:removeEntity(self.cworld.coins[i]) -- removed from cbump world on system remove (=dead)
			self.cworld.coins[i] = nil
			table.remove(self.cworld.coins, i)
		else -- perfs? XXX
			if math.distance(
					self.cworld.coins[i].x, self.cworld.coins[i].y,
					self.cworld.player1.x, self.cworld.player1.y) > visibilitydistance then -- don't draw
				self.cworld.coins[i].sprite:setVisible(false)
			else
				self.cworld.coins[i].sprite:setVisible(true)
			end
		end
	end
	-- projectiles
	for i = #self.cworld.projectiles, 1, -1 do -- scan in reverse
		if self.cworld.projectiles[i].isdirty then -- destroy
			self.tiny.worlds:removeEntity(self.cworld.projectiles[i]) -- removed from cbump world on system remove (=dead)
			self.cworld.projectiles[i] = nil
			table.remove(self.cworld.projectiles, i)
		else -- move projectiles
			if self.cworld.projectiles[i].flip < 0 then
				self.cworld.projectiles[i].isleft = true
				self.cworld.projectiles[i].isright = false
			else
				self.cworld.projectiles[i].isright = true
				self.cworld.projectiles[i].isleft = false
			end
		end
	end
	-- cbump
	local goalx = ent.x + ent.body.vx
	local goaly = ent.y + ent.body.vy
	local nextx, nexty, collisions, len = self.cworld:move(ent, goalx, goaly, collisionfilter)
	--  _____ ____  _      _      _____  _____ _____ ____  _   _  _____ 
	-- / ____/ __ \| |    | |    |_   _|/ ____|_   _/ __ \| \ | |/ ____|
	--| |   | |  | | |    | |      | | | (___   | || |  | |  \| | (___  
	--| |   | |  | | |    | |      | |  \___ \  | || |  | | . ` |\___ \ 
	--| |___| |__| | |____| |____ _| |_ ____) |_| || |__| | |\  |____) |
	-- \_____\____/|______|______|_____|_____/|_____\____/|_| \_|_____/ 
	for i = 1, len do
		col = collisions[i]
		-- FROM ANY SIDES
		if col.item.isplayer1 then
			if col.other.iscollectible then col.other.isdirty = true end
			if col.other.isnme then
				if col.normal.x ~= 0 then
--					print(col.normal.x)
					col.item.body.vy = -col.item.body.jumpspeed
					col.item.body.vx = col.normal.x * col.item.body.speed
					col.item.isdirty = true
				end
			end
		end
		if col.item.iseprojectile then
			if col.other.isplayer1 then
				col.item.isdirty = true
				col.other.isdirty = true
			end
		end
		if col.item.ispprojectile then
			if col.other.isnme then
				col.item.isdirty = true
				col.other.isdirty = true
			end
		end
		if col.other.iswall then
			col.item.iswallcontacts = true
		end
		if col.other.isladder then
			col.item.currcoyotetimer = col.item.coyotetimer + 4 -- magik XXX
			col.item.isladdercontacts = true
			col.item.isextrafloorcontacts = false
			col.item.isextramvpffloorcontacts = false
		end
		if col.other.isblock then
			if col.item.wasonladder then
				col.item.body.vy *= -0.01
				col.item.wasonladder = false
			end
		end
		if col.other.ismvpf then -- controls movements on mvpfs or not?
			col.item.currcoyotetimer = col.item.coyotetimer + 4 -- magik XXX
			if col.item.body.vy > 0 then -- going down
				local itembottom = col.item.y + col.item.h
				local otherbottom = col.other.y + 2 -- some margin
				if itembottom < otherbottom then
--					print(itembottom, otherbottom)
					col.item.ismvpfcontacts = true
				end
			end
			if col.item.isleft and not col.item.isright and col.other.body.vx < 0 then
				col.item.body.vx = -col.item.body.speed*0.9
			elseif col.item.isright and not col.item.isleft and col.other.body.vx < 0 then
				col.item.body.vx = col.item.body.speed*0.9
			elseif (col.item.isleft and col.item.isright) and col.other.body.vx < 0 then
				col.item.body.vx = col.other.body.vx
			elseif not(col.item.isleft and col.item.isright) and col.other.body.vx < 0 then
				col.item.body.vx = col.other.body.vx
			elseif col.item.isleft and not col.item.isright and col.other.body.vx > 0 then
				col.item.body.vx = -col.item.body.speed*0.9
			elseif col.item.isright and not col.item.isleft and col.other.body.vx > 0 then
				col.item.body.vx = col.item.body.speed*0.9
			elseif (col.item.isleft and col.item.isright) and col.other.body.vx > 0 then
				col.item.body.vx = col.other.body.vx
			elseif not (col.item.isleft and col.item.isright) and col.other.body.vx > 0 then
				col.item.body.vx = col.other.body.vx
			elseif col.item.isleft and not col.item.isright and col.other.body.vx == 0 then
				col.item.body.vx = -col.item.body.speed*0.9
			elseif col.item.isright and not col.item.isleft and col.other.body.vx == 0 then
				col.item.body.vx = col.item.body.speed*0.9
			elseif (col.item.isleft and col.item.isright) and col.other.body.vx == 0 then
				col.item.body.vx = 0
			elseif not (col.item.isleft and col.item.isright) and col.other.body.vx == 0 then
				col.item.body.vx = 0
			end
		end
		-- nmes
		if col.item.isnme then
			if col.item.actorAI.dx then -- change direction when reaching dx limits
				if col.item.x > col.item.actorAI.startpositionx + col.item.actorAI.dx then
					col.item.isleft, col.item.isright = true, false
				elseif col.item.x < col.item.actorAI.startpositionx - col.item.actorAI.dx then
					col.item.isleft, col.item.isright = false, true
				end
			end
			if col.item.actorAI.dy then -- change direction when reaching dy limits
				if col.item.y > col.item.actorAI.startpositiony + col.item.actorAI.dy then
					col.item.isup, col.item.isdown = true, false
				elseif col.item.y < col.item.actorAI.startpositiony - col.item.actorAI.dy then
					col.item.isup, col.item.isdown = false, true
				end
			end
			if col.normal.x == 1 or col.normal.x == -1 then -- change direction upon hitting obstacles
				col.item.isleft, col.item.isright = not col.item.isleft, not col.item.isright
			end
		end
		-- COLLISION FROM TOP
		if col.normal.y == -1 then
			if col.other.isextrafloor then
				col.item.isextrafloorcontacts = true
				col.item.isextramvpffloorcontacts = false
			elseif col.other.isextramvpffloor then
				col.item.isextramvpffloorcontacts = true
				col.item.isextrafloorcontacts = false
			elseif col.other.isfloor then
				col.item.body.vy = 0 -- reset velocity y (don't accumulate gravity)
				col.item.isfloorcontacts = true
				col.item.isextrafloorcontacts = false
				col.item.isextramvpffloorcontacts = false
				col.item.currcoyotetimer = col.item.coyotetimer
			elseif col.other.isptpf then
				col.item.body.vy = 0 -- reset velocity y (don't accumulate gravity)
				col.item.isptpfcontacts = true
				col.item.isextrafloorcontacts = false
				col.item.isextramvpffloorcontacts = false
				col.item.currcoyotetimer = col.item.coyotetimer
			elseif col.other.ismvpf then
--				col.item.body.vy = 0 -- don't reset velocity y because platform can move on y axis
				col.item.ismvpfcontacts = true
				col.item.isextrafloorcontacts = false
				col.item.isextramvpffloorcontacts = false
			elseif col.other.isspring then
				col.item.isspringcontacts = true
				col.item.isextrafloorcontacts = false
				col.item.isextramvpffloorcontacts = false
			elseif col.other.isnme then
				col.item.body.vy = -col.item.body.jumpspeed*0.8 -- magik XXX, linked to 'stomp'
				col.other.isdirty = true
			elseif col.other.isplayer1 then
				col.item.body.vy = -col.item.body.jumpspeed
				col.other.isdirty = true
			end
		end
	end
--  _____  _    ___     _______ _____ _____  _____ 
-- |  __ \| |  | \ \   / / ____|_   _/ ____|/ ____|
-- | |__) | |__| |\ \_/ / (___   | || |    | (___  
-- |  ___/|  __  | \   / \___ \  | || |     \___ \ 
-- | |    | |  | |  | |  ____) |_| || |____ ____) |
-- |_|    |_|  |_|  |_| |_____/|_____\_____|_____/ 
	if self.cworld.player1.restart then -- press R anytime to restart level
		self.cworld.player1.restart = false
		scenemanager:changeScene("levelX", 2, transitions[math.random(#transitions)], easings[math.random(#easings)])
	end
	if ent.isdead then
		ent.animation.curranim = g_ANIM_LOSE1_R
		self.cworld.losescreen:setPosition(self.cworld.player1.x, self.cworld.player1.y)
		self.cworld.losescreen:setVisible(true)
		self.cworld.player1.sprite:setColorTransform(255*2/255, 255/255, 255/255, 1)
		self.cworld.player1.animation.bmp:setY(self.cworld.player1.animation.bmp:getY()-1)
		if self.cworld.player1.restart or self.cworld.player1.animation.bmp:getY() < -200 then
			self.cworld.player1.restart = false
			scenemanager:changeScene("levelX", 2, transitions[math.random(#transitions)], easings[math.random(#easings)])
		end
		return
	else
		ent.body.vy += g_gravity * ent.body.currmass
		if ent.wasonmvpf then
			ent.body.vy = ent.body.jumpspeed*0.25
			ent.wasonmvpf = false
		end
		-- coyote time
		if ent.currcoyotetimer > 0 then
			ent.currcoyotetimer -= 1
		end
		if ent.washurt and ent.washurt > 0 then
			ent.washurt -= 1
			if ent.washurt <= 0 then
				ent.sprite:setColorTransform(1, 1, 1, 1)
			end
		end
		if ent.shoottimer and ent.shoottimer > 0 then
			ent.shoottimer -= 1
			if ent.shoottimer <= 0 then
				dosound(2, self.sndnmeshoot)
				ent.isaction1 = true
			end
		end
		-- destroy projectiles after a certain distance
		if ent.ispprojectile or ent.iseprojectile then
			if ent.x > ent.actorAI.startpositionx + ent.actorAI.dx then ent.isdirty = true
			elseif ent.x < ent.actorAI.startpositionx - ent.actorAI.dx then ent.isdirty = true
			end
		end
		-- IS ON EXTRA FLOOR
		if ent.isextrafloorcontacts then
--			print("isonextrafloor", dt)
			if ent.isleft and not ent.isright and not ent.isdirty then -- LEFT
				if ent.animation then ent.animation.curranim = g_ANIM_RUN_R end
				ent.flip = -1
				ent.body.vx = -ent.body.speed
			elseif ent.isright and not ent.isleft and not ent.isdirty then -- RIGHT
				if ent.animation then ent.animation.curranim = g_ANIM_RUN_R end
				ent.flip = 1
				ent.body.vx = ent.body.speed
			else
				if ent.animation then ent.animation.curranim = g_ANIM_IDLE_R end
				ent.body.vx = 0
			end
			if ent.isup and not ent.isdown and not ent.wasup then -- UP
				if ent.animation then ent.animation.frame = 0 end -- one shot animation, new 20221129 XXX
				ent.body.vy = -ent.body.jumpspeed
				ent.isextrafloorcontacts = false
				ent.wasup = true
			elseif ent.isdown and not ent.isup then -- DOWN
			end
		-- IS ON EXTRA MVPF FLOOR
		elseif ent.isextramvpffloorcontacts then
--			print("isonextramvpffloor", dt)
			if ent.isleft and not ent.isright and not ent.isdirty then -- LEFT
				if ent.animation then ent.animation.curranim = g_ANIM_RUN_R end
				ent.flip = -1
			elseif ent.isright and not ent.isleft then -- RIGHT
				if ent.animation then ent.animation.curranim = g_ANIM_RUN_R end
				ent.flip = 1
			else
				if ent.animation then ent.animation.curranim = g_ANIM_IDLE_R end
			end
			if ent.isup and not ent.isdown and not ent.wasup then -- UP
				if ent.animation then ent.animation.frame = 0 end -- one shot animation, new 20221129 XXX
				ent.body.vy = -ent.body.jumpspeed
				ent.isextramvpffloorcontacts = false
				ent.wasup = true
			elseif ent.isdown and not ent.isup and not ent.wasdown then -- DOWN
				ent.body.vy = ent.body.jumpspeed*0.1
				ent.wasdown = true
			end
		-- IS ON FLOOR
		elseif ent.isfloorcontacts and
				not ent.iswallcontacts and
				not ent.isladdercontacts and
				not ent.isptpfcontacts and
				not ent.ismvpfcontacts
				then
--			print("isonfloor", dt)
			if ent.isleft and not ent.isright and not ent.isdirty then -- LEFT
				if ent.animation then ent.animation.curranim = g_ANIM_RUN_R end
				ent.flip = -1
				ent.body.vx = -ent.body.speed
			elseif ent.isright and not ent.isleft and not ent.isdirty then -- RIGHT
				if ent.animation then ent.animation.curranim = g_ANIM_RUN_R end
				ent.flip = 1
				ent.body.vx = ent.body.speed
			else
				if ent.animation then ent.animation.curranim = g_ANIM_IDLE_R end
				ent.body.vx = 0
			end
			if ent.isup and not ent.isdown and not ent.wasup then -- UP
				if ent.animation then ent.animation.frame = 0 end -- one shot animation
				ent.body.vy = -ent.body.jumpspeed
				ent.wasup = true
			elseif ent.isdown and not ent.isup then -- DOWN
			end
		-- IS ON LADDER
		elseif not ent.isfloorcontacts and
				not ent.iswallcontacts and
				ent.isladdercontacts and
				not ent.isptpfcontacts and
				not ent.ismvpfcontacts
				then
--			print("isonladder", dt)
			if ent.isleft and not ent.isright then -- LEFT
				if ent.animation then ent.animation.curranim = g_ANIM_LADDERUP end
				ent.flip = -1
				ent.body.vx = -ent.body.speed*0.5
			elseif ent.isright and not ent.isleft then -- RIGHT
				if ent.animation then ent.animation.curranim = g_ANIM_LADDERUP end
				ent.flip = 1
				ent.body.vx = ent.body.speed*0.5
			else
				if ent.animation then ent.animation.curranim = g_ANIM_LADDERIDLE end
				ent.body.vx = 0
			end
			if ent.isup and not ent.isdown then -- UP
--				print("isonladder u", dt)
				if ent.animation then ent.animation.curranim = g_ANIM_LADDERUP end
				ent.body.vy = -ent.body.jumpspeed*0.1 -- magik XXX
				ent.wasup = false
			elseif ent.isdown and not ent.isup then -- DOWN
--				print("isonladder d", dt)
				if ent.animation then ent.animation.curranim = g_ANIM_LADDERDOWN end
				ent.body.vy = ent.body.jumpspeed*0.1 -- magik XXX
				ent.wasdown = false
			else
				ent.body.vy = 0
			end
			ent.wasonladder = true
		-- IS ON PTPF
		elseif not ent.isfloorcontacts and
				not ent.iswallcontacts and
				not ent.isladdercontacts and
				ent.isptpfcontacts and
				not ent.ismvpfcontacts
				then
--			print("isonptpf", dt)
			ent.wasonladder = false
			if ent.isleft and not ent.isright then -- LEFT
				if ent.animation then ent.animation.curranim = g_ANIM_RUN_R end
				ent.flip = -1
				ent.body.vx = -ent.body.speed
			elseif ent.isright and not ent.isleft then -- RIGHT
				if ent.animation then ent.animation.curranim = g_ANIM_RUN_R end
				ent.flip = 1
				ent.body.vx = ent.body.speed
			else
				if ent.animation then ent.animation.curranim = g_ANIM_IDLE_R end
				ent.body.vx = 0
			end
			if ent.isup and not ent.isdown and not ent.wasup then -- UP
				if ent.animation then ent.animation.frame = 0 end -- one shot animation
				ent.body.vy = -ent.body.jumpspeed
				ent.wasup = true
			elseif ent.isdown and not ent.isup and not ent.wasdown then -- DOWN
				ent.body.vy = ent.body.jumpspeed*0.1
				ent.wasdown = true
			end
		-- IS ON MVPF
		elseif not ent.isfloorcontacts and
				not ent.iswallcontacts and
				not ent.isladdercontacts and
				not ent.isptpfcontacts and
				ent.ismvpfcontacts
				then
--			print("isonmvpf", dt)
			if ent.isleft and not ent.isright then -- LEFT
				if ent.animation then ent.animation.curranim = g_ANIM_WALK_R end
				ent.flip = -1
			elseif ent.isright and not ent.isleft then -- RIGHT
				if ent.animation then ent.animation.curranim = g_ANIM_WALK_R end
				ent.flip = 1
			else
				if ent.animation then ent.animation.curranim = g_ANIM_IDLE_R end
			end
			if ent.isup and not ent.isdown and not ent.wasup then -- UP
				if ent.animation then ent.animation.frame = 0 end -- one shot animation
				ent.body.vy = -ent.body.jumpspeed
--				ent.wasup = true -- if set to true cannot jump!
			elseif ent.isdown and not ent.isup and not ent.wasdown then -- DOWN
				ent.body.vy = ent.body.jumpspeed*0.1
				ent.wasdown = true
			end
			ent.wasonmvpf = true
		-- IS ON SPRING
		elseif ent.isspringcontacts then -- controllable heights :-)
--			print("isonspring", dt)
			if ent.isup and not ent.isdown then
				if ent.animation then ent.animation.frame = 0 end -- one shot animation
				ent.body.vy = -ent.body.vy*1.1 -- increase vy
			elseif ent.isdown and not ent.isup then
				if ent.animation then ent.animation.frame = 0 end -- one shot animation
				ent.body.vy = -ent.body.vy*0.7 -- decrease vy
			else
				if ent.animation then ent.animation.frame = 0 end -- one shot animation
				ent.body.vy = -ent.body.vy -- normal vy
--				ent.body.vy = -ent.body.jumpspeed -- normal vy
			end
--			print(ent.body.vy) -- -50 -- cap
			if ent.body.vy > -12 then print("x") ent.body.vy = -12
			elseif ent.body.vy < -40 then print("y") ent.body.vy = -40
			end
		-- IS IN THE AIR
		else
--			print("isintheair", dt)
			-- anims
			if ent.body.vy < 0 then -- going UP
				if ent.animation then ent.animation.curranim = g_ANIM_JUMPUP_R end
			else -- going DOWN
				if ent.animation then ent.animation.curranim = g_ANIM_JUMPDOWN_R end
			end
			-- movements
			if ent.isleft and not ent.isright and not ent.isdirty then -- LEFT
				ent.flip = -1
				ent.body.vx = -ent.body.speed
			elseif ent.isright and not ent.isleft and not ent.isdirty then -- RIGHT
				ent.flip = 1
				ent.body.vx = ent.body.speed
			else
				ent.body.vx = 0
			end
			if ent.isup and not ent.isdown and not ent.wasup then -- UP
				-- coyote time
				if ent.currcoyotetimer > 0 then
					ent.body.vy = -ent.body.jumpspeed
					ent.currcoyotetimer = 0
				end
				if ent.animation then ent.animation.frame = 0 end -- one shot animation
				ent.wasup = true
			elseif ent.isdown and not ent.isup and not ent.wasdown then -- DOWN 'stomp'
				ent.body.vy = ent.body.jumpspeed*0.8 -- magik XXX
				ent.wasdown = true
			end
		end
		-- shoot
		if ent.isaction1 then
			ent.isaction1 = false
			self:throw(ent)
		end
	end
	-- move & flip
	ent.x, ent.y = nextx, nexty
	ent.sprite:setPosition(ent.x, ent.y)
	if ent.animation then ent.animation.bmp:setScale(ent.sx * ent.flip, ent.sy) end
end

--local sprite
function SCBumpDynamicBodies:throw(ent)
	local pprojectile = "gfx/projectiles/Swap-Tap-Anim1.png"
	local pcols, prows, panimspeed = 1, 1, 1
	local psx = 0.8
	local pbodyw, pbodyh = 128*0.8*0.5, 128*0.8*0.5
	local poffsetx, poffsety = 38, 32
	local pspeed, pjumpspeed = 8*2, 0
	local pdx, pdy = 64*5, 0 -- shooting distance
	if ent.isnme then -- nme projectile
		pprojectile = "gfx/fx/Bokeh.png"
		psx = 0.25
		pbodyw, pbodyh = 64*0.5, 64*0.5
		poffsetx, poffsety = 64*3.8, 64*3
		pspeed, pjumpspeed = 8*1, 0
		pdx, pdy = 64*4, 0 -- shooting distance
	end
--	sprite = Bitmap.new(Texture.new("gfx/projectiles/Swap-Tap-Anim1.png", true))
	local g = EActor.new(self.cworld.projectileslayer, {
--		shape=sprite, -- fixed image
		x=ent.x, y=ent.y,
		animtexpath=pprojectile, cols=pcols, rows=prows, animspeed=panimspeed, -- animated image
		animations={
			{g_ANIM_DEFAULT, 1, 1},
		},
		sx=psx,
		bodyw=pbodyw, bodyh=pbodyh,
		defaultmass=0.025,
		offsetx=poffsetx, offsety=poffsety,
		speed=pspeed, jumpspeed=pjumpspeed,
		flip=ent.flip,
		dx=pdx, dy=pdy, -- shooting distance
	})
	if ent.isplayer1 then -- player projectile
		g.ispprojectile = true -- ECS id, IMPORTANT! XXX
	else -- nmes projectile
		g.iseprojectile = true -- ECS id, IMPORTANT! XXX
	end
	g.isactor = true -- ECS id, IMPORTANT! XXX
	self.cworld.projectiles[#self.cworld.projectiles + 1] = g -- add p and e projectiles to the same list? XXX
	self.cworld:add(g, g.x, g.y, g.w, g.h)
	self.tiny.worlds:addEntity(g)
	g = nil -- cleanup?
	-- info to test if bodies are removed from worlds
--	print(#self.cworld.coins, #self.cworld.nmes, #self.cworld.projectiles) -- OK
--	print(self.tiny.worlds:getEntityCount(), self.tiny.worlds:getSystemCount()) -- OK
end
