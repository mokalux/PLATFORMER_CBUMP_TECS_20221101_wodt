EPlayer1 = Core.class()

function EPlayer1:init(xspritelayer, x, y)
	-- ids
	self.isplayer1 = true
	self.isactor = true
	self.spritelayer = xspritelayer
	local texpath = "gfx/players/_Character_zm_0001.png"
	-- params
	self.x = x
	self.y = y
	self.sx = 1.2
	self.sy = self.sx
	self.flip = 1
	-- COMPONENTS
	-- ANIMATION
	local framerate = 1/12
	--function CAnimation:init(xspritesheetpath, xcols, xrows, xanimspeed, xoffx, xoffy, sx, sy)
	self.animation = CAnimation.new(texpath, 13, 8, framerate, 12, 17, self.sx, self.sy) -- sensitive!
	self.sprite = self.animation.sprite
	self.animation.sprite = nil -- free some memory?
	-- create animations
	--function CAnimation:createAnim(xanimname, xstart, xfinish)
	self.animation:createAnim(g_ANIM_DEFAULT, 64, 91) -- win
	self.animation:createAnim(g_ANIM_IDLE_R, 1, 14)
	self.animation:createAnim(g_ANIM_WALK_R, 46, 63)
	self.animation:createAnim(g_ANIM_RUN_R, 36, 45)
	self.animation:createAnim(g_ANIM_JUMPUP_R, 15, 19)
	self.animation:createAnim(g_ANIM_JUMPDOWN_R, 19, 23) -- 20, 23
	self.animation:createAnim(g_ANIM_LADDERIDLE, 28, 28)
	self.animation:createAnim(g_ANIM_LADDERUP, 24, 35)
	self.animation:createAnim(g_ANIM_LADDERDOWN, 92, 103)
	self.animation:createAnim(g_ANIM_WIN_R, 80, 91)
	self.animation.myanimsimgs = nil -- free some memory?
--	self.w, self.h = self.animation.w, self.animation.h
	self.w, self.h = 26, 96
--	self.w, self.h = self.animation.w, self.animation.h
	print("player1 size: ", self.w, self.h)
	-- BODY
	--function CBody:init(xaccel, xjumpspeed)
	local mass = 2 -- 4
--	self.body = CBody.new(64*42*framerate, g_gravity*mass*28) -- g_gravity*32???
--	self.body = CBody.new(64*42*framerate, g_gravity*mass*8) -- g_gravity*32???
--	self.body = CBody.new(64*3, g_gravity*mass*1.5) -- g_gravity*32???
--	self.body = CBody.new(48*framerate, g_gravity*mass*1.3) -- g_gravity*32???
	self.body = CBody.new(8*0.4, mass*8*1.4)
--	self.body = CBody.new(8*0.3, mass*8*0.13) -- tests
	self.body.defaultmass = mass
	self.body.currentmass = self.body.defaultmass
end
