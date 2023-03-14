SMotionAI = Core.class()

function SMotionAI:init(xtiny, xcworld)
	xtiny.processingSystem(self) -- called once on init and every frames
	self.cworld = xcworld -- cbump world
end

function SMotionAI:filter(ent) -- tiny function
	return ent.motionAI
end

function SMotionAI:onAdd(ent) -- tiny function
--	print("SMotionAI:onAdd")
end

function SMotionAI:onRemove(ent) -- tiny function
--	print("SMotionAI:onRemove")
end

function SMotionAI:process(ent, dt) -- tiny function
	local function collisionfilter(item, other) -- ""touch", "cross", "slide", "bounce"
--		return "cross"
		-- nothing won't process collisions as well as cross
	end
	-- cbump
	local goalx = ent.x + ent.body.vx
	local goaly = ent.y + ent.body.vy
	local nextx, nexty, _collisions, _len = self.cworld:move(ent, goalx, goaly, collisionfilter)
	-- motion ai
	if ent.motionAI.dx and ent.motionAI.dy then -- DIAGONAL
		if ent.x >= ent.motionAI.startpositionx + ent.motionAI.dx - ent.w then
			ent.isleft, ent.isright = true, false
			ent.isup, ent.isdown = true, false
		elseif ent.x <= ent.motionAI.startpositionx then
			ent.isleft, ent.isright = false, true
			ent.isup, ent.isdown = false, true
		end
--		if ent.y >= ent.motionAI.startpositiony + ent.motionAI.dy - ent.h then
--			ent.isleft, ent.isright = true, false
--			ent.isup, ent.isdown = true, false
--		elseif ent.y <= ent.motionAI.startpositiony then
--			ent.isleft, ent.isright = false, true
--			ent.isup, ent.isdown = false, true
--		end
	elseif ent.motionAI.dx then -- HORIZONTAL OK
		if ent.x >= ent.motionAI.startpositionx + ent.motionAI.dx - ent.w then
			ent.isleft, ent.isright = true, false
		elseif ent.x <= ent.motionAI.startpositionx then
			ent.isleft, ent.isright = false, true
		end
	elseif ent.motionAI.dy then -- VERTICAL OK
		if ent.y >= ent.motionAI.startpositiony + ent.motionAI.dy - ent.h then
			ent.isup, ent.isdown = true, false
		elseif ent.y <= ent.motionAI.startpositiony then
			ent.isup, ent.isdown = false, true
		end
	end
	-- movement
	if ent.isleft and not ent.isright then -- LEFT
		ent.flip = -1
		ent.body.vx = -ent.body.speed
	elseif ent.isright and not ent.isleft then -- RIGHT
		ent.flip = 1
		ent.body.vx = ent.body.speed
	end
	if ent.isup and not ent.isdown then -- UP
		ent.body.vy = -ent.body.jumpspeed
	elseif ent.isdown and not ent.isup then -- DOWN
		ent.body.vy = ent.body.jumpspeed
	end
	-- move & flip
	ent.x, ent.y = nextx, nexty
	ent.sprite:setPosition(ent.x, ent.y)
	if ent.animation then
		ent.animation.bmp:setScale(ent.sx * ent.flip, ent.sy)
	end
end
