SCBumpDynamicBodies = Core.class()

function SCBumpDynamicBodies:init(xtiny, xcworld, xgcam)
	self.tiny = xtiny
	self.tiny.processingSystem(self) -- called once on init and every frames
	self.cworld = xcworld -- cbump world
	self.gcam = xgcam -- rrraptor gideros camera (put here for shakes)
end

function SCBumpDynamicBodies:filter(ent) -- tiny function
	return ent.body and ent.isactor
end

local col
function SCBumpDynamicBodies:process(ent, dt) -- tiny function
	-- physics flags
	ent.isfloorcontacts = false
	ent.iswallcontacts = false
	ent.isladdercontacts = false
	ent.isptpfcontacts = false
	ent.ismvpfcontacts = false
	ent.isspringcontacts = false
	-- collision filter
	local function collisionfilter(item, other) -- "touch", "cross", "slide", "bounce"
		if item.isplayer1 or item.isnme then -- all actors
			if other.isfloor then return "slide"
			elseif other.isplayer1 then return "cross"
			elseif other.isnme then return "cross"
			elseif other.iscollectible then return "cross"
			elseif other.isladder then return "cross"
			elseif other.isptpf then
				if item.isdown and item.isup then -- prevents ptpf while holding both up and down keys
					item.wasdown = true
					item.wasup = true
				end
				if item.isdown and not item.wasdown then return "cross" end
				if item.body.vy > 0 then -- going down
					local itembottom = item.y + item.h
					local otherbottom = other.y
					if itembottom <= otherbottom then return "slide" end
				end
			elseif other.ismvpf then -- can pass through
				if item.isdown and item.isup then -- prevents pt mvpf while holding both up and down keys
					item.wasdown = true
					item.wasup = true
				end
				if item.isdown and not item.wasdown then return "cross" end -- pass through
				if item.body.vy > 0 then -- going down
					local itembottom = item.y + item.h
					local otherbottom = other.y + 2 -- some margins 2
					if itembottom <= otherbottom then return "slide" end
				end
			elseif other.isspring then
				if item.body.vy > 0 then -- going down
