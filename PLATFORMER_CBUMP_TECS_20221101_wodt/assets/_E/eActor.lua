EActor = Core.class()

function EActor:init(xspritelayer, xparams)
	-- params
	self.spritelayer = xspritelayer
	local params = xparams or {}
	params.x = xparams.x or 0
	params.y = xparams.y or 0
	params.shape = xparams.shape or nil -- ready sprite
	params.animtexpath = xparams.animtexpath or nil
	params.cols = xparams.cols or nil
	params.rows = xparams.rows or nil
	params.animspeed = xparams.animspeed or nil
	params.animations = xparams.animations or nil -- animname, startatframe, endatframe
	params.bodyw = xparams.bodyw or nil
	params.bodyh = xparams.bodyh or params.bodyw
	params.offsetx = xparams.offsetx or 0
	params.offsety = xparams.offsety or 0
	params.sx = xparams.sx or 1
	params.sy = xparams.sy or params.sx
	params.flip = xparams.flip or 1
	params.speed = xparams.speed or nil
	params.jumpspeed = xparams.jumpspeed or nil
	params.dx = xparams.dx or nil
	params.dy = xparams.dy or nil
	params.defaultmass = xparams.defaultmass or 0.1
	params.motionai = xparams.motionai or nil
	params.dokeep = xparams.dokeep or nil
	-- params
	self.x = params.x
	self.y = params.y
	self.sx = params.sx
	self.sy = params.sy
	self.flip = params.flip
	self.dokeep = params.dokeep
	self.coyotetimer = 10
	self.currcoyotetimer = self.coyotetimer
	self.health = params.health or 1
	-- let's go!
	if params.shape then
		self.sprite = params.shape
		self.sprite:setScale(params.sx, params.sy)
		self.w, self.h = self.sprite:getSize()
		self.sprite:setPosition(self.x, self.y)
	-- COMPONENTS
	elseif params.animtexpath then
		-- ANIMATION
		--function CAnimation:init(xspritesheetpath, xcols, xrows, xanimspeed, xoffx, xoffy, sx, sy)
		self.animation = CAnimation.new(
			params.animtexpath, params.cols, params.rows, params.animspeed,
			params.offsetx, params.offsety, params.sx, params.sy
		)
		self.sprite = self.animation.sprite
		self.animation.sprite = nil -- free some memory?
		-- create animations
		if params.animations then
			for _, v in pairs(params.animations) do
				--function CAnimation:createAnim(xanimname, xstart, xfinish)
				self.animation:createAnim(v[1], v[2], v[3])
			end
			self.animation.myanimsimgs = nil -- free some memory
		end
		-- params 2
		self.sprite:setScale(self.sx, self.sy)
		self.w, self.h = params.bodyw or self.sprite:getWidth(), params.bodyh or self.sprite:getHeight()
		self.sprite:setPosition(self.x, self.y)
	end
	if params.speed or params.jumpspeed then
		-- BODY
		--function CBody:init(xspeed, xjumpspeed)
		self.body = CBody.new(params.speed, params.jumpspeed)
		self.body.defaultmass = params.defaultmass
		self.body.currmass = self.body.defaultmass
	end
	if params.dx or params.dy then
		-- AI
		if params.motionai then -- motion ai doesn't apply gravity
			self.motionAI = CAI.new(self.x, self.y, params.dx, params.dy)
			-- start moving for the AI
			if self.motionAI.dx then self.isright = true end
			if self.motionAI.dy then self.isdown = true end
		else -- actor ai applies gravity
			self.actorAI = CAI.new(self.x, self.y, params.dx, params.dy)
			-- start moving for the AI
			if self.actorAI.dx then self.isright = true
			elseif self.actorAI.dy then self.isdown = true
			end
		end
	end
end
