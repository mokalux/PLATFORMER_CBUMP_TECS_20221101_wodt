EPlayer1 = Core.class()

function EPlayer1:init(xspritelayer, x, y)
	-- ids
	self.isplayer1 = true
	self.isactor = true
	self.spritelayer = xspritelayer
	local texpath = "gfx/players/mixamo_Adventurer3_0001.png"
	-- params
	self.x = x
	self.y = y
	self.sx = 1 -- 1.7
	self.sy = self.sx
	self.flip = 1
	self.coyotetimer = 12
	self.currcoyotetimer = 0
	self.health = 20
	-- COMPONENTS
	-- ANIMATION
	local framerate = 1/14
	--function CAnimation:init(xspritesheetpath, xcols, xrows, xanimspeed, xoffx, xoffy, sx, sy)
--	self.animation = CAnimation.new(texpath, 13, 8, framerate, 14, 34, self.sx, self.sy) -- sensitive! 1.7
--	self.animation = CAnimation.new(texpath, 10, 8, framerate, 11, 24, self.sx, self.sy) -- sensitive!
	self.animation = CAnimation.new(texpath, 9, 6, framerate, 15, 39, self.sx, self.sy) -- sensitive!
	self.sprite = self.animation.sprite
	print("player1 original size: ", self.sprite:getWidth(), self.sprite:getHeight())
	print("player1 real size: ", self.sprite:getWidth()*self.sx, self.sprite:getHeight()*self.sy)
	self.animation.sprite = nil -- free some memory?
	-- create animations
	--function CAnimation:createAnim(xanimname, xstart, xfinish)
	self.animation:createAnim(g_ANIM_DEFAULT, 11, 19) -- win
	self.animation:createAnim(g_ANIM_IDLE_R, 1, 10)
	self.animation:createAnim(g_ANIM_WALK_R, 33, 41)
	self.animation:createAnim(g_ANIM_RUN_R, 33, 41)
	self.animation:createAnim(g_ANIM_JUMPUP_R, 23, 24) -- 20, 24
	self.animation:createAnim(g_ANIM_JUMPDOWN_R, 24, 25) -- 24, 26
	self.animation:createAnim(g_ANIM_LADDERIDLE, 27, 27)
	self.animation:createAnim(g_ANIM_LADDERUP, 27, 32)
	self.animation:createAnim(g_ANIM_LADDERDOWN, 48, 53)
	self.animation:createAnim(g_ANIM_LOSE1_R, 11, 19)
	self.animation:createAnim(g_ANIM_STOMP_R, 21, 21)
--	self.animation:createAnim(g_ANIM_WIN_R, 11, 19)
	self.animation.myanimsimgs = nil -- free some memory?
--	self.w, self.h = self.animation.w, self.animation.h
	self.w, self.h = 32, 32*3.5
--	self.w, self.h = self.animation.w, self.animation.h
	print("player1 body size: ", self.w, self.h)
	-- BODY
	--function CBody:init(xaccel, xjumpspeed)
	local mass = 0.2 -- 4
--	self.body = CBody.new(64*42*framerate, g_gravity*mass*28) -- g_gravity*32???
--	self.body = CBody.new(64*42*framerate, g_gravity*mass*8) -- g_gravity*32???
--	self.body = CBody.new(64*3, g_gravity*mass*1.5) -- g_gravity*32???
--	self.body = CBody.new(48*framerate, g_gravity*mass*1.3) -- g_gravity*32???
	self.body = CBody.new(8*0.4, mass*8*14.0)
--	self.body = CBody.new(8*0.3, mass*8*0.13) -- tests
	self.body.defaultmass = mass
	self.body.currmass = self.body.defaultmass
end