--					return "bounce"
					return "slide"
				end
			end
		elseif item.ispprojectile and other.isnme then return "touch"
		elseif item.iseprojectile and other.isplayer1 then return "touch"
		end
	end
	-- nmes
	for i = #self.cworld.nmes, 1, -1 do -- scan in reverse
		if self.cworld.nmes[i].isdirty then -- destroy
			self.tiny.world:removeEntity(self.cworld.nmes[i])
			self.cworld.nmes[i] = nil
			table.remove(self.cworld.nmes, i)
		end
	end
	-- projectiles
	for i = #self.cworld.projectiles, 1, -1 do -- scan in reverse
		if self.cworld.projectiles[i].isdirty then -- destroy
			self.tiny.world:removeEntity(self.cworld.projectiles[i])
			self.cworld.projectiles[i] = nil
			table.remove(self.cworld.projectiles, i)
		else -- move
			if self.cworld.projectiles[i].flip < 0 then
				self.cworld.projectiles[i].isleft = true
				self.cworld.projectiles[i].isright = false
			else
				self.cworld.projectiles[i].isright = true
				self.cworld.projectiles[i].isleft = false
			end
		end
	end
	-- coins
	for i = #self.cworld.coins, 1, -1 do -- scan in reverse
		if self.cworld.coins[i].isdirty then -- destroy
			self.tiny.world:removeEntity(self.cworld.coins[i])
			self.cworld.coins[i] = nil
			table.remove(self.cworld.coins, i)
		end
	end
	-- cbump
	local goalx = ent.x + ent.body.vx
	local goaly = ent.y + ent.body.vy
	local nextx, nexty, collisions, len = self.cworld:move(ent, goalx, goaly, collisionfilter)
	-- COLLISIONS
	for i = 1, len do
		col = collisions[i]
		-- FROM ANY SIDES
		if col.other.iscollectible and col.item.isplayer1 then col.other.isdirty = true end
		if col.other.isnme and col.item.ispprojectile then
			col.other.isdirty = true
			col.item.isdirty = true
		end
		if col.other.isplayer1 and col.item.iseprojectile then
			col.other.isdirty = true
			col.item.isdirty = true
		end
		if col.other.iswall then col.item.iswallcontacts = true end
		if col.other.isladder then col.item.isladdercontacts = true end
		if col.other.ismvpf then -- controls movements on mvpfs
			col.item.ismvpfcontacts = true
			col.item.resetvy = true
			if col.item.isleft and not col.item.isright and col.other.body.vx < 0 then
				col.item.body.vx = -col.item.body.speed*0.7
			elseif col.item.isright and not col.item.isleft and col.other.body.vx < 0 then
				col.item.body.vx = col.item.body.speed*0.1
			elseif (col.item.isleft and col.item.isright) and col.other.body.vx < 0 then
				col.item.body.vx = col.other.body.vx
			elseif not(col.item.isleft and col.item.isright) and col.other.body.vx < 0 then
				col.item.body.vx = col.other.body.vx
			elseif col.item.isleft and not col.item.isright and col.other.body.vx > 0 then
				col.item.body.vx = -col.item.body.speed*0.1
			elseif col.item.isright and not col.item.isleft and col.other.body.vx > 0 then
				col.item.body.vx = col.item.body.speed*0.7
			elseif (col.item.isleft and col.item.isright) and col.other.body.vx > 0 then
				col.item.body.vx = col.other.body.vx
			elseif not (col.item.isleft and col.item.isright) and col.other.body.vx > 0 then
				col.item.body.vx = col.other.body.vx
			elseif col.item.isleft and not col.item.isright and col.other.body.vx == 0 then
				col.item.body.vx = -col.item.body.speed*0.5
			elseif col.item.isright and not col.item.isleft and col.other.body.vx == 0 then
				col.item.body.vx = col.item.body.speed*0.5
			elseif (col.item.isleft and col.item.isright) and col.other.body.vx == 0 then
				col.item.body.vx = 0
			elseif not (col.item.isleft and col.item.isright) and col.other.body.vx == 0 then
				col.item.body.vx = 0
			end
		end
		-- FROM TOP OR BOTTOM
		if col.normal.y == 1 or col.normal.y == -1 then
			if col.other.isfloor then
				col.item.isfloorcontacts = true
				col.item.resetvy = true
			end
			if col.other.isptpf then
				col.item.isptpfcontacts = true
				col.item.resetvy = true
			end
			if col.other.isspring then
				if col.normal.y == -1 then -- collide from above
					col.item.isspringcontacts = true
				end
			end
		end
	end
	-- gravity (only applied when in the air), better/faster solutions? XXX
	if not (ent.isfloorcontacts and ent.iswallcontacts and ent.isladdercontacts and ent.isptpfcontacts and ent.ismvpfcontacts) then
		ent.body.vy += g_gravity * ent.body.currentmass * 0.05 -- 0.05
		if ent.body.vy >= 0.1 and ent.body.vy < 0.2 then
			if ent.animation then ent.animation.frame = 0 end -- one shot animation, new 20221129 XXX
		end
		if ent.body.vy > 24 then ent.body.vy = 24 end -- cap
	end
	-- IS ON FLOOR
	if ent.isfloorcontacts == true and
			ent.iswallcontacts == false and
			ent.isladdercontacts == false and
			ent.isptpfcontacts == false and
			ent.ismvpfcontacts == false
			then
--		print("isonfloor", dt)
		if ent.isleft and not ent.isright then -- LEFT
			if ent.animation then ent.animation.currentanim = g_ANIM_RUN_R end
			ent.flip = -1
			ent.body.vx = -ent.body.speed
		elseif ent.isright and not ent.isleft then -- RIGHT
			if ent.animation then ent.animation.currentanim = g_ANIM_RUN_R end
			ent.flip = 1
			ent.body.vx = ent.body.speed
		else
			if ent.animation then ent.animation.currentanim = g_ANIM_IDLE_R end
			ent.body.vx = 0
		end
		if ent.isup and not ent.isdown and not ent.wasup then -- UP
			if ent.animation then ent.animation.frame = 0 end -- one shot animation, new 20221129 XXX
			ent.resetvy = false
			ent.body.vy = -ent.body.jumpspeed
		elseif ent.isdown and not ent.isup then -- DOWN
		end
	-- IS ON LADDER
	elseif ent.isfloorcontacts == false and
			ent.iswallcontacts == false and
			ent.isladdercontacts == true and
			ent.isptpfcontacts == false and
			ent.ismvpfcontacts == false
			then
--		print("isonladder", dt)
		if ent.isleft and not ent.isright then -- LEFT
			if ent.animation then ent.animation.currentanim = g_ANIM_LADDERUP end
			ent.flip = -1
			ent.body.vx = -ent.body.speed*0.5
		elseif ent.isright and not ent.isleft then -- RIGHT
			if ent.animation then ent.animation.currentanim = g_ANIM_LADDERUP end
			ent.flip = 1
			ent.body.vx = ent.body.speed*0.5
		else
			if ent.animation then ent.animation.currentanim = g_ANIM_LADDERIDLE end
			ent.body.vx = 0
		end
		if ent.isup and not ent.isdown then -- UP
			if ent.animation then ent.animation.currentanim = g_ANIM_LADDERUP end
			ent.body.vy = -ent.body.jumpspeed*0.1
		elseif ent.isdown and not ent.isup then -- DOWN
			if ent.animation then ent.animation.currentanim = g_ANIM_LADDERDOWN end
			ent.body.vy = ent.body.jumpspeed*0.1
		else
			ent.body.vy = 0
		end
	-- IS ON PTPF
	elseif ent.isfloorcontacts == false and
			ent.iswallcontacts == false and
			ent.isladdercontacts == false and
			ent.isptpfcontacts == true and
			ent.ismvpfcontacts == false
			then
--		print("isonptpf", dt)
		if ent.isleft and not ent.isright then -- LEFT
			if ent.animation then ent.animation.currentanim = g_ANIM_RUN_R end
			ent.flip = -1
			ent.body.vx = -ent.body.speed
		elseif ent.isright and not ent.isleft then -- RIGHT
			if ent.animation then ent.animation.currentanim = g_ANIM_RUN_R end
			ent.flip = 1
			ent.body.vx = ent.body.speed
		else
			if ent.animation then ent.animation.currentanim = g_ANIM_IDLE_R end
			ent.body.vx = 0
		end
		if ent.isup and not ent.isdown and not ent.wasup then -- UP
			if ent.animation then ent.animation.frame = 0 end -- one shot animation, new 20221129 XXX
			ent.resetvy = false
			ent.body.vy = -ent.body.jumpspeed
		elseif ent.isdown and not ent.isup and not ent.wasdown then -- DOWN
			ent.wasdown = true
			ent.body.vy = ent.body.jumpspeed*0.1
		end
	-- IS ON MVPF
	elseif ent.isfloorcontacts == false and
			ent.iswallcontacts == false and
			ent.isladdercontacts == false and
			ent.isptpfcontacts == false and
			ent.ismvpfcontacts == true
			then
--		print("isonmvpf", dt)
		if ent.isleft and not ent.isright then -- LEFT
			if ent.animation then ent.animation.currentanim = g_ANIM_WALK_R end
			ent.flip = -1
		elseif ent.isright and not ent.isleft then -- RIGHT
			if ent.animation then ent.animation.currentanim = g_ANIM_WALK_R end
			ent.flip = 1
		else
			if ent.animation then ent.animation.currentanim = g_ANIM_IDLE_R end
		end
		if ent.isup and not ent.isdown and not ent.wasup then -- UP
			if ent.animation then ent.animation.frame = 0 end -- one shot animation, new 20221129 XXX
			ent.resetvy = false
			ent.body.vy = -ent.body.jumpspeed
		elseif ent.isdown and not ent.isup and not ent.wasdown then -- DOWN
			ent.wasdown = true
			ent.body.vy = ent.body.jumpspeed*0.1
		end
	-- IS ON SPRING
	elseif ent.isspringcontacts then -- controllable heights :-)
--		print("isonspring", dt)
		if ent.isup and not ent.isdown then
			if ent.animation then ent.animation.frame = 0 end -- one shot animation, new 20221129 XXX
			ent.body.vy = -ent.body.vy*1.05 -- increase vy
		elseif ent.isdown and not ent.isup then
			if ent.animation then ent.animation.frame = 0 end -- one shot animation, new 20221129 XXX
			ent.body.vy = -ent.body.vy*0.80 -- decrease vy
		else
			if ent.animation then ent.animation.frame = 0 end -- one shot animation, new 20221129 XXX
			ent.body.vy = -ent.body.vy -- normal vy
		end
		if ent.body.vy < -2000 then ent.body.vy = -2000 -- cap
		end
	-- IS IN THE AIR
	else
--		print("isintheair", dt)
		if ent.resetvy then
			ent.body.vy = 0
			ent.resetvy = false
		end
		-- anims
		if ent.body.vy < 0 then
			if ent.animation then ent.animation.currentanim = g_ANIM_JUMPUP_R end
		else
			if ent.animation then ent.animation.currentanim = g_ANIM_JUMPDOWN_R end
		end
		-- movements
		if ent.isleft and not ent.isright then -- LEFT
			ent.flip = -1
			ent.body.vx = -ent.body.speed
		elseif ent.isright and not ent.isleft then -- RIGHT
			ent.flip = 1
			ent.body.vx = ent.body.speed
		else
			ent.body.vx = 0
		end
		if ent.isup and not ent.isdown then -- UP
			ent.wasup = true
		elseif ent.isdown and not ent.isup then -- DOWN
			ent.wasdown = true
		end
	end
	-- shoot
	if ent.isaction1 then
		ent.isaction1 = false
		self:throw(ent)
	end
	-- move & flip
	ent.x, ent.y = nextx, nexty
	ent.sprite:setPosition(ent.x, ent.y)
	if ent.animation then ent.animation.bmp:setScale(ent.sx * ent.flip, ent.sy) end
end

--local sprite
function SCBumpDynamicBodies:throw(ent)
--	sprite = Bitmap.new(Texture.new("gfx/projectiles/Swap-Tap-Anim1.png", true))
	local g = EActor.new(self.cworld.projectileslayer, {
--		x=ent.x-16, y=ent.y,
--		shape=sprite,
		x=ent.x-28, y=ent.y-36,
		animtexpath="gfx/projectiles/rel-fgems128a.png", cols=4, rows=3, animspeed=1/16,
		animations={
			{g_ANIM_DEFAULT, 1, 12},
		},
		sx=1.2,
--		bodyw=32, bodyh=32,
		defaultmass=0.2,
		offsetx=64/1.2/2, offsety=64/2/1.2,
		speed=8*1.9, jumpspeed=1,
		flip=ent.flip,
		dx=64*6, --dy=256,
	})
	if ent.isplayer1 then -- player projectile
		g.ispprojectile = true -- ECS id, IMPORTANT! XXX
	else -- nmes projectile
		g.iseprojectile = true -- ECS id, IMPORTANT! XXX
	end
	g.isactor = true -- ECS id, IMPORTANT! XXX
	self.cworld.projectiles[#self.cworld.projectiles + 1] = g -- add p and e projectiles to the same list? XXX
	self.cworld:add(g, g.x, g.y, g.w, g.h)
	self.tiny.world:addEntity(g)
	g = nil -- cleanup?
	-- info to test if bodies are removed from worlds
--	print(#self.cworld.coins, #self.cworld.nmes, #self.cworld.projectiles) -- OK
--	print(self.tiny.world:getEntityCount(), self.tiny.world:getSystemCount()) -- OK
end

function SCBumpDynamicBodies:onAdd(ent) -- tiny function
end

function SCBumpDynamicBodies:onRemove(ent) -- tiny function
end
